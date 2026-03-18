-- ========================================
--  NibblePoker's LuaJIT Socket
--    Wrapper Root
-- ========================================
--  ???
-- ========================================

-- Compilation options
-- -------------------

--- Enables or disables the inclusion of human-readable error messages in `M.WSAErrorMessages`. \
-- Can be usefull if you pre-compile this library.
local _INCLUDE_ERROR_MESSAGES = true


-- Setup
-- -----
local ffi = require("ffi")

local socket_bindings = require("socket.bindings")

--- Module that provides platform-independant wrappers for socket-related functions while keeping the
---  platform-dependant error constants.
-- @module socket.wrapper
-- @alias M
local M = {}

M.bindings = socket_bindings


-- Private globals
-- ---------------
M._is_initialized = false

-- Bindings - Commons - Constants
-- ------------------------------

M.AddressFamilies = {
    AF_UNSPEC = M.bindings.AF_UNSPEC,
    AF_INET = M.bindings.AF_INET,
    AF_IPX = M.bindings.AF_IPX,
    AF_APPLETALK = M.bindings.AF_APPLETALK,
    AF_NETBIOS = M.bindings.AF_NETBIOS,
    AF_INET6 = M.bindings.AF_INET6,
    AF_IRDA = M.bindings.AF_IRDA,
    AF_BTH = M.bindings.AF_BTH
}

M.SocketTypes = {
    SOCK_STREAM = M.bindings.SOCK_STREAM,
    SOCK_DGRAM = M.bindings.SOCK_DGRAM,
    SOCK_RAW = M.bindings.SOCK_RAW,
    SOCK_RDM = M.bindings.SOCK_RDM,
    SOCK_SEQPACKET = M.bindings.SOCK_SEQPACKET
}

M.Protocols = {
    IPPROTO_ICMP = M.bindings.IPPROTO_ICMP,
    IPPROTO_IGMP = M.bindings.IPPROTO_IGMP,
    BTHPROTO_RFCOMM = M.bindings.BTHPROTO_RFCOMM,
    IPPROTO_TCP = M.bindings.IPPROTO_TCP,
    IPPROTO_UDP = M.bindings.IPPROTO_UDP,
    IPPROTO_ICMPV6 = M.bindings.IPPROTO_ICMPV6,
    IPPROTO_RM = M.bindings.IPPROTO_RM
}

M.ShutdownFlags = {
    --- Shutdown receive operations.
    SD_RECEIVE = M.bindings.SD_RECEIVE,

    --- Shutdown send operations.
    SD_SEND = M.bindings.SD_SEND,

    --- Shutdown both send and receive operations.
    SD_BOTH = M.bindings.SD_BOTH
}


M.ShutdownFlags = {
    --- Shutdown receive operations.
    SD_RECEIVE = M.bindings.SD_RECEIVE,

    --- Shutdown send operations.
    SD_SEND = M.bindings.SD_SEND,

    --- Shutdown both send and receive operations.
    SD_BOTH = M.bindings.SD_BOTH
}

M.BindingAddresses = {
    INADDR_ANY = M.bindings.INADDR_ANY,
    INADDR_NONE = M.bindings.INADDR_NONE,
}


