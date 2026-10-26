-- 调试器优先用 Mason 自动安装的 debugpy, 未安装则回退到系统 debugpy
-- 回退安装: python3 -m pip install debugpy
local mason = require("dap._mason")
local py_cmd, py_args

if mason.installed("debugpy") then
    -- Mason 把 debugpy 装进独立 venv, 直接用该 venv 的解释器 (跨平台路径)
    local venv_py = mason.root("debugpy") .. "/venv/" ..
        (mason.windows and "Scripts/python.exe" or "bin/python")
    py_cmd, py_args = venv_py, {"-m", "debugpy.adapter"}
else
    -- Windows 上的命令是 python, 其他平台通常是 python3
    py_cmd = (mason.windows) and "python" or "python3"
    py_args = {"-m", "debugpy.adapter"}
end

return {
    adapters = {
        type = "executable",
        command = py_cmd,
        args = py_args
    },
    configurations = {
        {
            type = "python",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            pythonPath = function()
                return vim.g.python_path
            end
        }
    }
}
