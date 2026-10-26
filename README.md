# nvim

适用于 **Neovim 0.11+**（推荐 0.12）的个人配置，纯 Lua 编写，插件管理使用
[lazy.nvim](https://github.com/folke/lazy.nvim)（首次启动自动下载安装）。

在 **Neovim 0.12.6** 上完整验证通过：`nvim-treesitter` 会按 Neovim 版本自动选择
`main`（0.12+，重写版）或 `master`（0.11，冻结维护版）分支，LSP 使用 0.11 引入的
原生 `vim.lsp.config` / `vim.lsp.enable` API。

## 特性

- **LSP**：mason + mason-lspconfig 自动安装并启用 `lua_ls` / `gopls` / `ts_ls` /
  `pyright` / `clangd` / `rust_analyzer` / `intelephense` / `html` / `cssls` /
  `tailwindcss` / `svelte` / `emmet_ls` / `astro` / `dockerls`
- **补全**：nvim-cmp + LuaSnip（含命令行 `/` `:` 补全）
- **语法**：nvim-treesitter 高亮 + nvim-ts-autotag（自动闭合标签）
- **调试**：nvim-dap + dap-ui + dap-virtual-text（Python / Go / C-C++ / PHP）
- **测试**：neotest + neotest-phpunit
- **搜索**：telescope（有 `fd` 时自动用 fd）、fzf.vim
- **文件树**：nvim-tree
- **Go**：go.nvim（保存时自动 `goimports` + 格式化）
- **终端**：toggleterm（`<C-\>` 唤出浮动终端）
- **状态栏**：lualine；**写作**：zen-mode / twilight / glow / vim-markdown /
  markdown-preview；**LaTeX**：vimtex；**翻译**：vim-translator（中英互译）
- 主题默认 `default`（可在 `lua/settings.lua` 里改成已安装的 `tokyonight`）

## 目录结构

```
nvim/
├── init.lua                # 入口, 按顺序加载 lua/ 下的模块
├── lazy-lock.json          # lazy.nvim 插件版本锁文件
├── spell/                  # 拼写检查词库
└── lua/
    ├── plugs.lua           # 插件列表 + lazy.nvim 引导安装
    ├── settings.lua        # 基础选项
    ├── keybindings.lua     # 通用按键映射
    ├── lspconfigs.lua      # LSP / nvim-cmp / mason 配置
    ├── plugconfigs.lua     # 其余插件配置(telescope/lualine/treesitter/nvim-tree/...)
    └── dap/                # 各语言的 DAP 调试配置
        ├── nvim-dap.lua        # 调试入口(断点/快捷键)
        ├── nvim-dap-ui.lua     # 调试 UI
        ├── nvim-dap-virtual-text.lua
        ├── python.lua  go.lua  cpp.lua  php.lua
        └── OpenDebugAD7  vscode-php-debug   # 随仓库分发的 Linux 版调试器
```

## 环境要求

| 要求 | 说明 | 必需 |
| --- | --- | --- |
| Neovim ≥ 0.11 | 推荐 0.12+（本配置在 0.12.6 上验证） | ✅ |
| git | 克隆配置与插件（≥ 2.19） | ✅ |
| Nerd Font | 图标正常显示；推荐 [JetBrainsMono Nerd Font](https://www.nerdfonts.com/font-downloads) | ✅ |
| Node.js + npm | markdown-preview、部分 LSP（ts_ls 等） | ⬜ |
| Go | go.nvim、gopls、delve 调试器 | ⬜ |
| Python 3 | pyright、debugpy 调试器 | ⬜ |
| ripgrep (`rg`) | telescope `live_grep` | ⬜ |
| fd | telescope `find_files` 加速（没有则自动回退） | ⬜ |
| fzf | `;f` 的 `:FZF` 搜索 | ⬜ |
| tree-sitter CLI ≥ 0.26 + C 编译器 | 仅 **Neovim 0.12+** 需要（解析器编译） | ⬜ |

## 安装

### Linux / macOS

```bash
git clone https://github.com/dreamfly2012/nvim.git ~/.config/nvim
nvim
```

首次启动会自动下载 lazy.nvim 并安装插件，之后手动同步一次：

```vim
:Lazy sync      " 安装/更新插件
:TSUpdate       " 安装/更新 treesitter 解析器
:Mason          " 查看/安装 language server 与调试器
:checkhealth    " 自检
```

### Windows（PowerShell）

配置目录是 `%LOCALAPPDATA%\nvim`：

```powershell
git clone https://github.com/dreamfly2012/nvim.git "$env:LOCALAPPDATA\nvim"
nvim
```

同样执行 `:Lazy sync` 完成安装。

> 配置默认通过 **HTTPS** 克隆插件，不需要 SSH key；如果你配置了 GitHub SSH key，
> 想改回 SSH 克隆，把 `lua/plugs.lua` 末尾的 `url_format` 改成
> `"git@github.com:%s.git"` 即可。

### treesitter 解析器（Neovim 0.12+ 必读）

0.12 使用的 nvim-treesitter `main` 分支需要 `tree-sitter` CLI 与 C 编译器：

```powershell
# Windows
scoop install tree-sitter            # 或: cargo install tree-sitter-cli / npm i -g tree-sitter-cli
winget install Microsoft.VisualStudio.C++BuildTools
```

```bash
# Linux
sudo apt install build-essential     # Debian/Ubuntu
cargo install tree-sitter-cli        # 或用发行版包管理器
```

之后运行 `:TSUpdate`。没有这些工具时配置仍可正常使用，treesitter 高亮会自动
关闭并给出一次提示，不会有报错刷屏。

## LSP（language server）

`lua/lspconfigs.lua` 里通过 mason 的 `ensure_installed` 统一管理，安装后由
mason-lspconfig v2 的 `automatic_enable` 自动 `vim.lsp.enable()`，个人配置通过
`vim.lsp.config()` 与 nvim-lspconfig 的默认配置合并。

- 添加新的语言：往 `ensure_installed` 列表里加服务器名，然后 `:Mason` / 重启 nvim
- Go 保存时自动 organize imports + 格式化（go.nvim 提供），其他语言用 `<space>f` 手动格式化
- Windows 注意：`go install` 的产物在 `%USERPROFILE%\go\bin`，要加入 `PATH` 后重开终端

## 常用快捷键

### 编辑 / 窗口

| 按键 | 作用 |
| --- | --- |
| `jk`（插入模式） | 退回普通模式 |
| `<C-a>` | 全选 |
| `w=` / `w-` / `w,` / `w.` | 增大 / 减小 / 左右收窄 / 左右加宽窗口 |
| `<C-\>` | 打开 / 关闭浮动终端（toggleterm） |
| `yy`（可视模式） | 复制到系统剪贴板（vim-oscyank） |

### 搜索 / 文件

| 按键 | 作用 |
| --- | --- |
| `<F2>` | 打开 / 关闭文件树（nvim-tree） |
| `ff` | telescope 查找文件 |
| `fg` | telescope 全文搜索（需要 ripgrep） |
| `fb` | telescope 缓冲区列表 |
| `fh` | telescope 帮助文档 |
| `;f` | fzf 查找文件 |

nvim-tree 内：`Enter/o` 打开，`a` 新建，`d` 删除，`r` 重命名，`y/x/p` 复制/剪切/粘贴，
`R` 刷新，`H` 显示隐藏文件，`q` 关闭。

### LSP / 补全

| 按键 | 作用 |
| --- | --- |
| `gd` / `gD` / `gi` / `gr` | 定义 / 声明 / 实现 / 引用 |
| `K` | 悬浮文档 |
| `<C-k>` | 签名帮助 |
| `<space>rn` / `<space>ca` | 重命名 / 代码操作 |
| `<space>e` / `[d` / `]d` | 行诊断浮动窗 / 上一条 / 下一条 |
| `<space>q` | 诊断放入 location list |
| `<space>f` | 格式化 |
| `<Tab>` / `<S-Tab>` | 补全菜单下一项 / 上一项（或 snippet 跳转） |
| `<CR>` 确认补全，`<C-e>` 取消，`<C-Space>` 手动触发 |
| `<M-e>` | autopairs 快速包裹（fast wrap） |

### 调试（nvim-dap）

| 按键 | 作用 |
| --- | --- |
| `<F9>` | 打开 / 取消断点 |
| `<F5>` | 继续 / 开始调试 |
| `<F6>` / `<F7>` / `<F8>` | 单步进入 / 单步跳过 / 步出 |
| `<F3>` | 重复上次调试 |
| `<F12>` | 退出调试（关闭 UI 和内联文本） |

调试器需要单独安装：Go 用 delve（`go install github.com/go-delve/delve/cmd/dlv@latest`）、
Python 用 debugpy（`python3 -m pip install debugpy`）、PHP 用 vscode-php-debug、
C/C++ 随仓库带的 `OpenDebugAD7` 是 Linux 二进制，Windows 请改装
[codelldb](https://github.com/vadimcn/codelldb) 并修改 `lua/dap/cpp.lua`。

### 测试（neotest）

| 按键 | 作用 |
| --- | --- |
| `tm` / `tf` | 运行单个测试 / 当前文件 |
| `ts` / `to` | 测试概览面板 / 输出 |
| `tds` / `tdh` | 显示 / 隐藏测试诊断 |

### 其他

| 按键 / 命令 | 作用 |
| --- | --- |
| `:ZenMode` / `:Twilight` | 专注模式（zen-mode / 聚光灯效果） |
| `:MarkdownPreview` | 浏览器实时预览 Markdown（需要 node + npm） |
| `:Trans` / `:Transr` | 翻译光标下单词 / 选中文本 |

## 常见问题

1. **图标显示为方块**：终端字体不是 Nerd Font。
2. **插件克隆失败**：确认能访问 github.com；公司网络可给 git 配置代理：
   `git config --global http.proxy http://127.0.0.1:7890`。
3. **mason 安装 language server 很慢**：`:Mason` 里可以只装需要的；也可以给
   npm/go 配置国内镜像。
4. **`:TSUpdate` 报 `tree-sitter` 命令找不到**：0.12 需要 tree-sitter CLI + C 编译器，
   见上文。
5. **telescope `fg` 无结果**：未安装 ripgrep；`ff` 找不到文件时先确认 `fd` 是否安装
   （未安装会自动回退，不会报错）。
6. **Go 补全/调试不工作**：`gopls`、`dlv` 需要在 `PATH` 中（`go env GOPATH`/bin）。
7. **插件升级后异常**：`:Lazy sync` → `:TSUpdate` → 重启；仍异常可删除
   `%LOCALAPPDATA%\nvim-data/lazy`（Linux：`~/.local/share/nvim/lazy`）后重装。

## 从旧的 master 分支迁移

原 `master` 分支（Vimscript + vim-plug 版本）已被本 `main` 分支取代并删除，
主要变化：

- 配置语言：Vimscript → Lua，vim-plug → lazy.nvim
- `folke/neodev.nvim` → `folke/lazydev.nvim`（neodev 已不兼容 0.11+）
- 移除已废弃/归档的插件：`popup.nvim`、`prettier.nvim`、defx.nvim 等
- 仓库地址统一改为 `nvim-tree/*`，插件克隆默认 HTTPS（Windows 免配 SSH key）
- treesitter 按 Neovim 版本自动选分支；DAP 配置跨平台化（不再写死 `/home/xxx` 路径）
- 补全 `<Tab>` 映射冲突修复、cmp `<C-e>` 拼写错误修复、nvim-sync 插件规格修复

## License

MIT
