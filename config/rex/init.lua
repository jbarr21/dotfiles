-- >>> rex-resurrect
-- Autosave sessions every 15 minutes and fill blank panes from the last
-- snapshot when the app attaches. Installed by rex-resurrect/install.lua.
do
  local script = os.getenv("HOME") .. "/.config/rex/resurrect.lua"
  local f = io.open(script, "r")
  if f then
    f:close()
    -- The rex binary running this server, so the daemon talks to it.
    -- After an upgrade Linux reports the old binary as "PATH (deleted)".
    local r = rex.exec({ "sh", "-c", 'b=$(readlink /proc/$PPID/exe 2>/dev/null || ps -ww -o comm= -p $PPID);'
      .. ' b=${b% (deleted)}; [ -x "$b" ] || b=$(command -v rex); echo "$b"' })
    local bin = (r and r.ok and r.stdout:gsub("%s+$", "")) or "rex"
    if bin == "" then bin = "rex" end

    -- At server start the config loads before the server listens, so wait
    -- for it to answer before connecting.
    local WAIT = 'i=0; while [ $i -lt 60 ] && ! "$0" --autostart=false server status >/dev/null 2>&1; do'
      .. ' i=$((i+1)); sleep 0.5; done; log=$HOME/.local/share/rex-resurrect; mkdir -p "$log";'
      .. ' exec "$0" --autostart=false do "$@" >>"$log/daemon.log" 2>&1'
    local function run(...)
      return rex.exec.start({ "sh", "-c", WAIT, bin, script, ... }, { detach = true })
    end

    -- The daemon exits right away if one is already running, so config
    -- reloads don't start a second one.
    run("mode=daemon", "interval=900", "--all")

    rex.action{
      name = "resurrect_save", title = "Resurrect: Save Sessions",
      description = "Snapshot every session's layout, directories, and scrollback.",
      run = function() run("mode=save") end,
    }
    rex.action{
      name = "resurrect_restore", title = "Resurrect: Restore Sessions",
      description = "Recreate missing sessions and fill blank panes from the last snapshot.",
      run = function() run("mode=restore") end,
    }
  end
end
-- <<< rex-resurrect
