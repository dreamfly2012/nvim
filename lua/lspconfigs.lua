local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', function()
    if vim.diagnostic.jump then
        vim.diagnostic.jump({ count = -1, float = true })
    else
        vim.diagnostic.goto_prev()
    end
end, opts)
vim.keymap.set('n', ']d', function()
    if vim.diagnostic.jump then
        vim.diagnostic.jump({ count = 1, float = true })
    else
        vim.diagnostic.goto_next()
    end
end, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, opts)

-- 诊断显示(取代早期版本里对 vim.lsp.diagnostic handler 的覆盖)
vim.diagnostic.config({
    underline = true,
    severity_sort = true,
    virtual_text = { spacing = 2 },
    float = { border = 'rounded' },
})

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { buffer = ev.buf, silent = true }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format { async = true }
        end, bufopts)
    end,
})

-- ------------------------- nvim-cmp --------------------------------------
local has_words_before = function()
    local unpack = unpack or table.unpack
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local ok_luasnip, luasnip = pcall(require, 'luasnip')
local ok_cmp, cmp = pcall(require, 'cmp')
if not (ok_luasnip and ok_cmp) then
    return
end

local ok_autopairs, cmp_autopairs = pcall(require, 'nvim-autopairs.completion.cmp')
if ok_autopairs then
    cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
end

-- nvim-cmp setup
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm {
            -- behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = cmp.mapping(function(fallback)
            if vim.fn.pumvisible() == 1 then
                feedkey("<down>")
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            elseif has_words_before() then
                cmp.complete()
            else
                fallback()
            end
        end, { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { 'i', 's' }),
    }),
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
        { name = 'path' },
    },
}
-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'cmp_git' }, -- You can specify the `cmp_git` source if you were installed it.
    }, {
        { name = 'buffer' },
    })
})

-- Use buffer source for `/` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        -- Do not show completion for words starting with '!'
        { name = 'cmdline', keyword_pattern = [[\!\@<!\w*]] },
    })
})

-- ------------------------- LSP servers -----------------------------------
-- 走本机代理下载 (与 git config 一致).
-- 注意: mason.setup{ env = ... } 不是 mason 的有效配置项 —— 它只会被塞进
-- settings 却无人读取, 且不报错, 代理会静默失效. mason 走 spawn.curl 下载,
-- 该调用不传 env, 子进程继承 Neovim 环境, curl 读取 HTTPS_PROXY 才真正生效.
-- 只在代理端口可达时注入: 代理没开就什么都不做, 不会连累 git/其他子进程.
do
    local alive, done = false, false
    local tcp = vim.uv.new_tcp()
    if tcp then
        tcp:connect("127.0.0.1", 10808, function(err)
            alive = (err == nil or err == 0)
            done = true
        end)
        vim.wait(300, function() return done end, 10)
        tcp:close()
    end
    if alive then
        local proxy = "http://127.0.0.1:10808"
        -- 大小写都设: curl/git 两种都认, 其他工具各取所需.
        -- NO_PROXY 保护本地流量 (LSP/debugger 的 loopback 通信) 不被带进代理.
        vim.env.HTTP_PROXY = proxy
        vim.env.HTTPS_PROXY = proxy
        vim.env.http_proxy = proxy
        vim.env.https_proxy = proxy
        vim.env.NO_PROXY = "localhost,127.0.0.1,::1"
        vim.env.no_proxy = "localhost,127.0.0.1,::1"
    end
end
require("mason").setup()
-- mason-nvim-dap: 桥接 mason 与 nvim-dap, 启动时自动下载 ensure_installed 里的调试器.
-- 只做安装, 不设 handlers => 不会覆盖 lua/dap/*.lua 里自定义的 adapters/configurations.
-- 注意: 必须在上面 require("mason").setup() 之后调用 (要读 mason 注册表和代理 env).
--       ensure_installed 用 nvim-dap 适配器名 (python/php/...), 不是 mason 包名.
require("mason-nvim-dap").setup {
    ensure_installed = {"codelldb", "python", "php", "delve"},
}
-- mason-lspconfig v2 默认 automatic_enable = true: 所有通过 mason 安装的
-- language server 会被自动 vim.lsp.enable(), 下面 vim.lsp.config() 的配置
-- 会与 nvim-lspconfig 自带的默认配置合并
require("mason-lspconfig").setup {
    ensure_installed = {
        'lua_ls', 'astro', 'clangd', 'html', 'cssls', 'tailwindcss',
        'rust_analyzer', 'gopls', 'pyright', 'ts_ls', 'svelte',
        'emmet_ls', 'intelephense', 'dockerls',
    },
}

local capabilities = vim.lsp.protocol.make_client_capabilities()
do
    local ok_cmp_lsp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    if ok_cmp_lsp then
        capabilities = cmp_lsp.default_capabilities()
    end
end

-- 所有 language server 都带上 nvim-cmp 的补全能力
if vim.lsp.config then
    vim.lsp.config('*', { capabilities = capabilities })
end

if vim.lsp.config then
    vim.lsp.config("lua_ls", {
        settings = {
            Lua = {
                runtime = {
                    -- Neovim 内置 Lua 是 LuaJIT
                    version = "LuaJIT",
                },
                diagnostics = {
                    globals = { "vim" }, -- 让 vim 不再报未定义
                },
                workspace = {
                    library = vim.api.nvim_get_runtime_file("", true), -- 加载 Neovim runtime
                    checkThirdParty = false, -- 不用第三方提示
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    })

    vim.lsp.config("emmet_ls", {
        capabilities = capabilities,
        filetypes = { 'svelte', 'html', 'typescriptreact', 'javascriptreact', 'css', 'sass', 'scss', 'less' },
        init_options = {
            html = {
                options = {
                    -- For possible options, see: https://github.com/emmetio/emmet/blob/master/src/config.ts#L79-L267
                    ["bem.enabled"] = true,
                },
            },
        }
    })
end
