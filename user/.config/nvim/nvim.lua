
require('use-packer')

require("presence"):setup()
require('lualine').setup {
	options = {
		theme = 'gruvbox'
	}
}

vim.opt.mouse = "a"
vim.keymap.set("n", "<RightMouse>", [[<Nop>]])
vim.keymap.set("n", "<RightDrag>", [[<Cmd>lua require("gesture").draw()<CR>]], { silent = true })
vim.keymap.set("n", "<RightRelease>", [[<Cmd>lua require("gesture").finish()<CR>]], { silent = true })

local gesture = require("gesture")
gesture.register({
	name = "scroll to bottom",
	inputs = { gesture.up(), gesture.down() },
	action = "normal! G",
})
gesture.register({
	name = "next tab",
	inputs = { gesture.right() },
	action = "tabnext",
})
gesture.register({
	name = "previous tab",
	inputs = { gesture.left() },
	action = function(ctx) -- also can use callable
		vim.cmd("tabprevious")
	end,
})
gesture.register({
	name = "go back",
	inputs = { gesture.right(), gesture.left() },
	-- map to `<C-o>` keycode
	action = [[lua vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-o>", true, false, true), "n", true)]],
})

require("startup").setup({
	theme = "evil"
})

return
