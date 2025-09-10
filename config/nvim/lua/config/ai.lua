local function get_openai_api_key()
	local handle = io.popen([[usso -ussh genai-api -print "$@" 2>&1 | awk '/eyJ/ {print $NF}' | head -n 1]])
	if handle then
		local result = handle:read("*a")
		handle:close()
		-- Trim whitespace
		return result:gsub("^%s+", ""):gsub("%s+$", "")
	end
	return nil
end
vim.env.OPENAI_API_KEY = get_openai_api_key()
