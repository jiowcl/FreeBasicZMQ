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

Function ZmqSocket(Byval dllInstance As Any Ptr, Byval s As Any Ptr, Byval stype As Long) As Any Ptr
    Dim lResult As Any Ptr

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.Socket > 0) Then
        lResult = g_ZmqApi.Socket(s, stype)
    End If

    Function = lResult
End Function

Function ZmqSocketMonitor(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval addr As Const ZString Ptr, Byval events As Long) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.SocketMonitor > 0) Then
        lResult = g_ZmqApi.SocketMonitor(socket, addr, events)
    End If

    Function = lResult
End Function

Function ZmqBind(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval addr As Const ZString Ptr) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.Bind > 0) Then
        lResult = g_ZmqApi.Bind(socket, addr)
    End If

    Function = lResult
End Function

Function ZmqUnBind(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval addr As Const ZString Ptr) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.Unbind > 0) Then
        lResult = g_ZmqApi.Unbind(socket, addr)
    End If

    Function = lResult
End Function

Function ZmqRecv(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval buf As Any Ptr, Byval buflen As UInteger, Byval flags As Long) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.Recv > 0) Then
        lResult = g_ZmqApi.Recv(socket, buf, buflen, flags)
    End If

    Function = lResult
End Function

Function ZmqSend(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval buf As Any Ptr, Byval buflen As UInteger, Byval flags As Long) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.Send > 0) Then
        lResult = g_ZmqApi.Send(socket, buf, buflen, flags)
    End If

    Function = lResult
End Function

Function ZmqSendConst(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval buf As Any Ptr, Byval buflen As UInteger, Byval flags As Long) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.SendConst > 0) Then
        lResult = g_ZmqApi.SendConst(socket, buf, buflen, flags)
    End If

    Function = lResult
End Function

Function ZmqConnect(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval addr As Const ZString Ptr) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.Connect > 0) Then
        lResult = g_ZmqApi.Connect(socket, addr)
    End If

    Function = lResult
End Function

Function ZmqDisConnect(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval addr As Const ZString Ptr) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.Disconnect > 0) Then
        lResult = g_ZmqApi.Disconnect(socket, addr)
    End If

    Function = lResult
End Function

Function ZmqSetsockopt(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval options As Long, Byval optval As Any Ptr, Byval optvallen As UInteger) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.Setsockopt > 0) Then
        lResult = g_ZmqApi.Setsockopt(socket, options, optval, optvallen)
    End If

    Function = lResult
End Function

Function ZmqSetsockoptInt(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval options As Long, Byval optval As Long) As Long
    Dim value As Long = optval

    Function = ZmqSetsockopt(dllInstance, socket, options, @value, SizeOf(value))
End Function

Function ZmqGetsockopt(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval options As Long, Byref optval As String, Byval optvallen As UInteger) As Long
    Dim lResult As Long
    Dim vallen As UInteger = optvallen

    If Len(optval) < CInt(optvallen) Then
        optval = Space(optvallen)
    End If

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.Getsockopt > 0) Then
        lResult = g_ZmqApi.Getsockopt(socket, options, StrPtr(optval), @vallen)
    End If

    Function = lResult
End Function

Function ZmqGetsockoptPtr(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval options As Long, Byval optval As Any Ptr, Byref optvallen As UInteger) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.Getsockopt > 0) Then
        lResult = g_ZmqApi.Getsockopt(socket, options, optval, @optvallen)
    End If

    Function = lResult
End Function

Function ZmqGetsockoptInt(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval options As Long, Byref optval As Long) As Long
    Dim value As Long = 0
    Dim optvallen As UInteger = SizeOf(value)
    Dim lResult As Long = ZmqGetsockoptPtr(dllInstance, socket, options, @value, optvallen)

    If (lResult = 0) Then
        optval = value
    End If

    Function = lResult
End Function

Function ZmqClose(Byval dllInstance As Any Ptr, Byval socket As Any Ptr) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.Close > 0) Then
        lResult = g_ZmqApi.Close(socket)
    End If

    Function = lResult
End Function
