'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Pragma Once

#Include Once "Enums.bi"

' Cached libzmq function pointers (resolved once per loaded DLL instance).

Type ZmqApiTable
    dllInstance As Any Ptr

    ' Runtime
    Errno As Function() As Long
    Strerror As Function(Byval errnum_ As Integer) As ZString Ptr
    Version As Sub(Byref major As Long, Byref minor As Long, Byref patch As Long)
    Has As Function(Byval capability As Const ZString Ptr) As Long

    ' Context
    CtxNew As Function() As Any Ptr
    CtxTerm As Function(Byval context As Any Ptr) As Long
    CtxShutdown As Function(Byval context As Any Ptr) As Long
    CtxSet As Function(Byval context As Any Ptr, Byval options As Long, Byval optval As Long) As Long
    CtxGet As Function(Byval context As Any Ptr, Byval options As Long) As Long

    ' Socket
    Socket As Function(Byval s As Any Ptr, Byval stype As Long) As Any Ptr
    SocketMonitor As Function(Byval socket As Any Ptr, Byval addr As Const ZString Ptr, Byval events As Long) As Long
    Bind As Function(Byval socket As Any Ptr, Byval addr As Const ZString Ptr) As Long
    Unbind As Function(Byval socket As Any Ptr, Byval addr As Const ZString Ptr) As Long
    Recv As Function(Byval socket As Any Ptr, Byval buf As Any Ptr, Byval buflen As UInteger, Byval flags As Long) As Long
    Send As Function(Byval socket As Any Ptr, Byval buf As Any Ptr, Byval buflen As UInteger, Byval flags As Long) As Long
    SendConst As Function(Byval socket As Any Ptr, Byval buf As Any Ptr, Byval buflen As UInteger, Byval flags As Long) As Long
    Connect As Function(Byval socket As Any Ptr, Byval addr As Const ZString Ptr) As Long
    Disconnect As Function(Byval socket As Any Ptr, Byval addr As Const ZString Ptr) As Long
    Setsockopt As Function(Byval socket As Any Ptr, Byval options As Long, Byval optval As Any Ptr, Byval optvallen As UInteger) As Long
    Getsockopt As Function(Byval socket As Any Ptr, Byval options As Long, Byval optval As Any Ptr, Byval optvallen As UInteger Ptr) As Long
    Close As Function(Byval socket As Any Ptr) As Long

    ' Msg
    MsgInit As Function(Byref msg As ZmqMsgT Ptr) As Long
    MsgInitSize As Function(Byref msg As ZmqMsgT Ptr, Byval msgsize As UInteger) As Long
    MsgInitData As Function(Byref msg As ZmqMsgT Ptr, Byval msgdata As Any Ptr, Byval msgsize As UInteger, Byval ffn As ZmqFreeFnProc, Byval hint As Any Ptr) As Long
    MsgSend As Function(Byref msg As ZmqMsgT Ptr, Byval socket As Any Ptr, Byval flags As Long) As Long
    MsgRecv As Function(Byref msg As ZmqMsgT Ptr, Byval socket As Any Ptr, Byval flags As Long) As Long
    MsgClose As Function(Byref msg As ZmqMsgT Ptr) As Long
    MsgMove As Function(Byref destmsg As ZmqMsgT Ptr, Byref srcmsg As ZmqMsgT Ptr) As Long
    MsgCopy As Function(Byref destmsg As ZmqMsgT Ptr, Byref srcmsg As ZmqMsgT Ptr) As Long
    MsgData As Function(Byref msg As ZmqMsgT Ptr) As Any Ptr
    MsgSize As Function(Byref msg As Const ZmqMsgT Ptr) As UInteger
    MsgMore As Function(Byref msg As Const ZmqMsgT Ptr) As Long
    MsgGet As Function(Byref msg As Const ZmqMsgT Ptr, Byval property_ As Long) As Long
    MsgSet As Function(Byref msg As ZmqMsgT Ptr, Byval property_ As Long, Byval optval As Long) As Long
    MsgGets As Function(Byref msg As Const ZmqMsgT Ptr, Byval property_ As Const ZString Ptr) As ZString Ptr

    ' Poll / Proxy
    Poll As Function(Byval items As ZmqPollItemT Ptr, Byval nitems As Long, Byval timeout As Clong) As Long
    Proxy As Function(Byval frontend As Any Ptr, Byval backend As Any Ptr, Byval capture As Any Ptr) As Long
    ProxySteerable As Function(Byval frontend As Any Ptr, Byval backend As Any Ptr, Byval capture As Any Ptr, Byval control As Any Ptr) As Long

    ' Security
    Z85Encode As Function(Byval dest As Any Ptr, Byval data_ As Any Ptr, Byval size As UInteger) As Any Ptr
    Z85Decode As Function(Byval dest As Any Ptr, Byval string_ As Const ZString Ptr) As Any Ptr
    CurveKeypair As Function(Byval z85Public As Any Ptr, Byval z85Secret As Any Ptr) As Long
    CurvePublic As Function(Byval z85Public As Any Ptr, Byval z85Secret As Const ZString Ptr) As Long

    ' Helpers
    StopwatchStart As Function() As Any Ptr
    StopwatchIntermediate As Function(Byval watch_ As Any Ptr) As CUlong
    StopwatchStop As Function(Byval watch_ As Any Ptr) As CUlong
    Sleep As Sub(Byval seconds_ As Long)
    Threadstart As Function(Byval func_ As ZmqThreadFnProc, Byval arg_ As Any Ptr) As Any Ptr
    Threadclose As Sub(Byval thread_ As Any Ptr)
