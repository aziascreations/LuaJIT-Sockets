--- Pure LuaJIT bindings for Windows and Linux native socket libraries.
--
-- @module socket.oop
-- @author Herwin Bozet (NibblePoker)
-- @license CC0 1.0 Universal (CC0 1.0) (Public Domain)
-- @copyright 2026
--
-- @release 0.0.0
-- @see socket.bindings
-- @see socket.wrapper

local ffi = require("ffi")

local M = {}

M.Socket = {}
M.Socket.__index = M.Socket

-- Internal structures used to facilitate calls to `__gc()`.
ffi.cdef [[
    typedef struct {} _GCSentinel_8ED0F62656DA481F9509203C0110F757;
]]

function M.Socket:new()
    local new_obj = {}
    setmetatable(new_obj, M.Socket)

    -- Setting up the mechanism for automatic calls to `__gc()`.
    local ref = new_obj
    new_obj._gc = ffi.gc(
        ffi.new("_GCSentinel_8ED0F62656DA481F9509203C0110F757"),
        function() ref:__gc() end
    )

    return new_obj
end

function M.Socket:test()
    print(123)
end

--- Handles the automatic and proper closure of any open low-level socket or connection attached to this class.
function M.Socket:__gc()
    print("Reeee")
end



local a = M.Socket:new()
print(a)
print(a:test())

-- Not really required, but it can help it trigger sooner
a = nil


-- Forcing the GC to collect trash
collectgarbage("collect")
collectgarbage("step", 100)
collectgarbage("stop")
collectgarbage("restart")
collectgarbage("collect")
collectgarbage("step", 100)

--return M
