vim.cmd [[set packpath+=$XDG_STATE_HOME/nvim/site]]

-- vim.cmd [[packadd packer.nvim]]
require('packer').startup(function()
	use 'wbthomason/packer.nvim'

	-- status lines
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}

	-- file explorers
	use 'preservim/nerdtree'
	-- use {
	-- 	'kyazdani42/nvim-tree.lua',
	-- 	requires = {
	-- 		'kyazdani42/nvim-web-devicons',
	-- 	},
	-- 	tag = 'nightly' -- optional, updated every week. (see issue #1193)
	-- }

	-- formatting
	use 'gpanders/editorconfig.nvim'

	use {
		'numToStr/Comment.nvim',
		config = function()
			require('Comment').setup()
		end
	}

	use {
		"folke/todo-comments.nvim",
		requires = "nvim-lua/plenary.nvim",
		config = function()
		require("todo-comments").setup {
			-- your configuration comes here
			-- or leave it empty to use the default settings
			-- refer to the configuration section below
		}
		end
	}

	-- startup
	use 'startup-nvim/startup.nvim'
	-- use {
	-- 	'goolord/alpha-nvim',
	-- 	requires = { 'kyazdani42/nvim-web-devicons' },
	-- 	config = function ()
	-- 		require'alpha'.setup(require'alpha.themes.startify'.config)
	-- 	end
	-- }

	-- misc
	use {
		'neoclide/coc.nvim',
		branch = 'release'
	}
	use 'andweeb/presence.nvim'
	use 'notomo/gesture.nvim'


	use {
		'nvim-telescope/telescope.nvim',
		requires = { {'nvim-lua/plenary.nvim'} }
	}

end)

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
