-- 调试器优先用 Mason 自动安装的 delve, 未安装则回退到 PATH 里的 dlv
-- 回退安装: go install github.com/go-delve/delve/cmd/dlv@latest
local mason = require("dap._mason")
local dlv_cmd
if mason.installed("delve") then
    dlv_cmd = mason.root("delve") .. (mason.windows and "/dlv.exe" or "/dlv")
else
    dlv_cmd = "dlv"
end

return {
    adapters = function(callback, _) -- _ = config
        local stdout = vim.uv.new_pipe(false)
        local handle
        local pid_or_err
        local port = 38697
        local opts = {
            stdio = {nil, stdout},
            args = {"dap", "-l", "127.0.0.1:" .. port},
            detached = true
        }
        handle, pid_or_err =
            vim.uv.spawn(
            dlv_cmd,
            opts,
            function(code)
                stdout:close()
                handle:close()
                if code ~= 0 then
                    print("dlv exited with code", code)
                end
            end
        )
        assert(handle, "Error running dlv: " .. tostring(pid_or_err))
        stdout:read_start(
            function(err, chunk)
                assert(not err, err)
                if chunk then
                    vim.schedule(
                        function()
                            require("dap.repl").append(chunk)
                        end
                    )
                end
            end
        )
        -- Wait for delve to start
        vim.defer_fn(
            function()
                callback({type = "server", host = "127.0.0.1", port = port})
            end,
            100
        )
    end,
    configurations = {
        {
            type = "go",
            name = "Debug",
            request = "launch",
            program = "${file}"
        },
        {
            type = "go",
            name = "Debug test", -- configuration for debugging test files
            request = "launch",
            mode = "test",
            program = "${file}"
        },
        -- works with go.mod packages and sub packages
        {
            type = "go",
            name = "Debug test (go.mod)",
            request = "launch",
            mode = "test",
            program = "./${relativeFileDirname}"
        }
    }
}
