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
        'fatih/vim-go'
    }
    use {
        'windwp/nvim-ts-autotag'
    }
    use {"ellisonleao/glow.nvim"}
    use {
        "NTBBloodbath/rest.nvim",
        requires = { "nvim-lua/plenary.nvim" },
        config = function()
            require("rest-nvim").setup({
                -- Open request results in a horizontal split
                result_split_horizontal = false,
                -- Skip SSL verification, useful for unknown certificates
                skip_ssl_verification = false,
                -- Highlight request on run
                highlight = {
                    enabled = true,
                    timeout = 150,
                },
                result = {
                    -- toggle showing URL, HTTP info, headers at top the of result window
                    show_url = true,
                    show_http_info = true,
                    show_headers = true,
                },
                -- Jump to request line on run
                jump_to_request = false,
                env_file = '.env',
                custom_dynamic_variables = {},
                yank_dry_run = true,
            })
        end
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