-- Copying platform-specific things
if ffi.os == "Windows" then

    -- Bindings - Win32 - Constants
    -- ----------------------------
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
        WSA_QOS_RESERVED_PETYPE = 11031
    }

    if _INCLUDE_ERROR_MESSAGES then
        -- Note: This lookup table doesn't reference the constants above to help the compiler optimize out unused ones.
        M.WSAErrorMessages = {
            [6] = "Specified event object handle is invalid. (WSA_INVALID_HANDLE)",
            [8] = "Insufficient memory available. (WSA_NOT_ENOUGH_MEMORY)",
            [87] = "One or more parameters are invalid. (WSA_INVALID_PARAMETER)",
            [995] = "Overlapped operation aborted. (WSA_OPERATION_ABORTED)",
            [996] = "Overlapped I/O event object not in signaled state. (WSA_IO_INCOMPLETE)",
            [997] = "Overlapped operations will complete later. (WSA_IO_PENDING)",
            [10004] = "Interrupted function call. (WSAEINTR)",
            [10009] = "File handle is not valid. (WSAEBADF)",
            [10013] = "Permission denied. (WSAEACCES)",
            [10014] = "Bad address. (WSAEFAULT)",
            [10022] = "Invalid argument. (WSAEINVAL)",
            [10024] = "Too many open files. (WSAEMFILE)",
            [10035] = "Resource temporarily unavailable. (WSAEWOULDBLOCK)",
            [10036] = "Operation now in progress. (WSAEINPROGRESS)",
            [10037] = "Operation already in progress. (WSAEALREADY)",
            [10038] = "Socket operation on nonsocket. (WSAENOTSOCK)",
            [10039] = "Destination address required. (WSAEDESTADDRREQ)",
            [10040] = "Message too long. (WSAEMSGSIZE)",
            [10041] = "Protocol wrong type for socket. (WSAEPROTOTYPE)",
            [10042] = "Bad protocol option. (WSAENOPROTOOPT)",
            [10043] = "Protocol not supported. (WSAEPROTONOSUPPORT)",
            [10044] = "Socket type not supported. (WSAESOCKTNOSUPPORT)",
            [10045] = "Operation not supported. (WSAEOPNOTSUPP)",
            [10046] = "Protocol family not supported. (WSAEPFNOSUPPORT)",
            [10047] = "Address family not supported by protocol family. (WSAEAFNOSUPPORT)",
            [10048] = "Address already in use. (WSAEADDRINUSE)",
            [10049] = "Cannot assign requested address. (WSAEADDRNOTAVAIL)",
            [10050] = "Network is down. (WSAENETDOWN)",
            [10051] = "Network is unreachable. (WSAENETUNREACH)",
            [10052] = "Network dropped connection on reset. (WSAENETRESET)",
            [10053] = "Software caused connection abort. (WSAECONNABORTED)",
            [10054] = "Connection reset by peer. (WSAECONNRESET)",
            [10055] = "No buffer space available. (WSAENOBUFS)",
            [10056] = "Socket is already connected. (WSAEISCONN)",
            [10057] = "Socket is not connected. (WSAENOTCONN)",
            [10058] = "Cannot send after socket shutdown. (WSAESHUTDOWN)",
            [10059] = "Too many references. (WSAETOOMANYREFS)",
            [10060] = "Connection timed out. (WSAETIMEDOUT)",
            [10061] = "Connection refused. (WSAECONNREFUSED)",
            [10062] = "Cannot translate name. (WSAELOOP)",
            [10063] = "Name too long. (WSAENAMETOOLONG)",
            [10064] = "Host is down. (WSAEHOSTDOWN)",
            [10065] = "No route to host. (WSAEHOSTUNREACH)",
            [10066] = "Directory not empty. (WSAENOTEMPTY)",
            [10067] = "Too many processes. (WSAEPROCLIM)",
            [10068] = "User quota exceeded. (WSAEUSERS)",
            [10069] = "Disk quota exceeded. (WSAEDQUOT)",
            [10070] = "Stale file handle reference. (WSAESTALE)",
            [10071] = "Item is remote. (WSAEREMOTE)",
            [10091] = "Network subsystem is unavailable. (WSASYSNOTREADY)",
            [10092] = "Winsock.dll version out of range. (WSAVERNOTSUPPORTED)",
            [10093] = "Successful WSAStartup not yet performed. (WSANOTINITIALISED)",
            [10101] = "Graceful shutdown in progress. (WSAEDISCON)",
            [10102] = "No more results. (WSAENOMORE)",
            [10103] = "Call has been canceled. (WSAECANCELLED)",
            [10104] = "Procedure call table is invalid. (WSAEINVALIDPROCTABLE)",
            [10105] = "Service provider is invalid. (WSAEINVALIDPROVIDER)",
            [10106] = "Service provider failed to initialize. (WSAEPROVIDERFAILEDINIT)",
            [10107] = "System call failure. (WSASYSCALLFAILURE)",
            [10108] = "Service not found. (WSASERVICE_NOT_FOUND)",
            [10109] = "Class type not found. (WSATYPE_NOT_FOUND)",
            [10110] = "No more results. (WSA_E_NO_MORE)",
            [10111] = "Call was canceled. (WSA_E_CANCELLED)",
            [10112] = "Database query was refused. (WSAEREFUSED)",
            [11001] = "Host not found. (WSAHOST_NOT_FOUND)",
            [11002] = "Nonauthoritative host not found. (WSATRY_AGAIN)",
            [11003] = "This is a nonrecoverable error. (WSANO_RECOVERY)",
            [11004] = "Valid name, no data record of requested type. (WSANO_DATA)",
            [11005] = "QoS receivers. (WSA_QOS_RECEIVERS)",
            [11006] = "QoS senders. (WSA_QOS_SENDERS)",
            [11007] = "No QoS senders. (WSA_QOS_NO_SENDERS)",
            [11008] = "QoS no receivers. (WSA_QOS_NO_RECEIVERS)",
            [11009] = "QoS request confirmed. (WSA_QOS_REQUEST_CONFIRMED)",
            [11010] = "QoS admission error. (WSA_QOS_ADMISSION_FAILURE)",
            [11011] = "QoS policy failure. (WSA_QOS_POLICY_FAILURE)",
            [11012] = "QoS bad style. (WSA_QOS_BAD_STYLE)",
            [11013] = "QoS bad object. (WSA_QOS_BAD_OBJECT)",
            [11014] = "QoS traffic control error. (WSA_QOS_TRAFFIC_CTRL_ERROR)",
            [11015] = "QoS generic error. (WSA_QOS_GENERIC_ERROR)",
            [11016] = "QoS service type error. (WSA_QOS_ESERVICETYPE)",
            [11017] = "QoS flowspec error. (WSA_QOS_EFLOWSPEC)",
            [11018] = "Invalid QoS provider buffer. (WSA_QOS_EPROVSPECBUF)",
            [11019] = "Invalid QoS filter style. (WSA_QOS_EFILTERSTYLE)",
            [11020] = "Invalid QoS filter type. (WSA_QOS_EFILTERTYPE)",
            [11021] = "Incorrect QoS filter count. (WSA_QOS_EFILTERCOUNT)",
            [11022] = "Invalid QoS object length. (WSA_QOS_EOBJLENGTH)",
            [11023] = "Incorrect QoS flow count. (WSA_QOS_EFLOWCOUNT)",
            [11024] = "Unrecognized QoS object. (WSA_QOS_EUNKOWNPSOBJ)",
            [11025] = "Invalid QoS policy object. (WSA_QOS_EPOLICYOBJ)",
            [11026] = "Invalid QoS flow descriptor. (WSA_QOS_EFLOWDESC)",
            [11027] = "Invalid QoS provider-specific flowspec. (WSA_QOS_EPSFLOWSPEC)",
            [11028] = "Invalid QoS provider-specific filterspec. (WSA_QOS_EPSFILTERSPEC)",
            [11029] = "Invalid QoS shape discard mode object. (WSA_QOS_ESDMODEOBJ)",
            [11030] = "Invalid QoS shaping rate object. (WSA_QOS_ESHAPERATEOBJ)",
            [11031] = "Reserved policy QoS element type. (WSA_QOS_RESERVED_PETYPE)"
        }
    else
        M.WSAErrorMessage = {}
    end

    -- ???
    M.__wsadata = nil
    M.__rc = nil
    M.__is_initialized = false

    -- Bindings - Win32 - Function - Initialization
    -- --------------------------------------------

    --- Initializes the native socket libraries if required.
    --- ???
    --- @return boolean `true` if the operation succeeded, `false` otherwise.
    --- @return integer Error code if the operation was a failure, `0` otherwise.
    --- @see deinit
    function M.init()
        if not M.__is_initialized then
            M.__wsadata = ffi.new("WSADATA")
            M.__rc = M.bindings.WSAStartup(0x0202, M.__wsadata)

            if M.__rc ~= 0 then
                return false, M.bindings.WSAGetLastError()
            end

            M.__is_initialized = true
        end

        return true, 0
    end

    --- De-initializes the native socket libraries if required, and closes all active sockets.
    --- ???
    --- @return boolean - `true` if the operation succeeded, `false` otherwise.
    --- @return integer Error code if the operation was a failure, `0` otherwise.
    --- @see init
    function M.deinit()
        local err_code = M.bindings.WSACleanup()

        if err_code ~= 0 then
            return false, M.bindings.WSAGetLastError()
        end

        -- `free()` is handled by LuaJIT
        M.__wsadata = nil

        return true, 0
    end

    -- Bindings - Win32 - Function - Socket
    -- ------------------------------------

    --- Creates a new socket of a given address family, type, and protocol.
    --- Requires a prior call to `init()` on some platforms.
    ---@param af integer An address family from the `bindings.AF_*` constants, or the `AddressFamilies` enum.
    ---@param socktype integer A socket type from the `bindings.SOCK_*` constants, or the `SocketTypes` enum.
    ---@param protocol integer An address family from the `bindings.IPPROTO_*`/`bindings.BTHPROTO_*` constants, or the `Protocols` enum.
    ---@return SOCKET? A non-nil value representating the socket if opened, `nil` otherwise.
    ---@return integer Error code if the operation was a failure, `0` otherwise.
    ---@see closesocket
    function M.socket(af, socktype, protocol)
        local sock = M.bindings.socket(af, socktype, protocol)

        if sock == M.bindings.INVALID_SOCKET then
            return false, M.bindings.WSAGetLastError()
        end

        return sock, 0;
    end

    --- Closes a given socket that was previously created.
    ---@param s SOCKET The socket to close.
    ---@return boolean `true` if the operation succeeded, `false` otherwise.
    ---@return integer Error code if the operation was a failure, `0` otherwise.
    ---@see socket
    function M.closesocket(s)
        local err_code = M.bindings.closesocket(s)

        if err_code ~= 0 then
            return false, M.bindings.WSAGetLastError()
        end

        return true, 0
    end

    -- Bindings - Win32 - Function - Connections
    -- -----------------------------------------

    --- Creates a connection to a distant host via a given socket.
    ---@param s SOCKET The socket over which the connection will pass.
    ---@param af integer An address family from the `bindings.AF_*` constants, or the `AddressFamilies` enum.
    ---@param port integer The remote host's port.
    ---@param host string The remote host's hostname/IP/address/...
    ---@return boolean `true` if the operation succeeded, `false` otherwise.
    ---@return integer Error code if the operation was a failure, `0` otherwise.
    ---@see shutdown
    function M.connect(s, af, port, host)
        local addr = ffi.new("sockaddr_in")
        addr.sin_family = af
        addr.sin_port = M.bindings.htons(port)
        addr.sin_addr.s_addr = M.bindings.inet_addr(host)

        local conn = M.bindings.connect(s, ffi.cast("sockaddr*", addr), ffi.sizeof(addr))
        if conn ~= 0 then
            return false, M.bindings.WSAGetLastError()
        end

        return true, 0
    end

    --- Binds a given socket to some interface, or none.
    ---@param s SOCKET The socket that should be bound.
    ---@param af integer An address family from the `bindings.AF_*` constants, or the `AddressFamilies` enum.
    ---@param port integer The bound port.
    ---@param host string The bound interface's address, or a constant from the `bindings.INADDR_*` family, or the `BindingAddresses` enum.
    ---@return boolean `true` if the operation succeeded, `false` otherwise.
    ---@return integer Error code if the operation was a failure, `0` otherwise.
    ---@see shutdown
    ---@see listen
    function M.bind(s, af, port, host)
        local addr = ffi.new("sockaddr_in")
        addr.sin_family = af
        addr.sin_port = M.bindings.htons(port)
        addr.sin_addr.s_addr = M.bindings.inet_addr(host)

        local conn = M.bindings.bind(s, ffi.cast("sockaddr*", addr), ffi.sizeof(addr))
        if conn ~= 0 then
            return false, M.bindings.WSAGetLastError()
        end

        return true, 0
    end

    --- Closes a connection to distant host made via a given socket.
    ---@param s SOCKET The socket whose connection should be terminated.
    ---@param how integer A combination of shutdown flags from the `bindings.SD_*` constants, or the `ShutdownFlags` enum.
    ---@return boolean `true` if the operation succeeded, `false` otherwise.
    ---@return integer Error code if the operation was a failure, `0` otherwise.
    ---@see shutdown
    function M.shutdown(s, how)
        local err_code = M.bindings.shutdown(s, how)

        if err_code ~= 0 then
            return false, M.bindings.WSAGetLastError()
        end

        return true, 0
    end

    -- Bindings - Win32 - Function - Data
    -- ----------------------------------

    -- Bindings - Win32 - Function - Data - C-to-S
    -- -------------------------------------------

    ---Sends data over a given socket
    ---@param s SOCKET The socket over which data is to be sent.
    ---@param data any The data to send, its length will be calculated automatically.
    ---@param len integer? Leave empty to auto-calculate the data length. (Remove in the future, only OOP version shoud do this !)
    ---@param flags integer? Optional flags used to influence the way data is sent.
    ---@return integer bytes_sent The amount of bytes sent, or `SOCKET_ERROR` if an error occured.
    function M.send(s, data, len, flags)
        -- Handling the length
        if len == nil then
            len = #data
        end

        if len < 0 then
            M.bindings.WSASetLastError(M.WSAErrorCodes.WSA_INVALID_PARAMETER)
            return M.SOCKET_ERROR
        end

        -- Handling the data
        if not data then
            M.bindings.WSASetLastError(M.WSAErrorCodes.WSA_INVALID_PARAMETER)
            return M.SOCKET_ERROR
        end

        -- NOTE: Isn't `nil` technically `0` in this case ?
        if not flags then
            flags = 0
        end

        local p_data = ffi.cast("const char *", data)

        -- Errors should be handled by the calling function here.
        return M.bindings.send(s, p_data, len, flags)
    end

    -- Bindings - Win32 - Function - Data - S-to-C
    -- -------------------------------------------

    -- Bindings - Win32 - Function - Error Handling
    -- --------------------------------------------
    function M.last_error()
        return M.bindings.WSAGetLastError()
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
    error("This library can only be used on Win32 platforms !")
end

return M