End Type

Dim Shared g_ZmqApi As ZmqApiTable

Declare Function ZmqApiBind(Byval dllInstance As Any Ptr) As Boolean
Declare Sub ZmqApiClear()
Declare Function ZmqApiEnsure(Byval dllInstance As Any Ptr) As Boolean

' <summary>
' ZmqApiClear
' </summary>
Sub ZmqApiClear()
    Clear g_ZmqApi, 0, SizeOf(g_ZmqApi)
End Sub

' <summary>
' ZmqApiBind
' </summary>
' <param name="dllInstance">Ptr</param>
' <returns>Returns boolean.</returns>
Function ZmqApiBind(Byval dllInstance As Any Ptr) As Boolean
    If (dllInstance = 0) Then
        Function = False
        Exit Function
    End If

    ZmqApiClear()
    g_ZmqApi.dllInstance = dllInstance

    g_ZmqApi.Errno = DyLibSymbol(dllInstance, "zmq_errno")
    g_ZmqApi.Strerror = DyLibSymbol(dllInstance, "zmq_strerror")
    g_ZmqApi.Version = DyLibSymbol(dllInstance, "zmq_version")
    g_ZmqApi.Has = DyLibSymbol(dllInstance, "zmq_has")

    g_ZmqApi.CtxNew = DyLibSymbol(dllInstance, "zmq_ctx_new")
    g_ZmqApi.CtxTerm = DyLibSymbol(dllInstance, "zmq_ctx_term")
    g_ZmqApi.CtxShutdown = DyLibSymbol(dllInstance, "zmq_ctx_shutdown")
    g_ZmqApi.CtxSet = DyLibSymbol(dllInstance, "zmq_ctx_set")
    g_ZmqApi.CtxGet = DyLibSymbol(dllInstance, "zmq_ctx_get")

    g_ZmqApi.Socket = DyLibSymbol(dllInstance, "zmq_socket")
    g_ZmqApi.SocketMonitor = DyLibSymbol(dllInstance, "zmq_socket_monitor")
    g_ZmqApi.Bind = DyLibSymbol(dllInstance, "zmq_bind")
    g_ZmqApi.Unbind = DyLibSymbol(dllInstance, "zmq_unbind")
    g_ZmqApi.Recv = DyLibSymbol(dllInstance, "zmq_recv")
    g_ZmqApi.Send = DyLibSymbol(dllInstance, "zmq_send")
    g_ZmqApi.SendConst = DyLibSymbol(dllInstance, "zmq_send_const")
    g_ZmqApi.Connect = DyLibSymbol(dllInstance, "zmq_connect")
    g_ZmqApi.Disconnect = DyLibSymbol(dllInstance, "zmq_disconnect")
    g_ZmqApi.Setsockopt = DyLibSymbol(dllInstance, "zmq_setsockopt")
    g_ZmqApi.Getsockopt = DyLibSymbol(dllInstance, "zmq_getsockopt")
    g_ZmqApi.Close = DyLibSymbol(dllInstance, "zmq_close")

    g_ZmqApi.MsgInit = DyLibSymbol(dllInstance, "zmq_msg_init")
    g_ZmqApi.MsgInitSize = DyLibSymbol(dllInstance, "zmq_msg_init_size")
    g_ZmqApi.MsgInitData = DyLibSymbol(dllInstance, "zmq_msg_init_data")
    g_ZmqApi.MsgSend = DyLibSymbol(dllInstance, "zmq_msg_send")
    g_ZmqApi.MsgRecv = DyLibSymbol(dllInstance, "zmq_msg_recv")
    g_ZmqApi.MsgClose = DyLibSymbol(dllInstance, "zmq_msg_close")
    g_ZmqApi.MsgMove = DyLibSymbol(dllInstance, "zmq_msg_move")
    g_ZmqApi.MsgCopy = DyLibSymbol(dllInstance, "zmq_msg_copy")
    g_ZmqApi.MsgData = DyLibSymbol(dllInstance, "zmq_msg_data")
    g_ZmqApi.MsgSize = DyLibSymbol(dllInstance, "zmq_msg_size")
    g_ZmqApi.MsgMore = DyLibSymbol(dllInstance, "zmq_msg_more")
    g_ZmqApi.MsgGet = DyLibSymbol(dllInstance, "zmq_msg_get")
    g_ZmqApi.MsgSet = DyLibSymbol(dllInstance, "zmq_msg_set")
    g_ZmqApi.MsgGets = DyLibSymbol(dllInstance, "zmq_msg_gets")

    g_ZmqApi.Poll = DyLibSymbol(dllInstance, "zmq_poll")
    g_ZmqApi.Proxy = DyLibSymbol(dllInstance, "zmq_proxy")
    g_ZmqApi.ProxySteerable = DyLibSymbol(dllInstance, "zmq_proxy_steerable")

    g_ZmqApi.Z85Encode = DyLibSymbol(dllInstance, "zmq_z85_encode")
    g_ZmqApi.Z85Decode = DyLibSymbol(dllInstance, "zmq_z85_decode")
    g_ZmqApi.CurveKeypair = DyLibSymbol(dllInstance, "zmq_curve_keypair")
    g_ZmqApi.CurvePublic = DyLibSymbol(dllInstance, "zmq_curve_public")

    g_ZmqApi.StopwatchStart = DyLibSymbol(dllInstance, "zmq_stopwatch_start")
    g_ZmqApi.StopwatchIntermediate = DyLibSymbol(dllInstance, "zmq_stopwatch_intermediate")
    g_ZmqApi.StopwatchStop = DyLibSymbol(dllInstance, "zmq_stopwatch_stop")
    g_ZmqApi.Sleep = DyLibSymbol(dllInstance, "zmq_sleep")
    g_ZmqApi.Threadstart = DyLibSymbol(dllInstance, "zmq_threadstart")
    g_ZmqApi.Threadclose = DyLibSymbol(dllInstance, "zmq_threadclose")

    Function = True
End Function

' <summary>
' ZmqApiEnsure
' </summary>
' <param name="dllInstance">Ptr</param>
' <returns>Returns boolean.</returns>
Function ZmqApiEnsure(Byval dllInstance As Any Ptr) As Boolean
    If (dllInstance = 0) Then
        Function = False
        Exit Function
    End If

    If (g_ZmqApi.dllInstance = dllInstance) Then
        Function = True
        Exit Function
    End If

    Function = ZmqApiBind(dllInstance)
End Function
