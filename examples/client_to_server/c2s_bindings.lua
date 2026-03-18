
-- Used for platform detection
local ffi = require("ffi")

-- Loading the raw bindings
local socket = require("socket.bindings")


-- Quite different from the wrapper version since YOU have to handle the structure allocations.
-- Only required on Windows for WinSock.
print("Initializing socket libraries...")
local __native_lib_conf = nil

if ffi.os == "Windows" then
    -- Using Winsock v2.2
    __native_lib_conf = ffi.new("WSADATA")
    local startup_err = socket.WSAStartup(0x0202, __native_lib_conf)

    if startup_err ~= 0 then
        error("Error in `WSAStartup()` ! (" .. socket.WSAGetLastError() .. ")")
    end
end


-- A near 1-to-1 copy from the wrapper version.
-- Adjust as needed if your tests require UDP/IPv6/...
-- Make sure to change the `socket.connect()` call too !
print("Creating IPv4 TCP socket...")
local sock, _ = socket.socket(
    socket.AF_INET,
    socket.SOCK_STREAM,
    socket.IPPROTO_TCP
)
if not sock then
    error("Error in `socker.socket()` ! (" .. socket.WSAGetLastError() .. ")")
    socket.WSACleanup()
    return
end


-- Quite different from the wrapper version, but the calls shouldn't be platform-specific.
-- You only REALLY need to add a transform for the hostname.
-- See the included echo server examples.
print("Connecting to remote server...")

-- Describing the remote host, the wrapper exposes this as simple parameters.
local remote_addr = ffi.new("sockaddr_in")
remote_addr.sin_family = socket.AF_INET
remote_addr.sin_port = socket.htons(1234)
remote_addr.sin_addr.s_addr = socket.inet_addr("127.0.0.1")

local conn = socket.connect(sock, ffi.cast("sockaddr*", remote_addr), ffi.sizeof(remote_addr))

if conn ~= 0 then
    error("Error in `socker.connect()` ! (" .. socket.WSAGetLastError() .. ")")
    socket.closesocket(sock)
    socket.WSACleanup()
end


-- Calling `deinit()` right after, without calling `shutdown()` properly
--  will likely lead to data being lost in transit !
print("Sending some data...")

local data_to_send = "Test 456"
local data_pointer = ffi.cast("const char *", data_to_send)
local data_length = #data_to_send

local bytes_sent = socket.send(sock, data_pointer, data_length, 0)
if bytes_sent == socket.SOCKET_ERROR then
    error("Error in `socker.send()` ! (" .. socket.WSAGetLastError() .. ")")
    socket.shutdown(sock, socket.SD_BOTH)
    socket.closesocket(sock)
    socket.WSACleanup()
    return
end
print("> Sent `" .. bytes_sent .. "` byte(s)")


-- Skipping this step and calling `socket.deinit()` directly may lead to data not being sent out.
print("Shutting down socket...")
local shutdown_ret_code = socket.shutdown(sock, socket.SD_BOTH)
if shutdown_ret_code ~= 0  then
    error("Error in `socker.shutdown()` ! (" .. socket.WSAGetLastError() .. ")")
    socket.closesocket(sock)
    socket.WSACleanup()
    return
end


-- Optionnal: We don't wait and use `socket.ShutdownFlags.SD_SEND` since we don't expect any data.


print("Closing socket...")
local closure_ret_code = socket.closesocket(sock)
if closure_ret_code ~= 0 then
    error("Error in `socker.closesocket()` ! (" .. socket.WSAGetLastError() .. ")")
    socket.WSACleanup()
    return
end


print("De-initializing socket libraries...")
if ffi.os == "Windows" then
    if socket.WSACleanup() ~= 0 then
        error("Error in `WSACleanup()` ! (" .. socket.WSAGetLastError() .. ")")
    end
end


print("Exiting...")
return
