-- 引入 Lua 套接字库
local socket = require("socket")

-- FTP 服务器的信息
local config_path = vim.fn.stdpath('config') .. '/ftp-config.lua'
local config = require(config_path)

-- 获取当前文件名
local local_file = vim.fn.expand("%")
local remote_file = config.remote_path .. '/' .. vim.fn.fnamemodify(local_file, ":t")

-- 创建 FTP 连接函数
local function connect_to_ftp()
    local ftp = assert(socket.connect(config.host, config.port))
    ftp:settimeout(10)
    local response = assert(ftp:receive())
    print(response)
    return ftp
end

-- 登录 FTP 服务器
local function login_to_ftp(ftp)
    ftp:send("USER " .. config.username .. "\r\n")
    local response = assert(ftp:receive())
    print(response)

    ftp:send("PASS " .. config.password .. "\r\n")
    local response = assert(ftp:receive())
    print(response)
end

-- 上传文件到 FTP 服务器
local function upload_file(ftp)
    local file = assert(io.open(local_file, "rb"))
    ftp:send("STOR " .. remote_file .. "\r\n")
    local response = assert(ftp:receive())
    print(response)

    while true do
        local chunk = file:read(1024)
        if not chunk then
            break
        end
        ftp:send(chunk)
    end

    file:close()

    response = assert(ftp:receive())
    print(response)
end

-- 断开 FTP 连接
local function disconnect_ftp(ftp)
    ftp:send("QUIT\r\n")
    ftp:close()
    print("FTP 连接已断开")
end

-- 主函数，执行 FTP 上传
local function main()
    local ftp = connect_to_ftp()
    login_to_ftp(ftp)
    upload_file(ftp)
    disconnect_ftp(ftp)
    print("文件上传完成")
end

-- 创建 Neovim 命令
vim.cmd([[command! FTPUpload lua require('ftp').upload()]])

