
local socket = require("socket")


function print_err(msg)
    print("\x1B[31m" .. msg .. "\x1B[97m")
end


print("Initializing socket libraries...")
local initialized, _ = socket.init()
if not initialized then
    print_err("> " .. socket.last_error_message())
    return
end


print("Creating IPv4 TCP socket...")
local sock, _ = socket.socket(
    socket.AddressFamilies.AF_INET,
    socket.SocketTypes.SOCK_STREAM,
    socket.Protocols.IPPROTO_TCP
)
if not sock then
    print_err("\x1B[31m> " .. socket.last_error_message())
    socket.deinit()
    return
end


print("Connecting to remote server...")
local conn, _ = socket.connect(sock, socket.AddressFamilies.AF_INET, 1234, "127.0.0.1")
if not conn then
    print_err("\x1B[31m> " .. socket.last_error_message())
    -- TODO: Close socket
    socket.deinit()
    return
end


print("De-initializing socket libraries...")
local deinit_result, _ = socket.deinit()
if not deinit_result then
    print_err("> " .. socket.last_error_message())
    return
end


print("Exiting...")
return
