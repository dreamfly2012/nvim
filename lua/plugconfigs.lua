local npairs = require 'nvim-autopairs'

npairs.setup({
    fast_wrap = {
        map = '<M-e>',
        chars = { '{', '[', '(', '"', "'" },
        pattern = [=[[%'%"%)%>%]%)%}%,]]=],
        end_key = '$',
        keys = 'qwertyuiopzxcvbnmasdfghjkl',
        check_comma = true,
        highlight = 'Search',
        highlight_grey = 'Comment'
    },
})

require 'lualine'.setup({
    options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
            statusline = {},
            winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        globalstatus = false,
        refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
        }
    },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'branch', 'diff', 'diagnostics' },
        lualine_c = { 'filename' },
        lualine_x = { 'encoding', 'fileformat', 'filetype' },
        lualine_y = { 'progress' },
        lualine_z = { 'location' }
    },
    inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { 'filename' },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {}
    },
    tabline = {},
    winbar = {},
    inactive_winbar = {},
    extensions = {}
})

require 'nvim-web-devicons'.setup {
    -- your personnal icons can go here (to override)
    -- you can specify color or cterm_color instead of specifying both of them
    -- DevIcon will be appended to `name`
    override = {
        zsh = {
            icon = "",
            color = "#428850",
            cterm_color = "65",
            name = "Zsh"
        }
    },
    -- globally enable different highlight colors per icon (default to true)
    -- if set to false all icons will have the default icon's color
    color_icons = true,
    -- globally enable default icons (default to false)
    -- will get overriden by `get_icons` option
    default = true,
}

-- find_files 优先使用 fd(速度快), 没装 fd 时回退到 telescope 内置的 find
local find_command = nil
if vim.fn.executable('fd') == 1 or vim.fn.executable('fdfind') == 1 then
    local fd = vim.fn.executable('fd') == 1 and 'fd' or 'fdfind'
    find_command = { fd, '--type', 'f', '--strip-cwd-prefix', '--hidden', '--exclude', '.git' }
end

require('telescope').setup {
    defaults = {
        -- Default configuration for telescope goes here:
        -- config_key = value,
        layout_config = {
            horizontal = {
                preview_cutoff = 0,
            },
        },
        -- 配置 fd 来替代 find
        find_command = find_command,

        -- 排除不需要的目录和文件类型
        file_ignore_patterns = {
            "node_modules", "venv", ".git", "__pycache__", "%.pyc", "%.lock", "dist", "build"
        },
        mappings = {
            i = {
                -- map actions.which_key to <C-h> (default: <C-/>)
                -- actions.which_key shows the mappings for your picker,
                -- e.g. git_{create, delete, ...}_branch for the git_branches picker
                ["<C-h>"] = "which_key"
            }
        }
    },
    pickers = {
        -- Default configuration for builtin pickers goes here:
        -- picker_name = {
        --   picker_config_key = value,
        --   ...
        -- }
        -- Now the picker_config_key will be applied every time you call this
        -- builtin picker
    },
    extensions = {
        media_files = {
            -- filetypes whitelist
            -- defaults to {"png", "jpg", "mp4", "webm", "pdf"}
            filetypes = { "png", "webp", "jpg", "jpeg" },
            find_cmd = "rg" -- find command (defaults to `fd`)
        },
        fzf = {
            fuzzy = true,                   -- false will only do exact matching
            override_generic_sorter = true, -- override the generic sorter
            override_file_sorter = true,    -- override the file sorter
            case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
        }
    }
}

local neotest = require 'neotest'
neotest.setup({
    icons = {
        expanded = "",
        child_prefix = "",
        child_indent = "",
        final_child_prefix = "",
        non_collapsible = "",
        collapsed = "",
        passed = "",
        running = "",
        failed = "",
        unknown = ""
    },
    adapters = {
        require('neotest-phpunit')({
            phpunit_cmd = function()
                return 'vendor/bin/phpunit'
            end
        })
    }
})

