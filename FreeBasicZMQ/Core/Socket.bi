'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Pragma Once

' Prototype Function
Declare Function ZmqSocket(Byval dllInstance As Any Ptr, Byval s As Any Ptr, Byval stype As Long) As Any Ptr
Declare Function ZmqSocketMonitor(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval addr As Const ZString Ptr, Byval events As Long) As Long
Declare Function ZmqBind(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval addr As Const ZString Ptr) As Long
Declare Function ZmqUnBind(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval addr As Const ZString Ptr) As Long
Declare Function ZmqRecv(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval buf As Any Ptr, Byval buflen As UInteger, Byval flags As Long) As Long
Declare Function ZmqSend(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval buf As Any Ptr, Byval buflen As UInteger, Byval flags As Long) As Long
Declare Function ZmqSendConst(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval buf As Any Ptr, Byval buflen As UInteger, Byval flags As Long) As Long
Declare Function ZmqConnect(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval addr As Const ZString Ptr) As Long
Declare Function ZmqDisConnect(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval addr As Const ZString Ptr) As Long
Declare Function ZmqSetsockopt(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval options As Long, Byval optval As Any Ptr, Byval optvallen As UInteger) As Long
Declare Function ZmqSetsockoptInt(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval options As Long, Byval optval As Long) As Long
Declare Function ZmqGetsockopt(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval options As Long, Byref optval As String, Byval optvallen As UInteger) As Long
Declare Function ZmqGetsockoptPtr(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval options As Long, Byval optval As Any Ptr, Byref optvallen As UInteger) As Long
Declare Function ZmqGetsockoptInt(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval options As Long, Byref optval As Long) As Long
Declare Function ZmqClose(Byval dllInstance As Any Ptr, Byval socket As Any Ptr) As Long

' Zmq Function Declare

' <summary>
' ZmqSocket
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="s">Ptr</param>
' <param name="stype">Long</param>
' <returns>Returns any ptr.</returns>
Function ZmqSocket(Byval dllInstance As Any Ptr, Byval s As Any Ptr, Byval stype As Long) As Any Ptr
    Dim lResult As Any Ptr
    Dim pFuncCall As Function(Byval s As Any Ptr, Byval type As Long) As Any Ptr
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_socket")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(s, stype)
        End If
    End If
      
    Function = lResult
End Function

' <summary>
' ZmqSocketMonitor
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="socket">Ptr</param>
' <param name="addr">Const ZString Ptr</param>
' <param name="events">Long</param>
' <returns>Returns long.</returns>
Function ZmqSocketMonitor(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval addr As Const ZString Ptr, Byval events As Long) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byval socket As Any Ptr, Byval addr As Const ZString Ptr, Byval events As Long) As Long

    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_socket_monitor")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(socket, addr, events)
        End If
    End If

    Function = lResult
End Function

' <summary>
' ZmqBind
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="socket">Ptr</param>
' <param name="addr">Const ZString Ptr</param>
' <returns>Returns long.</returns>
Function ZmqBind(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval addr As Const ZString Ptr) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byval socket As Any Ptr, Byval addr As Const ZString Ptr) As Long
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_bind")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(socket, addr)
        End If
    End If
    
    Function = lResult
End Function

' <summary>
' ZmqUnBind
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="socket">Ptr</param>
' <param name="addr">Const ZString Ptr</param>
' <returns>Returns long.</returns>
Function ZmqUnBind(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval addr As Const ZString Ptr) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byval socket As Any Ptr, Byval addr As Const ZString Ptr) As Long
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_unbind")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(socket, addr)
        End If
    End If
    
    Function = lResult
End Function

' <summary>
' ZmqRecv
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="socket">Ptr</param>
' <param name="buf">Ptr</param>
' <param name="buflen">Uinteger</param>
' <param name="flags">Long</param>
' <returns>Returns long.</returns>
Function ZmqRecv(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval buf As Any Ptr, Byval buflen As Uinteger, Byval flags As Long) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byval socket As Any Ptr, Byval buf As Any Ptr, Byval buflen As Uinteger, Byval flags As Long) As Long
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_recv")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(socket, buf, buflen, flags)
        End If
    End If
    
    Function = lResult
End Function

' <summary>
' ZmqSend
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="socket">Ptr</param>
' <param name="buf">Ptr</param>
' <param name="buflen">Uinteger</param>
' <param name="flags">Long</param>
' <returns>Returns long.</returns>
Function ZmqSend(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval buf As Any Ptr, Byval buflen As Uinteger, Byval flags As Long) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byval socket As Any Ptr, Byval buf As Any Ptr, Byval buflen As Uinteger, Byval flags As Long) As Long
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_send")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(socket, buf, buflen, flags)
        End If
    End If
    
    Function = lResult
