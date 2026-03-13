# LuaJIT Bindings - Sockets
Test123

**⚠️ This library is still in development ⚠️**


## Requirements
* Windows 7+ or ~~Linux ?.??~~
* LuaJIT v?


## Installation
TODO: Manual and LuaRocks


## Usage

### Basics
???

### Client
```lua
local socket = require("socket")

local HOST = "127.0.0.1"
local PORT = 1234

-- Initializing
local initialized, _ = socket.init()
if not initialized then
    print("Error: " .. socket.last_error_message())
    return
end

-- Preparing IPV4 TCP socket
local sock, _ = socket.socket(
    socket.AddressFamilies.AF_INET,
    socket.SocketTypes.SOCK_STREAM,
    socket.Protocols.IPPROTO_TCP
)
if not sock then
    print("Error: " .. socket.last_error_message())
    socket.deinit()
    return
end

-- Connecting
socket.connect(s, socket.AddressFamilies.AF_INET, PORT, HOST)

-- Sending data
-- TODO: Implement this !

-- Closing connection
-- TODO: Implement this !

-- Closing socket
-- TODO: Implement this !

-- De-initializing
local deinitialized, _ = socket.deinit()
if not deinitialized then
    print_err("Error: " .. socket.last_error_message())
    return
end

-- Exiting
print("Done :)")
return
```


### Server
TODO: Implement listening capabilities


## License
The code in this repository is licensed under
[CC0 1.0 Universal (CC0 1.0) (Public Domain)](LICENSE).
