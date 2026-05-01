local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		'nvim-telescope/telescope.nvim',
		tag = '0.1.0',
		dependencies = { 'nvim-lua/plenary.nvim' }
	},

	{
		'rose-pine/neovim',
		config = function()
			vim.cmd('colorscheme rose-pine')
		end
	},

	-- {
	-- 	'nvim-treesitter/nvim-treesitter',
	-- 	config = function()
	-- 		vim.cmd(':TSUpdate')
	-- 	end
	-- },

	-- 'nvim-treesitter/playground',

	-- { 'VonHeikemen/lsp-zero.nvim', branch = 'v3.x' },
	-- { 'neovim/nvim-lspconfig' },
	-- { 'hrsh7th/cmp-nvim-lsp' },
	-- { 'hrsh7th/nvim-cmp' },
	-- { 'L3MON4D3/LuaSnip' },
	-- 'mbbill/undotree',
	-- 'tpope/vim-fugitive',
	-- "folke/which-key.nvim",
	-- "folke/tokyonight.nvim",
	-- { "folke/neoconf.nvim", cmd = "Neoconf" },
	-- "folke/trouble.nvim",
	-- "folke/neodev.nvim",
	-- "LazyVim/LazyVim",
})



vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)

-- vim.opt.guicursor = ""

vim.opt.nu = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false
-- vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.g.mapleader = ' '
