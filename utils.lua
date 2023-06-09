local api = vim.api

local M = {}

function M.alpha_on_bye(cmd)
	local bufs = vim.fn.getbufinfo({ buflisted = true })
	vim.cmd(cmd)
	if require("astronvim.utils").is_available("alpha-nvim") and not bufs[2] then
		require("alpha").start(true)
	end
end

function M.augroup(name, commands)
	local id = api.nvim_create_augroup(name, { clear = true })
	for _, autocmd in ipairs(commands) do
		local is_callback = type(autocmd.command) == "function"
		api.nvim_create_autocmd(autocmd.event, {
			group = name,
			pattern = autocmd.pattern,
			desc = autocmd.description,
			callback = is_callback and autocmd.command or nil,
			command = not is_callback and autocmd.command or nil,
			once = autocmd.once,
			nested = autocmd.nested,
			buffer = autocmd.buffer,
		})
	end
	return id
end

function M.vim_opt_toggle(opt, on, off, name)
	local message = name
	if vim.opt[opt]._value == off then
		vim.opt[opt] = on
		message = message .. " Enabled"
	else
		vim.opt[opt] = off
		message = message .. " Disabled"
	end
	vim.notify(message, "info", {})
end

return M
