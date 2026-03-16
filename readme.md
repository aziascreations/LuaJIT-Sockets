# LuaJIT Bindings - Sockets
Pure LuaJIT bindings and wrappers for the standard Win32 and
Linux socket libraries.

**⚠️ This library is still in heavy development ⚠️**

<!--
**📢 This is library is in low maintenance mode** \
I consider it feature-complete, and unless a bug is found, I don't plan on updating it.
-->


## Features
* ~~BSD-compaptible bindings~~
* ~~OOP-friendly wrapper around the bindings~~
* ~~Transparent multi-platform support~~
  * ~~Toggle-able automatic calls to `WSAStartup` and `WSAStartup` for WinSock~~


## Requirements
* A somewhat modern OS
  * Windows 7+ *(x86/x64)*
  * Windows 10+ *(x86/x64/~~ARM32/ARM64~~)*
  * ~~Linux 3+ (CPU arch TBD)~~
* LuaJIT v?


## Installation
TODO: Manual and LuaRocks


## Usage

### Call flow
| Windows*      | Linux*        | This library  |
|---------------|---------------|---------------|
| `WSAStartup`  |               | `init` **     |
| `socket`      | `socket`      | `socket`      |
| `connect`     | `connect`     | `connect`     |
| ...           | ...           | ...           |
| `shutdown`    | `shutdown`    | `shutdown`    |
| `closesocket` | `closesocket` | `closesocket` |
| `WSAStartup`  |               | `deinit` **   |

<i>* : Typical flow outside of this library</i> \
<i>** : Does nothing on Linux platforms</i>


### Basics
???


### Client

<table>
<thead><tr>
<th>Bindings</th>
<th>Wrapper</th>
</tr></thead>
<tbody><tr><td>

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

</td><td>
            
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
        
</td></tr></tbody>
</table>


### Server
TODO: Implement listening capabilities


## License
The code in this repository is licensed under
[CC0 1.0 Universal (CC0 1.0) (Public Domain)](LICENSE).
