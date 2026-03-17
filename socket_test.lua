
--local socket = require("socket.bindings")
local socket = require("socket.wrapper")


print("Initializing socket libraries...")
local initialized, _ = socket.init()
if not initialized then
    print("> " .. socket.last_error_message())
    return
end


print("Creating IPv4 TCP socket...")
local sock, _ = socket.socket(
    socket.AddressFamilies.AF_INET,
    socket.SocketTypes.SOCK_STREAM,
    socket.Protocols.IPPROTO_TCP
)
if not sock then
    print("> " .. socket.last_error_message())
    socket.deinit()
    return
end


print("Connecting to remote server...")
local conn, _ = socket.connect(sock, socket.AddressFamilies.AF_INET, 1234, "127.0.0.1")
if not conn then
    print("\x1B[31m> " .. socket.last_error_message())
    socket.closesocket(sock)
    socket.deinit()
    return
end


-- If calling `deinit()` right after, the data may be lost on the way.
print("Sending some data...")
local bytes_sent = socket.send(sock, "Test 123", nil)
if bytes_sent == socket.SOCKET_ERROR then
    print("> " .. socket.last_error_message())
    socket.shutdown(sock, socket.SD_BOTH)
    socket.closesocket(sock)
    socket.deinit()
    return
end
print("> Sent `" .. bytes_sent .. "` byte(s)")


-- Skipping this step and calling `socket.deinit()` directly may lead to data not being sent out.
print("Shutting down socket...")
local is_shutdown, _ = socket.shutdown(sock, socket.ShutdownFlags.SD_BOTH)
if not is_shutdown then
    print("> " .. socket.last_error_message())
    socket.closesocket(sock)
    socket.deinit()
    return
end


-- Wait here with `socket.SD_SEND` to receive the remaining data.


print("Closing socket...")
local is_closed, _ = socket.closesocket(sock)
if not is_closed then
    print("> " .. socket.last_error_message())
    socket.deinit()
    return
end


print("De-initializing socket libraries...")
local deinitialized, _ = socket.deinit()
if not deinitialized then
    print("> " .. socket.last_error_message())
    return
end


print("Exiting...")
return
