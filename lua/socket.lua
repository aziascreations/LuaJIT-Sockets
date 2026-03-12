-- ========================================
--  NibblePoker's LuaJIT Socket Module
-- ========================================
--  ???
-- ========================================

-- Imports
local bit = require("bit")
local ffi = require("ffi")
local jit = require("jit")

-- Module root
local M = {}

-- Module root > Commons

-- TODO: Check if this isn't needlesly verbose...

M.AddressFamilies = {
    AF_UNSPEC = 0,
    AF_INET = 2,
    AF_IPX = 6,
    AF_APPLETALK = 16,
    AF_NETBIOS = 17,
    AF_INET6 = 23,
    AF_IRDA = 26,
    AF_BTH = 32
}

M.SocketTypes = {
    SOCK_STREAM = 1,
    SOCK_DGRAM = 2,
    SOCK_RAW = 3,
    SOCK_RDM = 4,
    SOCK_SEQPACKET = 5
}

M.Protocols = {
    IPPROTO_ICMP = 1,
    IPPROTO_IGMP = 2,
    BTHPROTO_RFCOMM = 3,
    IPPROTO_TCP = 6,
    IPPROTO_UDP = 17,
    IPPROTO_ICMPV6 = 58,
    IPPROTO_RM = 113
}

-- Private globals
M._is_initialized = false

-- Platform Specific

ffi.cdef [[
    typedef uintptr_t SOCKET;
    typedef uint16_t  USHORT;
    typedef uint16_t  ushort;
    typedef uint16_t  u_short;
    typedef uint32_t  ULONG;
    typedef int       INT;
    typedef unsigned long DWORD;
]]

if ffi.os == "Windows" then

    -- See: https://learn.microsoft.com/en-us/windows/win32/api/winsock2/nf-winsock2-socket

    -- Constants

    -- Public Constants
    M.INVALID_SOCKET = -1

    -- FFI Setup
    M._socket_lib = ffi.load("Ws2_32")

    local WSADESCRIPTION_LEN = 256
    local WSASYS_STATUS_LEN = 128

    if ffi.abi("64bit") and (jit.arch == "x64" or jit.arch == "arm64") then
        -- Not tested on ARM64, will be tested once the library is basically finished.
        ffi.cdef [[
            typedef struct {
                USHORT wVersion;
                USHORT wHighVersion;
                USHORT iMaxSockets;
                USHORT iMaxUdpDg;
                char* lpVendorInfo;
                char szDescription[257];
                char szSystemStatus[129];
            } WSADATA;
        ]]

    elseif ffi.abi("32bit") and (jit.arch == "x86" or jit.arch == "arm") then
        -- Not tested on ARM32, i don't even think Microslop supports it anymore...
        ffi.cdef [[
            typedef struct {
                USHORT wVersion;
                USHORT wHighVersion;
                char szDescription[257];
                char szSystemStatus[129];
                USHORT iMaxSockets;
                USHORT iMaxUdpDg;
                char* lpVendorInfo;
            } WSADATA;
        ]]

    else
        -- Just in case Windows gets properly ported and supported on RiscV/PPC/...
        assert(false, "Unknown Windows platform ! (arch: " .. jit.arch .. ")")
    end

    -- See:
    -- * https://learn.microsoft.com/en-us/windows/win32/winsock/sockaddr-2
    -- * https://learn.microsoft.com/en-us/windows/win32/api/winsock2/nf-winsock2-htons
    -- * https://learn.microsoft.com/en-us/windows/win32/api/winsock2/nf-winsock2-inet_addr
    ffi.cdef [[
        typedef struct { uint32_t s_addr; } in_addr;
        typedef struct { short sin_family; USHORT sin_port; in_addr sin_addr; char sin_zero[8]; } sockaddr_in;
        typedef struct { USHORT sa_family; char sa_data[14]; } sockaddr;

        int connect(SOCKET s, sockaddr *name, int namelen);
        SOCKET socket(int af, int type, int protocol);

        int WSACleanup();
        int WSAGetLastError();
        int WSAStartup(USHORT wVersionRequested, WSADATA* lpWSAData);

        USHORT htons(USHORT hostshort);
        uint32_t inet_addr(const char* cp);
    ]]


    -- ???
    M.__wsadata = nil
    M.__rc = nil

    function M.init()
        M.__wsadata = ffi.new("WSADATA")
        M.__rc = M._socket_lib.WSAStartup(0x0202, M.__wsadata)
        
        if M.__rc ~= 0 then
            return false, M._socket_lib.WSAGetLastError()
        end

        return true
    end

    function M.deinit()
        local err_code = M._socket_lib.WSACleanup()

        if err_code ~= 0 then
            return false, M._socket_lib.WSAGetLastError()
        end

        return true
    end

    function M.connect(s, family, port, host)
        local addr = ffi.new("sockaddr_in")
        addr.sin_family      = family
        addr.sin_port        = M._socket_lib.htons(port)
        addr.sin_addr.s_addr = M._socket_lib.inet_addr(host)

        local conn = M._socket_lib.connect(s, ffi.cast("sockaddr*", addr), ffi.sizeof(addr))
        if conn ~= 0 then
            error("connect failed, errno=" .. M._socket_lib.WSAGetLastError())
        end
    end


else
    assert(false, "This library can only be used on Win32 platforms !")
end

-- https://learn.microsoft.com/en-us/windows/win32/winsock/windows-sockets-error-codes-2
function M.socket(af, socktype, protocol)
    -- af = af or Family.AF_INET
    -- socktype = socktype or SocketType.SOCK_STREAM
    -- protocol = protocol or Protocol.IPPROTO_TCP

    local sock = M._socket_lib.socket(af, socktype, protocol)

    if sock == M.INVALID_SOCKET then
        return false, M._socket_lib.WSAGetLastError()
    end

    return sock;
end

return M
