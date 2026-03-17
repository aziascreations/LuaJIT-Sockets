-- ========================================
--  NibblePoker's LuaJIT Socket
--    Bindings Root
-- ========================================
--  ???
-- ========================================

-- Compilation options
-- -------------------
-- ???


-- Setup
-- -----
local bit = require("bit")
local ffi = require("ffi")
local jit = require("jit")

--- Module that provides basic and platform-dependant bindings for socket-related functions.
-- @module socket.bindings
-- @alias M
local M = {}


-- Constants
-- ---------

-- AddressFamilies
M.AF_UNSPEC = 0
M.AF_INET = 2
M.AF_IPX = 6
M.AF_APPLETALK = 16
M.AF_NETBIOS = 17
M.AF_INET6 = 23
M.AF_IRDA = 26
M.AF_BTH = 32

-- SocketTypes
M.SOCK_STREAM = 1
M.SOCK_DGRAM = 2
M.SOCK_RAW = 3
M.SOCK_RDM = 4
M.SOCK_SEQPACKET = 5

-- Protocols
M.IPPROTO_ICMP = 1
M.IPPROTO_IGMP = 2
M.BTHPROTO_RFCOMM = 3
M.IPPROTO_TCP = 6
M.IPPROTO_UDP = 17
M.IPPROTO_ICMPV6 = 58
M.IPPROTO_RM = 113

-- ???
M.MSG_OOB = 1
M.MSG_PEEK = 2
M.MSG_DONTROUTE = 4

-- Socket shutdown flags
-- ---------------------

--- Shutdown receive operations.
M.SD_RECEIVE = 0

--- Shutdown send operations.
M.SD_SEND = 1

--- Shutdown both send and receive operations.
M.SD_BOTH = 2

-- Other stuff
-- -----------

-- Defined in `_socket_types.h`
M.SOCKET_ERROR = -1

-- Bindings - Commons - C Definitions
-- ----------------------------------

-- Typedefs
ffi.cdef [[
    typedef uintptr_t SOCKET;
    typedef uint16_t  USHORT;
    typedef uint16_t  ushort;
    typedef uint16_t  u_short;
    typedef uint32_t  ULONG;
    typedef int       INT;
    typedef unsigned long DWORD;
]]

-- Structures
ffi.cdef [[
    typedef struct { uint32_t s_addr; } in_addr;
    typedef struct { short sin_family; USHORT sin_port; in_addr sin_addr; char sin_zero[8]; } sockaddr_in;
    typedef struct { USHORT sa_family; char sa_data[14]; } sockaddr;
]]

-- Functions
ffi.cdef [[
    int connect(SOCKET s, sockaddr *name, int namelen);
    SOCKET socket(int af, int type, int protocol);
    int shutdown(SOCKET s, int how);
    int closesocket(SOCKET s);
    int send(SOCKET s, const char *buf, int len, int flags);

    USHORT htons(USHORT hostshort);
    uint32_t inet_addr(const char* cp);
]]

-- Bindings - Platform-specificity
-- -----------------------------------------

