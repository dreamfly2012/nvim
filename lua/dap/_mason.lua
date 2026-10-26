-- Mason 包路径的统一入口, 供各 dap/*.lua 使用.
-- 说明: 不要用 mason/bin 下的 .cmd shim —— Windows 上 nvim-dap 走 libuv spawn,
-- 无法直接执行 .cmd, 这里指向包内真实可执行文件/解释器.
local M = {}

local is_win = vim.fn.has("win32") == 1 or vim.fn.has("win64") == 1

--- Mason 包安装根目录
---@param package string mason 包名
---@return string
function M.root(package)
    return vim.fn.stdpath("data") .. "/mason/packages/" .. package
end

--- 判断某个 mason 包是否已安装 (存在 receipt 即视为已安装)
---@param package string
---@return boolean
function M.installed(package)
    return vim.fn.filereadable(M.root(package) .. "/mason-receipt.json") == 1
end

M.windows = is_win

return M
