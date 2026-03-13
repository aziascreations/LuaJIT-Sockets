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

M.WSAErrorCodes = {
    WSA_INVALID_HANDLE = 6,
    WSA_NOT_ENOUGH_MEMORY = 8,
    WSA_INVALID_PARAMETER = 87,
    WSA_OPERATION_ABORTED = 995,
    WSA_IO_INCOMPLETE = 996,
    WSA_IO_PENDING = 997,
    WSAEINTR = 10004,
    WSAEBADF = 10009,
    WSAEACCES = 10013,
    WSAEFAULT = 10014,
    WSAEINVAL = 10022,
    WSAEMFILE = 10024,
    WSAEWOULDBLOCK = 10035,
    WSAEINPROGRESS = 10036,
    WSAEALREADY = 10037,
    WSAENOTSOCK = 10038,
    WSAEDESTADDRREQ = 10039,
    WSAEMSGSIZE = 10040,
    WSAEPROTOTYPE = 10041,
    WSAENOPROTOOPT = 10042,
    WSAEPROTONOSUPPORT = 10043,
    WSAESOCKTNOSUPPORT = 10044,
    WSAEOPNOTSUPP = 10045,
    WSAEPFNOSUPPORT = 10046,
    WSAEAFNOSUPPORT = 10047,
    WSAEADDRINUSE = 10048,
    WSAEADDRNOTAVAIL = 10049,
    WSAENETDOWN = 10050,
    WSAENETUNREACH = 10051,
    WSAENETRESET = 10052,
    WSAECONNABORTED = 10053,
    WSAECONNRESET = 10054,
    WSAENOBUFS = 10055,
    WSAEISCONN = 10056,
    WSAENOTCONN = 10057,
    WSAESHUTDOWN = 10058,
    WSAETOOMANYREFS = 10059,
    WSAETIMEDOUT = 10060,
    WSAECONNREFUSED = 10061,
    WSAELOOP = 10062,
    WSAENAMETOOLONG = 10063,
    WSAEHOSTDOWN = 10064,
    WSAEHOSTUNREACH = 10065,
    WSAENOTEMPTY = 10066,
    WSAEPROCLIM = 10067,
    WSAEUSERS = 10068,
    WSAEDQUOT = 10069,
    WSAESTALE = 10070,
    WSAEREMOTE = 10071,
    WSASYSNOTREADY = 10091,
    WSAVERNOTSUPPORTED = 10092,
    WSANOTINITIALISED = 10093,
    WSAEDISCON = 10101,
    WSAENOMORE = 10102,
    WSAECANCELLED = 10103,
    WSAEINVALIDPROCTABLE = 10104,
    WSAEINVALIDPROVIDER = 10105,
    WSAEPROVIDERFAILEDINIT = 10106,
    WSASYSCALLFAILURE = 10107,
    WSASERVICE_NOT_FOUND = 10108,
    WSATYPE_NOT_FOUND = 10109,
    WSA_E_NO_MORE = 10110,
    WSA_E_CANCELLED = 10111,
    WSAEREFUSED = 10112,
    WSAHOST_NOT_FOUND = 11001,
    WSATRY_AGAIN = 11002,
    WSANO_RECOVERY = 11003,
    WSANO_DATA = 11004,
    WSA_QOS_RECEIVERS = 11005,
    WSA_QOS_SENDERS = 11006,
    WSA_QOS_NO_SENDERS = 11007,
    WSA_QOS_NO_RECEIVERS = 11008,
    WSA_QOS_REQUEST_CONFIRMED = 11009,
    WSA_QOS_ADMISSION_FAILURE = 11010,
    WSA_QOS_POLICY_FAILURE = 11011,
    WSA_QOS_BAD_STYLE = 11012,
    WSA_QOS_BAD_OBJECT = 11013,
    WSA_QOS_TRAFFIC_CTRL_ERROR = 11014,
    WSA_QOS_GENERIC_ERROR = 11015,
    WSA_QOS_ESERVICETYPE = 11016,
    WSA_QOS_EFLOWSPEC = 11017,
    WSA_QOS_EPROVSPECBUF = 11018,
    WSA_QOS_EFILTERSTYLE = 11019,
    WSA_QOS_EFILTERTYPE = 11020,
    WSA_QOS_EFILTERCOUNT = 11021,
    WSA_QOS_EOBJLENGTH = 11022,
    WSA_QOS_EFLOWCOUNT = 11023,
    WSA_QOS_EUNKOWNPSOBJ = 11024,
    WSA_QOS_EPOLICYOBJ = 11025,
    WSA_QOS_EFLOWDESC = 11026,
    WSA_QOS_EPSFLOWSPEC = 11027,
    WSA_QOS_EPSFILTERSPEC = 11028,
    WSA_QOS_ESDMODEOBJ = 11029,
    WSA_QOS_ESHAPERATEOBJ = 11030,
    WSA_QOS_RESERVED_PETYPE = 11031,
}