End Function

' <summary>
' ZmqSendConst
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="socket">Ptr</param>
' <param name="buf">Ptr</param>
' <param name="buflen">Uinteger</param>
' <param name="flags">Long</param>
' <returns>Returns long.</returns>
Function ZmqSendConst(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval buf As Any Ptr, Byval buflen As Uinteger, Byval flags As Long) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byval socket As Any Ptr, Byval buf As Any Ptr, Byval buflen As Uinteger, Byval flags As Long) As Long
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_send_const")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(socket, buf, buflen, flags)
        End If
    End If
    
    Function = lResult
End Function

' <summary>
' ZmqConnect
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="socket">Ptr</param>
' <param name="addr">Const ZString Ptr</param>
' <returns>Returns long.</returns>
Function ZmqConnect(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval addr As Const ZString Ptr) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byval socket As Any Ptr, Byval addr As Const ZString Ptr) As Long
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_connect")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(socket, addr)
        End If
    End If
    
    Function = lResult
End Function

' <summary>
' ZmqDisConnect
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="socket">Ptr</param>
' <param name="addr">Const ZString Ptr</param>
' <returns>Returns long.</returns>
Function ZmqDisConnect(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval addr As Const ZString Ptr) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byval socket As Any Ptr, Byval addr As Const ZString Ptr) As Long
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_disconnect")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(socket, addr)
        End If
    End If
    
    Function = lResult
End Function

' <summary>
' ZmqSetsockopt
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="socket">Ptr</param>
' <param name="options">Long</param>
' <param name="optval">Ptr</param>
' <param name="optvallen">Uinteger</param>
' <returns>Returns long.</returns>
Function ZmqSetsockopt(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval options As Long, Byval optval As Any Ptr, Byval optvallen As Uinteger) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byval socket As Any Ptr, Byval options As Long, Byval optval As Any Ptr, Byval optvallen As Uinteger) As Long
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_setsockopt")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(socket, options, optval, optvallen)
        End If
    End If  
    
    Function = lResult
End Function

' <summary>
' ZmqSetsockoptInt
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="socket">Ptr</param>
' <param name="options">Long</param>
' <param name="optval">Long</param>
' <returns>Returns long.</returns>
Function ZmqSetsockoptInt(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval options As Long, Byval optval As Long) As Long
    Dim value As Long = optval

    Function = ZmqSetsockopt(dllInstance, socket, options, @value, SizeOf(value))
End Function

' <summary>
' ZmqGetsockopt
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="socket">Ptr</param>
' <param name="options">Long</param>
' <param name="optval">String</param>
' <param name="optvallen">Uinteger</param>
' <returns>Returns long.</returns>
Function ZmqGetsockopt(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval options As Long, Byref optval As String, Byval optvallen As Uinteger) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byval socket As Any Ptr, Byval options As Long, Byref optval As String, Byval optvallen As Uinteger) As Long
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_getsockopt")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(socket, options, optval, optvallen)
        End If
    End If  
    
    Function = lResult
End Function

' <summary>
' ZmqGetsockoptPtr
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="socket">Ptr</param>
' <param name="options">Long</param>
' <param name="optval">Ptr</param>
' <param name="optvallen">UInteger</param>
' <returns>Returns long.</returns>
Function ZmqGetsockoptPtr(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval options As Long, Byval optval As Any Ptr, Byref optvallen As UInteger) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byval socket As Any Ptr, Byval options As Long, Byval optval As Any Ptr, Byval optvallen As UInteger Ptr) As Long

    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_getsockopt")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(socket, options, optval, @optvallen)
        End If
    End If

    Function = lResult
End Function

' <summary>
' ZmqGetsockoptInt
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="socket">Ptr</param>
' <param name="options">Long</param>
' <param name="optval">Long</param>
' <returns>Returns long.</returns>
Function ZmqGetsockoptInt(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval options As Long, Byref optval As Long) As Long
    Dim value As Long = 0
    Dim optvallen As UInteger = SizeOf(value)
    Dim lResult As Long = ZmqGetsockoptPtr(dllInstance, socket, options, @value, optvallen)

    If (lResult = 0) Then
        optval = value
    End If

    Function = lResult
End Function

' <summary>
' ZmqClose
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="socket">Ptr</param>
' <returns>Returns long.</returns>
Function ZmqClose(Byval dllInstance As Any Ptr, Byval socket As Any Ptr) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byval socket As Any Ptr) As Long
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_close")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(socket)
        End If
    End If
    
    Function = lResult
End Function