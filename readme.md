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


### Module types/scopes

#### Bindings
> Module that provides basic and platform-dependant bindings for socket-related functions.

#### Wrapper
> Module that provides platform-independant wrappers for socket-related functions while
keeping the platform-dependant error constants.

#### OOP
> **PLANNED, NOT IMPLEMENTED** \
  Module that provides an OOP-friendly and self-managed way of using sockets without having
  to manage their initialisation and proper closure.



### Call flow
| Windows Bindings* | Linux Bindings* | Wrapper       | OOP |
|-------------------|-----------------|---------------|-----|
| `WSAStartup`      |                 | `init` **     | ??? |
| `socket`          | `socket`        | `socket`      | ??? |
| `connect`         | `connect`       | `connect`     | ??? |
| ...               | ...             | ...           | ??? |
| `shutdown`        | `shutdown`      | `shutdown`    | ??? |
| `closesocket`     | `closesocket`   | `closesocket` | ??? |
| `WSAStartup`      |                 | `deinit` **   | ??? |

<i>* : Bindings module, or other system programming languages</i> \
<i>** : Does nothing on Linux platforms (TODO: See it this holds true)</i>


### Feel of the API

<table>
<thead><tr>
<th>Bindings</th>
<th>Wrapper</th>
<th>OOP</th>
</tr></thead>
<tbody><tr><td>

```lua
-- Preparing data
local data_to_send = "Test 123"
local data_pointer = ffi.cast(
    "const char *",
    data_to_send
)
local data_length = #data_to_send

-- Sending data
local bytes_sent = socket.send(
    sock,
    data_pointer,
    data_length,
    0
)

-- Error handling
if bytes_sent == socket.SOCKET_ERROR then
    error("Error in `socker.send()` !")
    socket.shutdown(sock, socket.SD_BOTH)
    socket.closesocket(sock)
    socket.WSACleanup()
    return
end
```
</td><td>

```lua
-- Preparing data
local data_to_send = "Test 123"






-- Sending data
local bytes_sent = socket.send(
    sock,
    data_to_send,
    nil
)


-- Error handling
if bytes_sent == socket.SOCKET_ERROR then
    error("Error in `socker.send()` !")
    socket.shutdown(sock, socket.SD_BOTH)
    socket.closesocket(sock)
    socket.deinit()
    return
end
```
</td><td>

```lua
TODO: Implement OOP module
```
        
</td></tr></tbody>
</table>

### Client




### Server
TODO: Implement listening capabilities


## License
The code in this repository is licensed under
[CC0 1.0 Universal (CC0 1.0) (Public Domain)](LICENSE).
