-- C/C++ 调试器
-- 优先用 Mason 自动安装的 codelldb (:MasonInstall codelldb),
-- 未安装则回退到随配置仓库分发的 OpenDebugAD7 (仅 Linux 可用)
local mason = require("dap._mason")
local use_codelldb = mason.installed("codelldb")

local adapters
if use_codelldb then
    -- codelldb 以 server 方式运行, nvim-dap 通过 ${port} 自动分配端口连接
    adapters = {
        type = "server",
        port = "${port}",
        executable = {
            command = mason.root("codelldb") .. "/extension/adapter/codelldb" ..
                (mason.windows and ".exe" or ""),
            args = {"--port", "${port}"}
        }
    }
else
    -- OpenDebugAD7 是 Linux 二进制, Windows/macOS 上请先 :MasonInstall codelldb
    adapters = {
        type = "executable",
        command = vim.fn.stdpath("config") .. "/lua/dap/OpenDebugAD7",
        id = "cpp",
        name = "cpp"
    }
end

local configurations = {
    {
        name = "Launch file",
        type = "cpp",
        request = "launch",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end,
        cwd = "${workspaceFolder}",
        stopOnEntry = true
    }
}

-- gdbserver attach 是 cppdbg (OpenDebugAD7) 专有配置, codelldb 不支持
if not use_codelldb then
    table.insert(configurations, {
        name = "Attach to gdbserver :1234",
        type = "cpp",
        request = "launch",
        MIMode = "gdb",
        miDebuggerServerAddress = "localhost:1234",
        miDebuggerPath = "/usr/bin/gdb",
        cwd = "${workspaceFolder}",
        program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/", "file")
        end
    })
end

return {
    adapters = adapters,
    configurations = configurations
}