-- Copying platform-specific things
if ffi.os == "Windows" then
    --- Documentation:
    ---  * https://learn.microsoft.com/en-us/windows/win32/api/winsock2/nf-winsock2-socket
    ---  * https://learn.microsoft.com/en-us/windows/win32/winsock/sockaddr-2
    ---  * https://learn.microsoft.com/en-us/windows/win32/api/winsock2/nf-winsock2-htons
    ---  * https://learn.microsoft.com/en-us/windows/win32/api/winsock2/nf-winsock2-inet_addr
    ---  * https://learn.microsoft.com/en-us/windows/win32/api/winsock2/nf-winsock2-send
    ---  * https://learn.microsoft.com/en-us/windows/win32/api/winsock2/nf-winsock2-closesocket
    ---  * https://learn.microsoft.com/en-us/windows/win32/api/winsock/nf-winsock-shutdown
    ---  * https://learn.microsoft.com/en-us/windows/win32/api/winsock/nf-winsock-wsacleanup
    ---  * https://learn.microsoft.com/en-us/windows/win32/api/winsock/nf-winsock-wsagetlasterror
    ---  * https://learn.microsoft.com/en-us/windows/win32/api/winsock/nf-winsock-wsasetlasterror
    ---  * https://learn.microsoft.com/en-us/windows/win32/api/winsock/nf-winsock-wsastartup
    ---  * https://learn.microsoft.com/en-us/windows/win32/api/winsock/nf-winsock-htons
    ---  * https://learn.microsoft.com/en-us/windows/win32/api/winsock/nf-winsock-inet_addr

    -- Bindings - Win32 - Constants
    -- ----------------------------

    -- Bindings - Win32 - Constants - Odities
    -- --------------------------------------

    -- Note: Linux has another value or constant for the same use, figure it out later...
    M.INVALID_SOCKET = -1

    -- Bindings - Win32 - Constants - Error codes
    -- ------------------------------------------
    M.WSA_INVALID_HANDLE = 6
    M.WSA_NOT_ENOUGH_MEMORY = 8
    M.WSA_INVALID_PARAMETER = 87
    M.WSA_OPERATION_ABORTED = 995
    M.WSA_IO_INCOMPLETE = 996
    M.WSA_IO_PENDING = 997
    M.WSAEINTR = 10004
    M.WSAEBADF = 10009
    M.WSAEACCES = 10013
    M.WSAEFAULT = 10014
    M.WSAEINVAL = 10022
    M.WSAEMFILE = 10024
    M.WSAEWOULDBLOCK = 10035
    M.WSAEINPROGRESS = 10036
    M.WSAEALREADY = 10037
    M.WSAENOTSOCK = 10038
    M.WSAEDESTADDRREQ = 10039
    M.WSAEMSGSIZE = 10040
    M.WSAEPROTOTYPE = 10041
    M.WSAENOPROTOOPT = 10042
    M.WSAEPROTONOSUPPORT = 10043
    M.WSAESOCKTNOSUPPORT = 10044
    M.WSAEOPNOTSUPP = 10045
    M.WSAEPFNOSUPPORT = 10046
    M.WSAEAFNOSUPPORT = 10047
    M.WSAEADDRINUSE = 10048
    M.WSAEADDRNOTAVAIL = 10049
    M.WSAENETDOWN = 10050
    M.WSAENETUNREACH = 10051
    M.WSAENETRESET = 10052
    M.WSAECONNABORTED = 10053
    M.WSAECONNRESET = 10054
    M.WSAENOBUFS = 10055
    M.WSAEISCONN = 10056
    M.WSAENOTCONN = 10057
    M.WSAESHUTDOWN = 10058
    M.WSAETOOMANYREFS = 10059
    M.WSAETIMEDOUT = 10060
    M.WSAECONNREFUSED = 10061
    M.WSAELOOP = 10062
    M.WSAENAMETOOLONG = 10063
    M.WSAEHOSTDOWN = 10064
    M.WSAEHOSTUNREACH = 10065
    M.WSAENOTEMPTY = 10066
    M.WSAEPROCLIM = 10067
    M.WSAEUSERS = 10068
    M.WSAEDQUOT = 10069
    M.WSAESTALE = 10070
    M.WSAEREMOTE = 10071
    M.WSASYSNOTREADY = 10091
    M.WSAVERNOTSUPPORTED = 10092
    M.WSANOTINITIALISED = 10093
    M.WSAEDISCON = 10101
    M.WSAENOMORE = 10102
    M.WSAECANCELLED = 10103
    M.WSAEINVALIDPROCTABLE = 10104
    M.WSAEINVALIDPROVIDER = 10105
    M.WSAEPROVIDERFAILEDINIT = 10106
    M.WSASYSCALLFAILURE = 10107
    M.WSASERVICE_NOT_FOUND = 10108
    M.WSATYPE_NOT_FOUND = 10109
    M.WSA_E_NO_MORE = 10110
    M.WSA_E_CANCELLED = 10111
    M.WSAEREFUSED = 10112
    M.WSAHOST_NOT_FOUND = 11001
    M.WSATRY_AGAIN = 11002
    M.WSANO_RECOVERY = 11003
    M.WSANO_DATA = 11004
    M.WSA_QOS_RECEIVERS = 11005
    M.WSA_QOS_SENDERS = 11006
    M.WSA_QOS_NO_SENDERS = 11007
    M.WSA_QOS_NO_RECEIVERS = 11008
    M.WSA_QOS_REQUEST_CONFIRMED = 11009
    M.WSA_QOS_ADMISSION_FAILURE = 11010
    M.WSA_QOS_POLICY_FAILURE = 11011
    M.WSA_QOS_BAD_STYLE = 11012
    M.WSA_QOS_BAD_OBJECT = 11013
    M.WSA_QOS_TRAFFIC_CTRL_ERROR = 11014
    M.WSA_QOS_GENERIC_ERROR = 11015
    M.WSA_QOS_ESERVICETYPE = 11016
    M.WSA_QOS_EFLOWSPEC = 11017
    M.WSA_QOS_EPROVSPECBUF = 11018
    M.WSA_QOS_EFILTERSTYLE = 11019
    M.WSA_QOS_EFILTERTYPE = 11020
    M.WSA_QOS_EFILTERCOUNT = 11021
    M.WSA_QOS_EOBJLENGTH = 11022
    M.WSA_QOS_EFLOWCOUNT = 11023
    M.WSA_QOS_EUNKOWNPSOBJ = 11024
    M.WSA_QOS_EPOLICYOBJ = 11025
    M.WSA_QOS_EFLOWDESC = 11026
    M.WSA_QOS_EPSFLOWSPEC = 11027
    M.WSA_QOS_EPSFILTERSPEC = 11028
    M.WSA_QOS_ESDMODEOBJ = 11029
    M.WSA_QOS_ESHAPERATEOBJ = 11030
    M.WSA_QOS_RESERVED_PETYPE = 11031

    -- Bindings - Win32 - Constants - Struct array sizes
    -- -------------------------------------------------
    M.WSADESCRIPTION_LEN = 256
    M.WSASYS_STATUS_LEN = 128

    -- Bindings - Win32 - DLL Loading
    -- ------------------------------
    M._socket_lib = ffi.load("Ws2_32")

    -- Bindings - Win32 - C Definitions
    -- --------------------------------
    -- Notes:
    --  The sizes used in the structure are present in `WSADESCRIPTION_LEN` and `WSASYS_STATUS_LEN`

    -- Structure(s)
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
        error("Unknown Windows platform ! (arch: " .. jit.arch .. ")")
    end

    -- Functions
    ffi.cdef [[
        int WSACleanup();
        int WSAGetLastError();
        void WSASetLastError(int iError);
        int WSAStartup(USHORT wVersionRequested, WSADATA* lpWSAData);
    ]]

    -- Bindings - Win32 - Function Exposure
    -- --------------------------------------
    M.connect = M._socket_lib.connect
    M.socket = M._socket_lib.socket
    M.shutdown = M._socket_lib.shutdown
    M.closesocket = M._socket_lib.closesocket
    M.send = M._socket_lib.send

    M.htons = M._socket_lib.htons
    M.inet_addr = M._socket_lib.inet_addr

    M.WSACleanup = M._socket_lib.WSACleanup

    --- Returns the last WinSock library error code.
    -- @function WSAGetLastError
    -- @return int
    M.WSAGetLastError = M._socket_lib.WSAGetLastError

    M.WSASetLastError = M._socket_lib.WSASetLastError

    --- Starts the WinSock library in order to be able to create sockets.
    -- @param USHORT wVersionRequested
    -- @param WSADATA* lpWSAData$
    -- @return int
    M.WSAStartup = M._socket_lib.WSAStartup

else
    error("This library can only be used on Win32 platforms ! (os: " .. ffi.os .. ")")
end

return M
