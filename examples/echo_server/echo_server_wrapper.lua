
-- Loading the wrapper.
-- The bindings from `socket.bindings` library can be accessed via `require("socket.wrapper").bindings`.
local socket = require("socket.wrapper")


-- Only required on Windows for WinSock.
print("Initializing socket libraries...")
local initialized, _ = socket.init()
if not initialized then
    error(socket.last_error_message())
    return
end

-- Adjust as needed if your tests require UDP/IPv6/...
-- Make sure to change the `socket.connect()` call too !
print("Creating IPv4 TCP socket...")
local sock, _ = socket.socket(
    socket.AddressFamilies.AF_INET,
    socket.SocketTypes.SOCK_STREAM,
    socket.Protocols.IPPROTO_TCP
)
if not sock then
    error(socket.last_error_message())
    socket.deinit()
    return
end


-- Binding to socket.
-- We'll go for `tcp://0.0.0.0:1234` in this example.
print("Binding to `0.0.0.0:1234`...")
local conn, _ = socket.bind(sock, socket.AddressFamilies.AF_INET, 1234, "0.0.0.0")
print(conn)
if not conn then
    error(socket.last_error_message())
    socket.closesocket(sock)
    socket.deinit()
    return
end


-- Configuring the socket to ensure we have blocking I/O operations.
-- This is simpler for this example since we don't want to implement a polling loop.
-- We just want a connection, data in, data out, and a disconnection.


-- TODO: Listen for data...


---- Skipping this step and calling `socket.deinit()` directly may lead to data not being sent out.
--print("Shutting down socket...")
--local is_shutdown, _ = socket.shutdown(sock, socket.ShutdownFlags.SD_BOTH)
--if not is_shutdown then
--    error(socket.last_error_message())
--    socket.closesocket(sock)
--    socket.deinit()
--    return
--end


-- Optionnal: We don't wait and use `socket.ShutdownFlags.SD_SEND` since we don't expect any data.


print("Closing socket...")
local is_closed, _ = socket.closesocket(sock)
if not is_closed then
    error(socket.last_error_message())
    socket.deinit()
    return
end


print("De-initializing socket libraries...")
local deinitialized, _ = socket.deinit()
if not deinitialized then
    error(socket.last_error_message())
    return
end


print("Exiting...")
return