-- ------------------------- treesitter -------------------------------------
-- 兼容两个版本的 nvim-treesitter:
--   * master 分支 (Neovim <= 0.11): require("nvim-treesitter.configs")
--   * main   分支 (Neovim >= 0.12): require("nvim-treesitter") + install()
local ts_parsers = {
    "tsx", "astro", "python", "c", "cpp", "toml", "javascript", "php", "go",
    "json", "http", "yaml", "html", "scss", "css", "lua", "vim", "vimdoc",
    "bash", "markdown", "markdown_inline", "query",
}

pcall(function()
    local ts_install = require("nvim-treesitter.install")
    ts_install.prefer_git = true
    -- Windows 上未安装 MSVC(cl.exe) 时, 优先使用 gcc(scoop 安装)
    if vim.fn.executable("cl.exe") ~= 1 then
        ts_install.compilers = { "gcc", "clang", "cc" }
    end
end)

local ok_master, ts_configs = pcall(require, "nvim-treesitter.configs")
if ok_master then
    ts_configs.setup({
        highlight = {
            enable = true,
            disable = {},
        },
        indent = {
            enable = false,
            disable = {},
        },
        ensure_installed = ts_parsers,
        auto_install = false,
    })
else
    local ok_ts, ts = pcall(require, "nvim-treesitter")
    if ok_ts then
        ts.setup({
            install_dir = vim.fn.stdpath("data") .. "/site",
        })
        -- parser 名称与 filetype 的对应关系
        pcall(vim.treesitter.language.register, "tsx", { "typescriptreact" })
        pcall(vim.treesitter.language.register, "javascript", { "javascriptreact" })

        if vim.fn.executable('tree-sitter') == 1 then
            pcall(ts.install, ts_parsers)
        else
            vim.schedule(function()
                vim.notify(
                    "[config] tree-sitter CLI 未安装: treesitter 高亮不可用, 安装方法见 README.md",
                    vim.log.levels.INFO,
                    { title = "nvim config" }
                )
            end)
        end

        -- main 分支的高亮需要按 filetype 手动开启
        vim.api.nvim_create_autocmd('FileType', {
            pattern = {
                "tsx", "astro", "python", "c", "cpp", "toml", "javascript",
                "javascriptreact", "typescript", "typescriptreact", "php",
                "go", "json", "http", "yaml", "html", "scss", "css", "lua",
                "vim", "vimdoc", "bash", "markdown",
            },
            group = vim.api.nvim_create_augroup('TreesitterHighlight', { clear = true }),
            callback = function(ev)
                -- 解析器未安装时静默跳过
                pcall(vim.treesitter.start, ev.buf)
            end,
        })
    end
end

require("toggleterm").setup {
    open_mapping = [[<c-\>]],
    direction = "float",
}

-- ------------------------- nvim-tree --------------------------------------
local status, nvim_tree = pcall(require, "nvim-tree")
if (not status) then
    return
end
nvim_tree.setup({
    sync_root_with_cwd = true,
    reload_on_bufenter = true,
    disable_netrw = false,
    hijack_netrw = true,
    auto_reload_on_write = true,
    open_on_tab = false,
    hijack_cursor = false,
    hijack_unnamed_buffer_when_opening = false,
    hijack_directories = {
        enable = true,
    },
    diagnostics = {
        enable = false,
    },
    update_focused_file = {
        enable = true,
        update_root = false,
        ignore_list = {}
    },
    filters = {
        dotfiles = false,
        custom = { "^\\.git$" }
    },
    git = {
        enable = true,
        ignore = true,
        timeout = 500,
    },
    view = {
        width = 25,
        side = 'left',
        preserve_window_proportions = true,
        number = false,
        relativenumber = false,
        signcolumn = "yes"
    },
    -- Windows 没有 trash 命令, 用 PowerShell 回收站代替
    trash = {
        cmd = (vim.fn.has('win32') == 1 or vim.fn.has('win64') == 1)
            and "powershell Remove-Item -Recurse -Force"
            or "trash",
        require_confirm = true,
    },
    actions = {
        change_dir = {
            enable = true,
            global = false,
        },
        open_file = {
            quit_on_open = false,
            resize_window = true,
            window_picker = {
                enable = true,
                chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890",
                exclude = {
                    filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame", },
                    buftype = { "nofile", "terminal", "help", },
                }
            }
        }
    },
})
