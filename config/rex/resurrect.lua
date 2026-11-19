-- rex-resurrect: save and restore Rex sessions, like tmux-resurrect/continuum.
--
-- Runs on the same machine as the Rex server it manages (macOS or Linux), so
-- process lookups, snapshot files, and scrollback replay are all local to the
-- shells. init.lua starts the daemon when the server loads its config.
--
--   rex do resurrect.lua mode=save               -- snapshot now
--   rex do resurrect.lua mode=restore [file=F]   -- recreate missing sessions, fill blank panes
--   rex do resurrect.lua mode=fill [file=F]      -- fill blank panes only
--   rex do resurrect.lua mode=daemon --all       -- autosave + fill blank panes on attach
--
-- Snapshots: ~/.local/share/rex-resurrect/last.json plus timestamped copies.

local HOME = os.getenv("HOME")
local DIR = os.getenv("REX_RESURRECT_DIR") or (HOME .. "/.local/share/rex-resurrect")
local KEEP = 10                -- timestamped snapshots to keep
local MAX_LINES = 2000         -- scrollback lines saved per pane
-- Only restore missing sessions at daemon start if the server is this fresh,
-- so a daemon restart doesn't bring back sessions you closed on purpose.
local FRESH_SERVER_SECS = 300
-- Foreground programs relaunched on restore (matched on process name).
local RESTORE_PROGRAMS = {
  vi = true, vim = true, nvim = true, emacs = true, nano = true,
  less = true, man = true, top = true, htop = true, btop = true,
  tail = true, watch = true, ssh = true, mosh = true,
}
local SHELLS = { zsh = true, bash = true, fish = true, sh = true, nu = true, login = true }
local TERMINAL = "com.superlogical.terminal"

local args = rex.args or {}
local daemon_mode = false

-- Helpers ------------------------------------------------------------------

local function shell_quote(s)
  return "'" .. tostring(s):gsub("'", "'\\''") .. "'"
end

local function read_file(path)
  local f = io.open(path, "r")
  if not f then return nil end
  local s = f:read("*a")
  f:close()
  return s
end

local function write_file(path, data)
  local tmp = path .. ".tmp"
  local f = assert(io.open(tmp, "w"))
  f:write(data)
  f:close()
  assert(os.rename(tmp, path))
end

