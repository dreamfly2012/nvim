-- 调试器优先用 Mason 自动安装的 php-debug-adapter, 未安装则回退到手动克隆的
-- 回退安装: git clone https://github.com/xdebug/vscode-php-debug ~/vscode-php-debug
local mason = require("dap._mason")
local php_debug_js

if mason.installed("php-debug-adapter") then
    php_debug_js = mason.root("php-debug-adapter") .. "/extension/out/phpDebug.js"
else
    php_debug_js = vim.fn.expand("~/vscode-php-debug/out/phpDebug.js")
end

return {
    adapters = {
        type = 'executable',
        command = 'node',
        args = {php_debug_js}
    },
    configurations = {
        {
            name = "run current script",
            type = "php",
            request = "launch",
            port = 9003,
            cwd = "${fileDirname}",
            program = "${file}",
            runtimeExecutable = "php"
        },
        {
            name = "listen address",
            type = "php",
            request = "launch",
            port = 9003
        }
    }
}
