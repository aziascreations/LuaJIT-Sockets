
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
print("Binding to `0.0.0.0:1234`...")

-- Describing how the socket will be bound.
-- We'll go for `tcp://0.0.0.0:1234` in this example.
local bound_addr = ffi.new("sockaddr_in")
bound_addr.sin_family = socket.AF_INET
bound_addr.sin_port = socket.htons(1234)
bound_addr.sin_addr.s_addr = socket.inet_addr("0.0.0.0")

local bind_ret_code = socket.bind(sock, ffi.cast("sockaddr*", bound_addr), ffi.sizeof(bound_addr))

if bind_ret_code ~= 0 then
    error("Error in `socker.bind()` ! (" .. socket.WSAGetLastError() .. ")")
    socket.closesocket(sock)
    socket.WSACleanup()
    return
end


-- Starting to listen on the newly bound socket.
local listen_ret_code = socket.listen(sock, 1024)

if listen_ret_code ~= 0 then
    error("Error in `socker.listen()` ! (" .. socket.WSAGetLastError() .. ")")
    socket.closesocket(sock)
    socket.WSACleanup()
    return
end


-- Configuring the socket to ensure we have blocking I/O operations.
-- This is simpler for this example since we don't want to implement a polling loop.
-- We just want a connection, data in, data out, and a disconnection.



-- TODO: Listen for data...


-- https://learn.microsoft.com/en-us/windows/win32/winsock/winsock-ioctls
---- Skipping this step and calling `socket.deinit()` directly may lead to data not being sent out.
--print("Shutting down socket...")
--local shutdown_ret_code = socket.shutdown(sock, socket.SD_BOTH)
--if shutdown_ret_code ~= 0  then
--    error("Error in `socker.shutdown()` ! (" .. socket.WSAGetLastError() .. ")")
--    socket.closesocket(sock)
--    socket.WSACleanup()
--    return
--end


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
