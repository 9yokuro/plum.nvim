local M = {}

function M.contains(array, element)
	for i = 1, #array do
		if array[i] == element then
			return true
		end
	end

	return false
end

function M.exists(path)
	local f = io.open(path, "r")

	return f ~= nil and io.close(f)
end

function M.map(fn, array)
	local result = {}

	for i = 1, #array do
		table.insert(result, fn(array[i]))
	end

	return result
end

function M.get_file_name(path)
	return path:match("^.+/(.+)$")
end

function M.get_xdg_data_home()
	local xdg_data_home = os.getenv("XDG_DATA_HOME")

	if xdg_data_home == nil then
		xdg_data_home = os.getenv("HOME") .. "/.local/share"
	end

	return xdg_data_home
end

function M.get_plugin_dir()
	return M.get_xdg_data_home() .. "/nvim/site/pack/plum/opt/"
end

function M.initialize(plugin_dir)
	if not M.exists(plugin_dir) then
		os.execute("mkdir -p " .. plugin_dir)
	end
end

function M.clone_repository(plugin_dir, plugin)
	local plugin_path = plugin_dir .. M.get_file_name(plugin)

	if not M.exists(plugin_path) then
		os.execute("git clone https://github.com/" .. plugin .. " " .. plugin_path)
	end
end

function M.add_plugin(plugin)
	vim.cmd.packadd(M.get_file_name(plugin))
end

function M.remove_plugins(plugins, plugin_dir)
	for repository in io.popen("ls " .. plugin_dir):lines() do
		if not M.contains(M.map(M.get_file_name, plugins), repository) then
			os.execute("rm -rf " .. plugin_dir .. repository)
		end
	end
end

function M.update_plugins(pludin_dir)
	for repository in io.popen("ls " .. plugin_dir):lines() do
		vim.cmd.cd(plugin_dir .. repository)

		os.execute("git pull")
	end
end

function M.setup(plugins)
	if plugins == nil then
		return nil
	end

	local plugin_dir = M.get_plugin_dir()

	M.initialize(plugin_dir)

	for i = 1, #plugins do
		M.clone_repository(plugin_dir, plugins[i])

		M.add_plugin(plugins[i])
	end

	vim.api.nvim_create_user_command("PlumUpdate", function()
		M.update_plugins(plugin_dir)
	end, {})

	vim.api.nvim_create_user_command("PlumClean", function()
		M.remove_plugins(plugins, pludin_dir)
	end, {})
end

return M
