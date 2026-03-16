# LuaJIT Bindings - Sockets - Examples
???


## Types of examples

### Bindings
These examples use the raw bindings ???.

### Wrapper
These samples use the simplified and OOP-friendly ???.

This is the recommended way if you still want the maximum amount of control without dealing with OS-specific odities.

### OOP
Examples that use the OOP-friendly and more care-free interface.


## Examples

### Unidirectional Client to Server

Establishes a simple IPv4 TCP connection to `127.0.0.1:1234`, and sends a small bit of text before closing the connection.

**Variants:**
    [Bindings](bindings/client_to_server.lua), 
    [Wrapper](wrapper/client_to_server.lua), 
    ~~OOP~~
