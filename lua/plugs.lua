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
        'windwp/nvim-autopairs'
    }
    use {
        'hotoo/pangu.vim'
    }
    use {
        "folke/zen-mode.nvim",
        config = function()
            require("zen-mode").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }
    use {
        "mfussenegger/nvim-dap",
        config = function()
            require("dap.nvim-dap")
        end
    }
    -- 为代码调试提供内联文本
    use {
        "theHamsta/nvim-dap-virtual-text",
        requires = {
            "mfussenegger/nvim-dap"
        },
        config = function()
            require("dap.nvim-dap-virtual-text")
        end
    }
    -- 为代码调试提供 UI 界面
    use {
        "rcarriga/nvim-dap-ui",
        requires = {
            "mfussenegger/nvim-dap"
        },
        config = function()
            require("dap.nvim-dap-ui")
        end
    }
    use {
        'akinsho/toggleterm.nvim'
    }
    use {
        'godlygeek/tabular'
    }
    use {
        'azadkuh/vim-cmus'
    }
    use {
        'mattn/emmet-vim'
    }
    use {
        'github/copilot.vim'
    }
    use {
        'junegunn/fzf',
        'junegunn/fzf.vim'
    }
    use {
        'fatih/vim-go',
        'buoto/gotests-vim'
    }
    use {
        'windwp/nvim-ts-autotag'
    }
    use {"ellisonleao/glow.nvim"}
	use {
		'kyazdani42/nvim-tree.lua',
		requires = {
			'kyazdani42/nvim-web-devicons', -- optional, for file icon
		},
		config = function() require'nvim-tree'.setup {} end
	}
	use 'Mofiqul/dracula.nvim'
    use 'L3MON4D3/LuaSnip'
	use { 'tami5/lspsaga.nvim' }  -- nightly
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
