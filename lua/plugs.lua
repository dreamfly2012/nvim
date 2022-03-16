local use = require('packer').use
require('packer').startup(function()
	use 'wbthomason/packer.nvim' -- Package manager
	use 'neovim/nvim-lspconfig' -- Collection of configurations for the built-in LSP client
	use { 'echasnovski/mini.nvim', branch = 'stable' }
	use {
		'nvim-lualine/lualine.nvim',
		requires = { 'kyazdani42/nvim-web-devicons', opt = true }
	}
	use {
		'kyazdani42/nvim-tree.lua',
		requires = {
			'kyazdani42/nvim-web-devicons', -- optional, for file icon
		},
		config = function() require'nvim-tree'.setup {} end
	}
	use 'Mofiqul/dracula.nvim'
	use { 'tami5/lspsaga.nvim' }  -- nightly
	use {
		'nvim-telescope/telescope.nvim',
		requires = { {'nvim-lua/plenary.nvim'} }
	}
	use { 'crispgm/nvim-go',
		requires = { 
			'nvim-lua/plenary.nvim',
			'nvim-lua/popup.nvim'
		},
		config = function() require'go'.setup{} end
	}
	use { 'nvim-treesitter/nvim-treesitter'}
	use {'hrsh7th/nvim-cmp'}
	use { 'nvim-lua/lsp-status.nvim'}
end)