M.WSAErrorMessages = {
    [M.WSAErrorCodes.WSA_INVALID_HANDLE] = "Specified event object handle is invalid. (WSA_INVALID_HANDLE)",
    [M.WSAErrorCodes.WSA_NOT_ENOUGH_MEMORY] = "Insufficient memory available. (WSA_NOT_ENOUGH_MEMORY)",
    [M.WSAErrorCodes.WSA_INVALID_PARAMETER] = "One or more parameters are invalid. (WSA_INVALID_PARAMETER)",
    [M.WSAErrorCodes.WSA_OPERATION_ABORTED] = "Overlapped operation aborted. (WSA_OPERATION_ABORTED)",
    [M.WSAErrorCodes.WSA_IO_INCOMPLETE] = "Overlapped I/O event object not in signaled state. (WSA_IO_INCOMPLETE)",
    [M.WSAErrorCodes.WSA_IO_PENDING] = "Overlapped operations will complete later. (WSA_IO_PENDING)",
    [M.WSAErrorCodes.WSAEINTR] = "Interrupted function call. (WSAEINTR)",
    [M.WSAErrorCodes.WSAEBADF] = "File handle is not valid. (WSAEBADF)",
    [M.WSAErrorCodes.WSAEACCES] = "Permission denied. (WSAEACCES)",
    [M.WSAErrorCodes.WSAEFAULT] = "Bad address. (WSAEFAULT)",
    [M.WSAErrorCodes.WSAEINVAL] = "Invalid argument. (WSAEINVAL)",
    [M.WSAErrorCodes.WSAEMFILE] = "Too many open files. (WSAEMFILE)",
    [M.WSAErrorCodes.WSAEWOULDBLOCK] = "Resource temporarily unavailable. (WSAEWOULDBLOCK)",
    [M.WSAErrorCodes.WSAEINPROGRESS] = "Operation now in progress. (WSAEINPROGRESS)",
    [M.WSAErrorCodes.WSAEALREADY] = "Operation already in progress. (WSAEALREADY)",
    [M.WSAErrorCodes.WSAENOTSOCK] = "Socket operation on nonsocket. (WSAENOTSOCK)",
    [M.WSAErrorCodes.WSAEDESTADDRREQ] = "Destination address required. (WSAEDESTADDRREQ)",
    [M.WSAErrorCodes.WSAEMSGSIZE] = "Message too long. (WSAEMSGSIZE)",
    [M.WSAErrorCodes.WSAEPROTOTYPE] = "Protocol wrong type for socket. (WSAEPROTOTYPE)",
    [M.WSAErrorCodes.WSAENOPROTOOPT] = "Bad protocol option. (WSAENOPROTOOPT)",
    [M.WSAErrorCodes.WSAEPROTONOSUPPORT] = "Protocol not supported. (WSAEPROTONOSUPPORT)",
    [M.WSAErrorCodes.WSAESOCKTNOSUPPORT] = "Socket type not supported. (WSAESOCKTNOSUPPORT)",
    [M.WSAErrorCodes.WSAEOPNOTSUPP] = "Operation not supported. (WSAEOPNOTSUPP)",
    [M.WSAErrorCodes.WSAEPFNOSUPPORT] = "Protocol family not supported. (WSAEPFNOSUPPORT)",
    [M.WSAErrorCodes.WSAEAFNOSUPPORT] = "Address family not supported by protocol family. (WSAEAFNOSUPPORT)",
    [M.WSAErrorCodes.WSAEADDRINUSE] = "Address already in use. (WSAEADDRINUSE)",
    [M.WSAErrorCodes.WSAEADDRNOTAVAIL] = "Cannot assign requested address. (WSAEADDRNOTAVAIL)",
    [M.WSAErrorCodes.WSAENETDOWN] = "Network is down. (WSAENETDOWN)",
    [M.WSAErrorCodes.WSAENETUNREACH] = "Network is unreachable. (WSAENETUNREACH)",
    [M.WSAErrorCodes.WSAENETRESET] = "Network dropped connection on reset. (WSAENETRESET)",
    [M.WSAErrorCodes.WSAECONNABORTED] = "Software caused connection abort. (WSAECONNABORTED)",
    [M.WSAErrorCodes.WSAECONNRESET] = "Connection reset by peer. (WSAECONNRESET)",
    [M.WSAErrorCodes.WSAENOBUFS] = "No buffer space available. (WSAENOBUFS)",
    [M.WSAErrorCodes.WSAEISCONN] = "Socket is already connected. (WSAEISCONN)",
    [M.WSAErrorCodes.WSAENOTCONN] = "Socket is not connected. (WSAENOTCONN)",
    [M.WSAErrorCodes.WSAESHUTDOWN] = "Cannot send after socket shutdown. (WSAESHUTDOWN)",
    [M.WSAErrorCodes.WSAETOOMANYREFS] = "Too many references. (WSAETOOMANYREFS)",
    [M.WSAErrorCodes.WSAETIMEDOUT] = "Connection timed out. (WSAETIMEDOUT)",
    [M.WSAErrorCodes.WSAECONNREFUSED] = "Connection refused. (WSAECONNREFUSED)",
    [M.WSAErrorCodes.WSAELOOP] = "Cannot translate name. (WSAELOOP)",
    [M.WSAErrorCodes.WSAENAMETOOLONG] = "Name too long. (WSAENAMETOOLONG)",
    [M.WSAErrorCodes.WSAEHOSTDOWN] = "Host is down. (WSAEHOSTDOWN)",
    [M.WSAErrorCodes.WSAEHOSTUNREACH] = "No route to host. (WSAEHOSTUNREACH)",
    [M.WSAErrorCodes.WSAENOTEMPTY] = "Directory not empty. (WSAENOTEMPTY)",
    [M.WSAErrorCodes.WSAEPROCLIM] = "Too many processes. (WSAEPROCLIM)",
    [M.WSAErrorCodes.WSAEUSERS] = "User quota exceeded. (WSAEUSERS)",
    [M.WSAErrorCodes.WSAEDQUOT] = "Disk quota exceeded. (WSAEDQUOT)",
    [M.WSAErrorCodes.WSAESTALE] = "Stale file handle reference. (WSAESTALE)",
    [M.WSAErrorCodes.WSAEREMOTE] = "Item is remote. (WSAEREMOTE)",
    [M.WSAErrorCodes.WSASYSNOTREADY] = "Network subsystem is unavailable. (WSASYSNOTREADY)",
    [M.WSAErrorCodes.WSAVERNOTSUPPORTED] = "Winsock.dll version out of range. (WSAVERNOTSUPPORTED)",
    [M.WSAErrorCodes.WSANOTINITIALISED] = "Successful WSAStartup not yet performed. (WSANOTINITIALISED)",
    [M.WSAErrorCodes.WSAEDISCON] = "Graceful shutdown in progress. (WSAEDISCON)",
    [M.WSAErrorCodes.WSAENOMORE] = "No more results. (WSAENOMORE)",
    [M.WSAErrorCodes.WSAECANCELLED] = "Call has been canceled. (WSAECANCELLED)",
    [M.WSAErrorCodes.WSAEINVALIDPROCTABLE] = "Procedure call table is invalid. (WSAEINVALIDPROCTABLE)",
    [M.WSAErrorCodes.WSAEINVALIDPROVIDER] = "Service provider is invalid. (WSAEINVALIDPROVIDER)",
    [M.WSAErrorCodes.WSAEPROVIDERFAILEDINIT] = "Service provider failed to initialize. (WSAEPROVIDERFAILEDINIT)",
    [M.WSAErrorCodes.WSASYSCALLFAILURE] = "System call failure. (WSASYSCALLFAILURE)",
    [M.WSAErrorCodes.WSASERVICE_NOT_FOUND] = "Service not found. (WSASERVICE_NOT_FOUND)",
    [M.WSAErrorCodes.WSATYPE_NOT_FOUND] = "Class type not found. (WSATYPE_NOT_FOUND)",
    [M.WSAErrorCodes.WSA_E_NO_MORE] = "No more results. (WSA_E_NO_MORE)",
    [M.WSAErrorCodes.WSA_E_CANCELLED] = "Call was canceled. (WSA_E_CANCELLED)",
    [M.WSAErrorCodes.WSAEREFUSED] = "Database query was refused. (WSAEREFUSED)",
    [M.WSAErrorCodes.WSAHOST_NOT_FOUND] = "Host not found. (WSAHOST_NOT_FOUND)",
    [M.WSAErrorCodes.WSATRY_AGAIN] = "Nonauthoritative host not found. (WSATRY_AGAIN)",
    [M.WSAErrorCodes.WSANO_RECOVERY] = "This is a nonrecoverable error. (WSANO_RECOVERY)",
    [M.WSAErrorCodes.WSANO_DATA] = "Valid name, no data record of requested type. (WSANO_DATA)",
    [M.WSAErrorCodes.WSA_QOS_RECEIVERS] = "QoS receivers. (WSA_QOS_RECEIVERS)",
    [M.WSAErrorCodes.WSA_QOS_SENDERS] = "QoS senders. (WSA_QOS_SENDERS)",
    [M.WSAErrorCodes.WSA_QOS_NO_SENDERS] = "No QoS senders. (WSA_QOS_NO_SENDERS)",
    [M.WSAErrorCodes.WSA_QOS_NO_RECEIVERS] = "QoS no receivers. (WSA_QOS_NO_RECEIVERS)",
    [M.WSAErrorCodes.WSA_QOS_REQUEST_CONFIRMED] = "QoS request confirmed. (WSA_QOS_REQUEST_CONFIRMED)",
    [M.WSAErrorCodes.WSA_QOS_ADMISSION_FAILURE] = "QoS admission error. (WSA_QOS_ADMISSION_FAILURE)",
    [M.WSAErrorCodes.WSA_QOS_POLICY_FAILURE] = "QoS policy failure. (WSA_QOS_POLICY_FAILURE)",
    [M.WSAErrorCodes.WSA_QOS_BAD_STYLE] = "QoS bad style. (WSA_QOS_BAD_STYLE)",
    [M.WSAErrorCodes.WSA_QOS_BAD_OBJECT] = "QoS bad object. (WSA_QOS_BAD_OBJECT)",
    [M.WSAErrorCodes.WSA_QOS_TRAFFIC_CTRL_ERROR] = "QoS traffic control error. (WSA_QOS_TRAFFIC_CTRL_ERROR)",
    [M.WSAErrorCodes.WSA_QOS_GENERIC_ERROR] = "QoS generic error. (WSA_QOS_GENERIC_ERROR)",
    [M.WSAErrorCodes.WSA_QOS_ESERVICETYPE] = "QoS service type error. (WSA_QOS_ESERVICETYPE)",
    [M.WSAErrorCodes.WSA_QOS_EFLOWSPEC] = "QoS flowspec error. (WSA_QOS_EFLOWSPEC)",
    [M.WSAErrorCodes.WSA_QOS_EPROVSPECBUF] = "Invalid QoS provider buffer. (WSA_QOS_EPROVSPECBUF)",
    [M.WSAErrorCodes.WSA_QOS_EFILTERSTYLE] = "Invalid QoS filter style. (WSA_QOS_EFILTERSTYLE)",
    [M.WSAErrorCodes.WSA_QOS_EFILTERTYPE] = "Invalid QoS filter type. (WSA_QOS_EFILTERTYPE)",
    [M.WSAErrorCodes.WSA_QOS_EFILTERCOUNT] = "Incorrect QoS filter count. (WSA_QOS_EFILTERCOUNT)",
    [M.WSAErrorCodes.WSA_QOS_EOBJLENGTH] = "Invalid QoS object length. (WSA_QOS_EOBJLENGTH)",
    [M.WSAErrorCodes.WSA_QOS_EFLOWCOUNT] = "Incorrect QoS flow count. (WSA_QOS_EFLOWCOUNT)",
    [M.WSAErrorCodes.WSA_QOS_EUNKOWNPSOBJ] = "Unrecognized QoS object. (WSA_QOS_EUNKOWNPSOBJ)",
    [M.WSAErrorCodes.WSA_QOS_EPOLICYOBJ] = "Invalid QoS policy object. (WSA_QOS_EPOLICYOBJ)",
    [M.WSAErrorCodes.WSA_QOS_EFLOWDESC] = "Invalid QoS flow descriptor. (WSA_QOS_EFLOWDESC)",
    [M.WSAErrorCodes.WSA_QOS_EPSFLOWSPEC] = "Invalid QoS provider-specific flowspec. (WSA_QOS_EPSFLOWSPEC)",
    [M.WSAErrorCodes.WSA_QOS_EPSFILTERSPEC] = "Invalid QoS provider-specific filterspec. (WSA_QOS_EPSFILTERSPEC)",
    [M.WSAErrorCodes.WSA_QOS_ESDMODEOBJ] = "Invalid QoS shape discard mode object. (WSA_QOS_ESDMODEOBJ)",
    [M.WSAErrorCodes.WSA_QOS_ESHAPERATEOBJ] = "Invalid QoS shaping rate object. (WSA_QOS_ESHAPERATEOBJ)",
    [M.WSAErrorCodes.WSA_QOS_RESERVED_PETYPE] = "Reserved policy QoS element type. (WSA_QOS_RESERVED_PETYPE)",
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

        return true, 0
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
            return nil, M._socket_lib.WSAGetLastError()
        end

        return true, 0
    end

    function M.last_error()
        return M._socket_lib.WSAGetLastError()
    end

    function M.last_error_message()
        local err_code = M.last_error()
        local msg = M.WSAErrorMessages[err_code]

        if msg == nil then
            msg = "Unknown WSA error ! (" .. err_code .. ")"
        end

        return msg
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
