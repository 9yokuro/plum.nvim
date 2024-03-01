local M = {}

local cmd = vim.cmd

local group = "plum"

vim.api.nvim_create_augroup(group, {})

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

function M.add_plugin(plugin, lazy, event)
	if lazy then
		vim.api.nvim_create_autocmd(event, {
			group = group,
			callback = function()
				cmd.packadd(M.get_file_name(plugin))
			end,
		})
	else
		cmd.packadd(M.get_file_name(plugin))
	end
end

function M.remove_plugins(plugins)
	local plugin_dir = M.get_plugin_dir()

	for repository in io.popen("ls " .. plugin_dir):lines() do
		if not M.contains(M.map(M.get_file_name, M.plugin_repos(plugins)), repository) then
			vim.fn.system({
				"rm",
				"-rf",
				plugin_dir .. repository,
			})
		end
	end
end

function M.plugin_repos(plugins)
	local result = {}

	for i = 1, #plugins do
		table.insert(result, plugins[i].repo)
	end

	return result
end

function M.update_plugins()
	local plugin_dir = M.get_plugin_dir()

	for repository in io.popen("ls " .. plugin_dir):lines() do
		cmd.cd(plugin_dir .. repository)

		vim.fn.system({
			"git",
			"pull",
		})
	end

	cmd.redraw()
end

function M.setup(plugins)
	if plugins == nil then
		return nil
	end

	local plugin_dir = M.get_plugin_dir()

	for i = 1, #plugins do
		local plugin = plugins[i]

		if plugin.repo == nil then
			goto continue
		end

		M.clone_repository(plugin_dir, plugin.repo)

		if plugin.lazy then
			local event = {}

			if plugin.event == nil then
				event = "VimEnter"
			else
				event = plugin.event
			end

			M.add_plugin(plugin.repo, true, event)
		else
			M.add_plugin(plugin.repo, false, nil)
		end

		::continue::
	end

	vim.api.nvim_create_user_command("PlumUpdate", function()
		M.update_plugins()
	end, {})

	vim.api.nvim_create_user_command("PlumClean", function()
		M.remove_plugins(plugins)
	end, {})
end

return M
