
local socket = require("socket")


print("Initializing socket libraries...")
local init_status, err_code = socket.init()
if not init_status then
    print("Failed to initalize socket libraries ! (" .. err_code .. ")")
    return
end
print("> Done")


print("Creating IPv4 TCP socket...")
local s, err = socket.socket(
    socket.AddressFamilies.AF_INET,
    socket.SocketTypes.SOCK_STREAM,
    socket.Protocols.IPPROTO_TCP
)
if not s then
    print("Failed to create socket !")
    print("> Error: " .. err)
    socket.deinit()
    return
end
print("> Done")


print("Doing socket magic...")
socket.connect(s, socket.AddressFamilies.AF_INET, 1234, "127.0.0.1")
print("> Done")


print("De-initializing socket libraries...")
local deinit_result, err_code = socket.deinit()
if not deinit_result then
    print("Failed to de-initalize socket libraries ! (" .. err_code .. ")")
    return
end
print("> Done")


print("Exiting...")
return
