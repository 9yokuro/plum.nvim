local M = {}

function M.contains(array, element)
	for i = 1, #array do
		if array[i] == element then
			return true
		end
	end

	return false
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

function M.get_plugin_dir()
	return vim.fn.stdpath("data") .. "/site/pack/plum/opt/"
end

function M.clone_repository(plugin_dir, plugin)
	local plugin_path = plugin_dir .. M.get_file_name(plugin)

	if not vim.loop.fs_stat(plugin_path) then
		vim.fn.system({
			"git",
			"clone",
			"--depth",
			"1",
			"https://github.com/" .. plugin,
			plugin_path,
		})
	end
end

function M.add_plugin(plugin)
	vim.cmd.packadd(M.get_file_name(plugin))
end

function M.remove_plugins(plugins)
	local plugin_dir = M.get_plugin_dir()

	for repository in io.popen("ls " .. plugin_dir):lines() do
		if not M.contains(M.map(M.get_file_name, plugins), repository) then
			vim.fn.system({
				"rm",
				"-rf",
				plugin_dir .. repository,
			})
		end
	end
end

function M.update_plugins()
	local plugin_dir = M.get_plugin_dir()

	for repository in io.popen("ls " .. plugin_dir):lines() do
		vim.cmd.cd(plugin_dir .. repository)

		vim.fn.system({
			"git",
			"pull",
		})
	end

	vim.cmd.redraw()
end

function M.setup(plugins)
	if plugins == nil then
		return nil
	end

	local plugin_dir = M.get_plugin_dir()

	for i = 1, #plugins do
		M.clone_repository(plugin_dir, plugins[i])

		M.add_plugin(plugins[i])
	end

	vim.api.nvim_create_user_command("PlumUpdate", function()
		M.update_plugins()
	end, {})

	vim.api.nvim_create_user_command("PlumClean", function()
		M.remove_plugins(plugins)
	end, {})
end

return M