local function lines_of(text)
  local t = {}
  for line in (text .. "\n"):gmatch("(.-)\n") do t[#t + 1] = line end
  return t
end

local function trim_right(s)
  return (s:gsub("%s+$", ""))
end

local function block_call(session_id, block_id, method, margs)
  return rex.call("block.method", {
    session_id = session_id, block_id = block_id, method = method, args = margs or {},
  })
end

-- Full command line of a pid. /proc keeps the exact argv on Linux; ps -ww
-- keeps it untruncated on macOS.
local function process_args(pid)
  local raw = read_file("/proc/" .. pid .. "/cmdline")
  if raw and #raw > 0 then
    local parts = {}
    for a in raw:gmatch("([^%z]*)%z") do
      parts[#parts + 1] = a:match("^[%w%-_./=:,@+]+$") and a or shell_quote(a)
    end
    return table.concat(parts, " ")
  end
  local r = rex.exec({ "ps", "-ww", "-o", "args=", "-p", tostring(pid) })
  if r and r.ok then return trim_right(r.stdout) end
end

-- The whole screen and scrollback, reading large output in parts. format is
-- "text" (the default) or "vt", which keeps colors and styles as escape
-- sequences that replay with cat.
local function terminal_text(session_id, block_id, format)
  local out = block_call(session_id, block_id, "format",
    { format = format or "text", trim = true, unwrap = true, max_bytes = 983040 })
  if not out then return nil end
  local parts, offset = { out.content or "" }, #(out.content or "")
  -- The rest comes from blob_read, which names its text data and says eof
  -- at the end.
  local id = out.id
  while id do
    local more = block_call(session_id, block_id, "blob_read", { id = id, offset = offset, max_bytes = 983040 })
    if not more or not more.data or #more.data == 0 then break end
    parts[#parts + 1] = more.data
    offset = offset + #more.data
    if more.eof then break end
  end
  return trim_right((table.concat(parts):gsub("\r\n", "\n")))
end

-- Session views need the script attached. The daemon stays attached to
-- everything so it keeps hearing events.
local function with_view(session_id, fn)
  rex.session.attach{ session_id = session_id }
  local view = rex.session.view{ session_id = session_id }
  local result = view and fn(view)
  if not daemon_mode and session_id ~= rex.session_id then
    rex.session.detach{ session_id = session_id }
  end
  return result
end

-- Layout trees -------------------------------------------------------------

-- Leaves of a layout tree keyed by path ("" for the root, then b/a for each
-- split's before/after side), so panes match by position across restarts.
local function leaves(node, path, out)
  out = out or {}
  path = path or ""
  if node.split then
    leaves(node.split.before, path .. "b", out)
    leaves(node.split.after, path .. "a", out)
  else
    out[path] = node
  end
  return out
end

local function shape(node)
  if not node.split then return "*" end
  return node.split.direction:sub(1, 1) .. "(" .. shape(node.split.before) .. ","
    .. shape(node.split.after) .. ")"
end

local function tiled_layout(window)
  for _, layer in ipairs(window.layers or {}) do
    if layer.kind == "tiled" and layer.layout then return layer end
  end
end

-- Save ---------------------------------------------------------------------

local function snapshot_terminal(session_id, block_id)
  local t = {}
  local proc = block_call(session_id, block_id, "process")
  local pwd = block_call(session_id, block_id, "pwd")
  local fg = proc and proc.foreground
  t.cwd = (fg and fg.cwd) or (pwd and pwd.pwd)
  if fg and fg.name and not SHELLS[fg.name] then
    t.program = fg.name
    t.command_line = process_args(fg.pid)
  end
  local text = terminal_text(session_id, block_id)
  if text and text:match("%S") then
    local ls = lines_of(text)
    local first = math.max(1, #ls - MAX_LINES + 1)
    t.scrollback = table.concat(ls, "\n", first)
    -- The colored copy is what gets replayed. The plain one decides where the
    -- prompt is, so keep the colored copy only if its lines line up.
    local vt = terminal_text(session_id, block_id, "vt")
    local vls = vt and lines_of(vt)
    if vls and #vls == #ls then
      t.scrollback_vt = table.concat(vls, "\n", first)
    end
  end
  return t
end

local function save_node(node, blocks, session_id)
  if node.split then
    local s = node.split
    return { split = {
      direction = s.direction, ratio = s.ratio,
      before = save_node(s.before, blocks, session_id),
      after = save_node(s.after, blocks, session_id),
    } }
  end
  local b = blocks[node.block_id] or {}
  local saved = { block_id = node.block_id, block = { flavor = b.flavor, label = b.label } }
  if b.creator_name == TERMINAL then
    saved.terminal = snapshot_terminal(session_id, node.block_id)
  end
  return saved
end

local function prune()
  local r = rex.exec({ "ls", "-1t", DIR })
  if not (r and r.ok) then return end
  local n = 0
  for name in r.stdout:gmatch("[^\n]+") do
    if name:match("^rex%-.*%.json$") then
      n = n + 1
      if n > KEEP then os.remove(DIR .. "/" .. name) end
    end
  end
end

local function save()
  rex.exec({ "mkdir", "-p", DIR })
  local list = assert(rex.call("session.list"))
  local state = { version = 2, saved_at = os.time(), sessions = {} }
  for _, s in ipairs(list.sessions or {}) do
    local sess = with_view(s.session_id, function(view)
      local out = { label = view.label, windows = {} }
      for _, w in ipairs(view.windows or {}) do
        -- Floating layers aren't saved; only the tiled layout.
        local layer = tiled_layout(w)
        if layer then
          local blocks = {}
          for _, b in ipairs(layer.blocks or {}) do blocks[b.block_id] = b end
          out.windows[#out.windows + 1] = {
            label = w.label,
            active = w.window_id == view.active_window_id or nil,
            layout = save_node(layer.layout, blocks, s.session_id),
          }
        end
      end
      return out
    end)
    if sess then state.sessions[#state.sessions + 1] = sess end
  end

  local json = rex.json.encode(state)
  local path = DIR .. "/rex-" .. os.date("%Y%m%d-%H%M%S") .. ".json"
  write_file(path, json)
  write_file(DIR .. "/last.json", json)
  prune()
  rex.log("info", "rex-resurrect: saved " .. #state.sessions .. " sessions to " .. path)
  return { saved = path, sessions = #state.sessions }
end

-- Restore ------------------------------------------------------------------

local function load_state(path)
  local data = read_file(path or args.file or (DIR .. "/last.json"))
  return data and rex.json.decode(data)
end

-- A saved node as a session.create layout node: plain shells in the saved
-- directories. Contents are filled in afterwards, like any blank pane.
local function layout_for(node)
  if node.split then
    local s = node.split
    return { split = {
      direction = s.direction, ratio = s.ratio,
      before = layout_for(s.before), after = layout_for(s.after),
    } }
  end
  local block = { flavor = node.block.flavor, label = node.block.label }
  if node.terminal and node.terminal.cwd then
    block.options = { cwd = node.terminal.cwd }
  end
  return { block = block }
end

local function windows_for(saved_session)
  local windows, active = {}, nil
  for i, w in ipairs(saved_session.windows) do
    windows[#windows + 1] = { window_label = w.label, layout = layout_for(w.layout) }
    if w.active then active = i end
  end
  return windows, active
end

-- Blank-pane filling ---------------------------------------------------------

local consumed = {}  -- "label|window|path" of saved panes already resolved
local seen = {}      -- live block IDs already checked

local function first_word(line)
  return line and line:match("^%s*(%S+)")
end

-- How the prompt looks at the end of a screen: its last line's first word
-- (such as ❯ or $) and how many lines it takes. A multi-line prompt counts
-- back to the blank line that starts it, such as starship's.
local function prompt_at_end(ls)
  local last = #ls
  while last > 0 and not ls[last]:match("%S") do last = last - 1 end
  if last == 0 then return nil end
  local height = 1
  for i = last - 1, math.max(1, last - 3), -1 do
    if not ls[i]:match("%S") then height = last - i + 1; break end
  end
  return { marker = first_word(ls[last]), last = last, height = height }
end

-- A fresh shell's screen: whatever its startup printed (direnv, motd), then
-- exactly one prompt, because every command run leaves another prompt line.
-- Returns the prompt's shape, or nil if the pane has been used.
--
-- A shell that just started may still be loading (direnv, mise), so wait
-- until its screen stops changing and, when we know what the prompt looked
-- like before, until it ends with that prompt again.
local function blank_prompt(session_id, block_id, marker)
  local text, prev, stable = nil, nil, 0
  for _ = 1, 80 do
    text = terminal_text(session_id, block_id)
    if text and text:match("%S") and text == prev then
      stable = stable + 1
      local p = prompt_at_end(lines_of(text))
      if stable >= 4 and (not marker or (p and p.marker == marker)) then break end
    else
      stable = 0
    end
    prev = text
    rex.sleep(0.25)
  end
  if not text then return nil end
  local proc = block_call(session_id, block_id, "process")
  local fg = proc and proc.foreground
  if fg and fg.name and not SHELLS[fg.name] then return nil end
  local ls = lines_of(text)
  local prompt = prompt_at_end(ls)
  if not prompt then return nil end
  for i = 1, prompt.last - 1 do
    if first_word(ls[i]) == prompt.marker then return nil end
  end
  return prompt
end

-- Replay a saved pane into a blank one: cd to its directory, print its
-- scrollback, and relaunch its program if it's on the list.
local function replay(session_id, block_id, saved, prompt)
  local t = saved.terminal
  if not t then return false end
  local cmd = {}
  if t.cwd then cmd[#cmd + 1] = "cd -- " .. shell_quote(t.cwd) .. " 2>/dev/null" end
  -- Clear the screen and scrollback, so the typed command doesn't show.
  cmd[#cmd + 1] = [[printf '\033[H\033[2J\033[3J']]
  if t.scrollback then
    local ls = lines_of(t.scrollback)
    -- A shell's saved screen ends with its prompt; drop it, since the
    -- shell draws a fresh one.
    local old = not t.program and prompt_at_end(ls)
    if old and old.marker == prompt.marker then
      for _ = old.last - prompt.height + 1, #ls do table.remove(ls) end
    end
    local keep = #ls
    local vls = t.scrollback_vt and lines_of(t.scrollback_vt)
    if vls then
      ls = {}
      for i = 1, keep do ls[i] = vls[i] end
    end
    if keep > 0 then
      rex.exec({ "mkdir", "-p", DIR .. "/replay" })
      local f = DIR .. "/replay/" .. block_id:gsub("[^%w]", "_") .. ".txt"
      -- End with a style reset so colors don't spill into the new prompt.
      write_file(f, table.concat(ls, "\n") .. "\27[0m\n")
      cmd[#cmd + 1] = "command cat -- " .. shell_quote(f)
      cmd[#cmd + 1] = "command rm -f -- " .. shell_quote(f)
    end
  end
  if t.program and RESTORE_PROGRAMS[t.program] and t.command_line then
    cmd[#cmd + 1] = t.command_line
  end
  -- The leading space keeps it out of history with HIST_IGNORE_SPACE.
  block_call(session_id, block_id, "write", { data = " " .. table.concat(cmd, "; ") .. "\n" })
  return true
end

local function session_blank(view)
  for _, w in ipairs(view.windows or {}) do
    for _, layer in ipairs(w.layers or {}) do
      for _, b in ipairs(layer.blocks or {}) do
        if not blank_prompt(view.session_id, b.block_id) then return false end
      end
    end
  end
  return true
end

local function view_shape(windows, get)
  local t = {}
  for _, w in ipairs(windows or {}) do
    local layout = get(w)
    t[#t + 1] = layout and shape(layout) or "-"
  end
  return table.concat(t, "|")
end

-- Swap a session's windows for the saved ones. Only used when every pane in
-- the session is blank, such as a session the app made after a restart.
local function rebuild(view, saved)
  local windows, active = windows_for(saved)
  local new_ids = {}
  for i, w in ipairs(windows) do
    local r = rex.session.new_window{ session_id = view.session_id, window_label = w.window_label,
      layout = w.layout, focus = (i == active) }
    new_ids[i] = r and r.window_id
  end
  for _, w in ipairs(view.windows or {}) do
    rex.session.close_window{ session_id = view.session_id, window_id = w.window_id }
  end
  return new_ids
end

local function fill_session(session_id, saved, filled)
  with_view(session_id, function(view)
    local label = view.label
    local pending = false
    for wi in ipairs(saved.windows) do
      for path in pairs(leaves(saved.windows[wi].layout)) do
        if not consumed[label .. "|" .. wi .. "|" .. path] then pending = true end
      end
    end
    if not pending then return end

    local live_shape = view_shape(view.windows, function(w)
      local l = tiled_layout(w); return l and l.layout end)
    local saved_shape = view_shape(saved.windows, function(w) return w.layout end)
    if live_shape ~= saved_shape and session_blank(view) then
      rebuild(view, saved)
      view = rex.session.view{ session_id = session_id }
    end

    -- Rex keeps block IDs across server restarts, so match on them first
    -- and fall back to position.
    local by_id = {}
    for _, w in ipairs(view.windows or {}) do
      for _, layer in ipairs(w.layers or {}) do
        for _, b in ipairs(layer.blocks or {}) do by_id[b.block_id] = { block_id = b.block_id } end
      end
    end

    for wi, sw in ipairs(saved.windows) do
      local lw = view.windows and view.windows[wi]
      local layer = lw and tiled_layout(lw)
      local live = layer and leaves(layer.layout) or {}
      for path, sleaf in pairs(leaves(sw.layout)) do
        local key = label .. "|" .. wi .. "|" .. path
        local lleaf = (sleaf.block_id and by_id[sleaf.block_id]) or live[path]
        if not consumed[key] and lleaf and not seen[lleaf.block_id] then
          local t = sleaf.terminal
          local saved_prompt = t and t.scrollback and not t.program and prompt_at_end(lines_of(t.scrollback))
          local prompt = blank_prompt(session_id, lleaf.block_id, saved_prompt and saved_prompt.marker)
          if prompt and replay(session_id, lleaf.block_id, sleaf, prompt) then
            filled[#filled + 1] = label .. " window " .. wi .. " pane " .. (path == "" and "root" or path)
          end
          consumed[key] = true
        end
      end
    end
    for _, w in ipairs(view.windows or {}) do
      for _, layer in ipairs(w.layers or {}) do
        for _, b in ipairs(layer.blocks or {}) do seen[b.block_id] = true end
      end
    end
  end)
end

local function fill(state)
  local by_label = {}
  for _, s in ipairs(state.sessions or {}) do by_label[s.label] = s end
  local filled = {}
  for _, s in ipairs((rex.call("session.list") or {}).sessions or {}) do
    if by_label[s.label] then fill_session(s.session_id, by_label[s.label], filled) end
  end
  return filled
end

local function restore_missing(state)
  local existing = {}
  for _, s in ipairs((rex.call("session.list") or {}).sessions or {}) do existing[s.label] = true end
  local restored = {}
  for _, sess in ipairs(state.sessions or {}) do
    if not existing[sess.label] and #sess.windows > 0 then
      local windows, active = windows_for(sess)
      -- session.create makes the last window active, so focus the saved one after.
      local r, err = rex.call("session.create", { label = sess.label, initial_windows = windows })
      if r then
        restored[#restored + 1] = sess.label
        local w = active and r.initial_windows[active]
        if w then
          rex.session.attach{ session_id = r.session_id }
          rex.session.focus_window{ session_id = r.session_id, window_id = w.window_id }
        end
      else
        rex.log("warn", "rex-resurrect: " .. sess.label .. ": " .. tostring(err))
      end
    end
  end
  return restored
end

-- Daemon -------------------------------------------------------------------

local function utc_seconds(iso)
  local y, mo, d, h, mi, s = iso:match("(%d+)-(%d+)-(%d+)T(%d+):(%d+):(%d+)")
  if not y then return nil end
  return os.time{ year = y, month = mo, day = d, hour = h, min = mi, sec = s }
end

local function server_uptime()
  local st = rex.call("server.status")
  local started = st and st.started_at and utc_seconds(st.started_at)
  return started and (os.time(os.date("!*t")) - started)
end

-- One daemon per server: init.lua runs again on every config reload.
local function take_lock()
  local pidfile = DIR .. "/daemon.pid"
  local old = read_file(pidfile)
  if old then
    old = old:match("%d+")
    local cmdline = old and process_args(old)
    if cmdline and cmdline:find("resurrect", 1, true) and cmdline:find("daemon", 1, true) then
      return false
    end
  end
  local r = rex.exec({ "sh", "-c", "echo $PPID" })
  write_file(pidfile, trim_right(r.stdout) .. "\n")
  return true
end

local function app_client(client_id)
  for _, c in ipairs((rex.call("client.list") or {}).clients or {}) do
    if c.client_id == client_id then return c.info and c.info.kind == "app" end
  end
  return false
end

local function daemon()
  daemon_mode = true
  rex.exec({ "mkdir", "-p", DIR })
  if not take_lock() then
    rex.log("info", "rex-resurrect: daemon already running")
    return rex.stop(0)
  end
  local interval = tonumber(args.interval) or 900

  -- Fill panes from the snapshot taken before this server started. On a
  -- fresh server that's last.json, kept as pending.json so autosaves don't
  -- replace it; a daemon restarted later keeps using pending.json.
  local up = server_uptime()
  local fresh = up and up < FRESH_SERVER_SECS
  local state
  if fresh then
    state = load_state()
    if state then write_file(DIR .. "/pending.json", rex.json.encode(state)) end
  else
    state = load_state(DIR .. "/pending.json")
  end
  if state then
    if fresh then
      local restored = restore_missing(state)
      local filled = fill(state)
      rex.log("info", "rex-resurrect: restored " .. #restored .. " sessions, filled " .. #filled .. " panes")
    end
  end

  local timer
  local function schedule()
    if not state or (timer and timer:active()) then return end
    timer = rex.after(1.5, function()
      local filled = fill(state)
      if #filled > 0 then
        rex.log("info", "rex-resurrect: filled " .. table.concat(filled, ", "))
      end
    end)
  end
  rex.on("client_joined", function(_, ev)
    if ev.client and ev.client.info and ev.client.info.kind == "app" then schedule() end
  end)
  rex.on("client_connected", function(_, ev)
    if app_client(ev.client_id) then schedule() end
  end)
  rex.on("session_created", function() schedule() end)

  rex.every(interval, function() save() end)
  rex.log("info", "rex-resurrect: autosaving every " .. interval .. "s")
end

local mode = args.mode or "save"
if mode == "save" then
  return save()
elseif mode == "restore" then
  local state = load_state()
  if not state then return { error = "no snapshot" } end
  return { restored = restore_missing(state), filled = fill(state) }
elseif mode == "fill" then
  local state = load_state()
  if not state then return { error = "no snapshot" } end
  return { filled = fill(state) }
elseif mode == "daemon" then
  daemon()
else
  error("unknown mode: " .. tostring(mode))
end
