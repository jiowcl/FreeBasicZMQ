'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Pragma Once

' Socket Types
Const ZMQ_PAIR   As Long = 0
Const ZMQ_PUB    As Long = 1
Const ZMQ_SUB    As Long = 2
Const ZMQ_REQ    As Long = 3
Const ZMQ_REP    As Long = 4
Const ZMQ_DEALER As Long = 5
Const ZMQ_ROUTER As Long = 6
Const ZMQ_PULL   As Long = 7
Const ZMQ_PUSH   As Long = 8
Const ZMQ_XPUB   As Long = 9
Const ZMQ_XSUB   As Long = 10
Const ZMQ_STREAM As Long = 11

' Socket Options
Const ZMQ_AFFINITY                          As Long = 4
Const ZMQ_ROUTING_ID                        As Long = 5
Const ZMQ_SUBSCRIBE                         As Long = 6
Const ZMQ_UNSUBSCRIBE                       As Long = 7
Const ZMQ_RATE                              As Long = 8
Const ZMQ_RECOVERY_IVL                      As Long = 9
Const ZMQ_SNDBUF                            As Long = 11
Const ZMQ_RCVBUF                            As Long = 12
Const ZMQ_RCVMORE                           As Long = 13
Const ZMQ_FD                                As Long = 14
Const ZMQ_EVENTS                            As Long = 15
Const ZMQ_TYPE                              As Long = 16
Const ZMQ_LINGER                            As Long = 17
Const ZMQ_RECONNECT_IVL                     As Long = 18
Const ZMQ_BACKLOG                           As Long = 19
Const ZMQ_RECONNECT_IVL_MAX                 As Long = 21
Const ZMQ_MAXMSGSIZE                        As Long = 22
Const ZMQ_SNDHWM                            As Long = 23
Const ZMQ_RCVHWM                            As Long = 24
Const ZMQ_MULTICAST_HOPS                    As Long = 25
Const ZMQ_RCVTIMEO                          As Long = 27
Const ZMQ_SNDTIMEO                          As Long = 28
Const ZMQ_LAST_ENDPOINT                     As Long = 32
Const ZMQ_ROUTER_MANDATORY                  As Long = 33
Const ZMQ_TCP_KEEPALIVE                     As Long = 34
Const ZMQ_TCP_KEEPALIVE_CNT                 As Long = 35
Const ZMQ_TCP_KEEPALIVE_IDLE                As Long = 36
Const ZMQ_TCP_KEEPALIVE_INTVL               As Long = 37
Const ZMQ_IMMEDIATE                         As Long = 39
Const ZMQ_XPUB_VERBOSE                      As Long = 40
Const ZMQ_ROUTER_RAW                        As Long = 41
Const ZMQ_IPV6                              As Long = 42
Const ZMQ_MECHANISM                         As Long = 43
Const ZMQ_PLAIN_SERVER                      As Long = 44
Const ZMQ_PLAIN_USERNAME                    As Long = 45
Const ZMQ_PLAIN_PASSWORD                    As Long = 46
Const ZMQ_CURVE_SERVER                      As Long = 47
Const ZMQ_CURVE_PUBLICKEY                   As Long = 48
Const ZMQ_CURVE_SECRETKEY                   As Long = 49
Const ZMQ_CURVE_SERVERKEY                   As Long = 50
Const ZMQ_PROBE_ROUTER                      As Long = 51
Const ZMQ_REQ_CORRELATE                     As Long = 52
Const ZMQ_REQ_RELAXED                       As Long = 53
Const ZMQ_CONFLATE                          As Long = 54
Const ZMQ_ZAP_DOMAIN                        As Long = 55
Const ZMQ_ROUTER_HANDOVER                   As Long = 56
Const ZMQ_TOS                               As Long = 57
Const ZMQ_CONNECT_ROUTING_ID                As Long = 61
Const ZMQ_GSSAPI_SERVER                     As Long = 62
Const ZMQ_GSSAPI_PRINCIPAL                  As Long = 63
Const ZMQ_GSSAPI_SERVICE_PRINCIPAL          As Long = 64
Const ZMQ_GSSAPI_PLAINTEXT                  As Long = 65
Const ZMQ_HANDSHAKE_IVL                     As Long = 66
Const ZMQ_SOCKS_PROXY                       As Long = 68
Const ZMQ_XPUB_NODROP                       As Long = 69
Const ZMQ_BLOCKY                            As Long = 70
Const ZMQ_XPUB_MANUAL                       As Long = 71
Const ZMQ_XPUB_WELCOME_MSG                  As Long = 72
Const ZMQ_STREAM_NOTIFY                     As Long = 73
Const ZMQ_INVERT_MATCHING                   As Long = 74
Const ZMQ_HEARTBEAT_IVL                     As Long = 75
Const ZMQ_HEARTBEAT_TTL                     As Long = 76
Const ZMQ_HEARTBEAT_TIMEOUT                 As Long = 77
Const ZMQ_XPUB_VERBOSER                     As Long = 78
Const ZMQ_CONNECT_TIMEOUT                   As Long = 79
Const ZMQ_TCP_MAXRT                         As Long = 80
Const ZMQ_THREAD_SAFE                       As Long = 81
Const ZMQ_MULTICAST_MAXTPDU                 As Long = 84
Const ZMQ_VMCI_BUFFER_SIZE                  As Long = 85
Const ZMQ_VMCI_BUFFER_MIN_SIZE              As Long = 86
Const ZMQ_VMCI_BUFFER_MAX_SIZE              As Long = 87
Const ZMQ_VMCI_CONNECT_TIMEOUT              As Long = 88
Const ZMQ_USE_FD                            As Long = 89
Const ZMQ_GSSAPI_PRINCIPAL_NAMETYPE         As Long = 90
Const ZMQ_GSSAPI_SERVICE_PRINCIPAL_NAMETYPE As Long = 91
Const ZMQ_BINDTODEVICE                      As Long = 92

