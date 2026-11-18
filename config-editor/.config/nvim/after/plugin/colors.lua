require('rose-pine').setup({
	disable_background = true
})

function ColorThings(color)
	color = color or '734-light'
	vim.cmd.colorscheme(color)

	if color == 'rose-pine' then
		vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
		vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })
	end
end

ColorThings()