' Context Options
Const ZMQ_IO_THREADS                 As Long = 1
Const ZMQ_MAX_SOCKETS                As Long = 2
Const ZMQ_SOCKET_LIMIT               As Long = 3
Const ZMQ_THREAD_PRIORITY            As Long = 3
Const ZMQ_THREAD_SCHED_POLICY        As Long = 4
Const ZMQ_MAX_MSGSZ                  As Long = 5
Const ZMQ_MSG_T_SIZE                 As Long = 6
Const ZMQ_THREAD_AFFINITY_CPU_ADD    As Long = 7
Const ZMQ_THREAD_AFFINITY_CPU_REMOVE As Long = 8
Const ZMQ_THREAD_NAME_PREFIX         As Long = 9

' Default for New Contexts
Const ZMQ_IO_THREADS_DFLT          As Long = 1
Const ZMQ_MAX_SOCKETS_DFLT         As Long = 1023
Const ZMQ_THREAD_PRIORITY_DFLT     As Long = -1
Const ZMQ_THREAD_SCHED_POLICY_DFLT As Long = -1

' Message Options
Const ZMQ_MORE   As Long = 1
Const ZMQ_SHARED As Long = 3

' Send/Recv Options
Const ZMQ_DONTWAIT As Long = 1
Const ZMQ_SNDMORE  As Long = 2

' Errors
Const ZMQ_HAUSNUMERO  As Long = 156384712
Const ENOTSUP         As Long = ZMQ_HAUSNUMERO + 1
Const EPROTONOSUPPORT As Long = ZMQ_HAUSNUMERO + 2
Const ENOBUFS         As Long = ZMQ_HAUSNUMERO + 3
Const ENETDOWN        As Long = ZMQ_HAUSNUMERO + 4
Const EADDRINUSE      As Long = ZMQ_HAUSNUMERO + 5
Const EADDRNOTAVAIL   As Long = ZMQ_HAUSNUMERO + 6
Const ECONNREFUSED    As Long = ZMQ_HAUSNUMERO + 7
Const EINPROGRESS     As Long = ZMQ_HAUSNUMERO + 8
Const ENOTSOCK        As Long = ZMQ_HAUSNUMERO + 9
Const EMSGSIZE        As Long = ZMQ_HAUSNUMERO + 10
Const EAFNOSUPPORT    As Long = ZMQ_HAUSNUMERO + 11
Const ENETUNREACH     As Long = ZMQ_HAUSNUMERO + 12
Const ECONNABORTED    As Long = ZMQ_HAUSNUMERO + 13
Const ECONNRESET      As Long = ZMQ_HAUSNUMERO + 14
Const ENOTCONN        As Long = ZMQ_HAUSNUMERO + 15
Const ETIMEDOUT       As Long = ZMQ_HAUSNUMERO + 16
Const EHOSTUNREACH    As Long = ZMQ_HAUSNUMERO + 17
Const ENETRESET       As Long = ZMQ_HAUSNUMERO + 18

' Native Errors
Const EFSM            As Long = ZMQ_HAUSNUMERO + 51
Const ENOCOMPATPROTO  As Long = ZMQ_HAUSNUMERO + 52
Const ETERM           As Long = ZMQ_HAUSNUMERO + 53
Const EMTHREAD        As Long = ZMQ_HAUSNUMERO + 54

' Type
Type ZmqMsgT
    __(0 To 63) As UByte
End Type

' Type Callback Function
Type ZmqThreadFnProc As Sub(Byval thread_ As Any Ptr)
Type ZmqFreeFnProc As Sub(Byval data_ As Any Ptr, Byval hint_ As Any Ptr)