'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Pragma Once

' Prototype Function
Declare Function ZmqSocket(Byval dllInstance As Any Ptr, Byval s As Any Ptr, Byval stype As Long) As Any Ptr
Declare Function ZmqBind(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval addr As ZString Ptr) As Long
Declare Function ZmqUnBind(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval addr As ZString Ptr) As Long
Declare Function ZmqRecv(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval buf As Any Ptr, Byval buflen As Uinteger, Byval flags As Long) As Long
Declare Function ZmqSend(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval buf As Any Ptr, Byval buflen As Uinteger, Byval flags As Long) As Long
Declare Function ZmqSendConst(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval buf As Any Ptr, Byval buflen As Uinteger, Byval flags As Long) As Long
Declare Function ZmqConnect(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval addr As ZString Ptr) As Long
Declare Function ZmqDisConnect(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval addr As ZString Ptr) As Long
Declare Function ZmqSetsockopt(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval options As Long, Byval optval As Any Ptr, Byval optvallen As Uinteger) As Long
Declare Function ZmqGetsockopt(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval options As Long, Byref optval As String, Byval optvallen As Uinteger) As Long
Declare Function ZmqClose(Byval dllInstance As Any Ptr, Byval socket As Any Ptr) As Long

' Zmq Function Declare

' <summary>
' ZmqSocket
' </summary>
' <param name="dllInstance"></param>
' <param name="s"></param>
' <param name="stype"></param>
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
' ZmqBind
' </summary>
' <param name="dllInstance"></param>
' <param name="socket"></param>
' <param name="addr"></param>
' <returns>Returns long.</returns>
Function ZmqBind(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval addr As ZString Ptr) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byval socket As Any Ptr, Byval addr As ZString Ptr) As Long
    
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
' <param name="dllInstance"></param>
' <param name="socket"></param>
' <param name="addr"></param>
' <returns>Returns long.</returns>
Function ZmqUnBind(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval addr As ZString Ptr) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byval socket As Any Ptr, Byval addr As ZString Ptr) As Long
    
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
' <param name="dllInstance"></param>
' <param name="socket"></param>
' <param name="buf"></param>
' <param name="buflen"></param>
' <param name="flags"></param>
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
' <param name="dllInstance"></param>
' <param name="socket"></param>
' <param name="buf"></param>
' <param name="buflen"></param>
' <param name="flags"></param>
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
' <param name="dllInstance"></param>
' <param name="socket"></param>
' <param name="buf"></param>
' <param name="buflen"></param>
' <param name="flags"></param>
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
' <param name="dllInstance"></param>
' <param name="socket"></param>
' <param name="addr"></param>
' <returns>Returns long.</returns>
Function ZmqConnect(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval addr As ZString Ptr) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byval socket As Any Ptr, Byval addr As ZString Ptr) As Long
    
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
' <param name="dllInstance"></param>
' <param name="socket"></param>
' <param name="addr"></param>
' <returns>Returns long.</returns>
Function ZmqDisConnect(Byval dllInstance As Any Ptr, Byval socket As Any Ptr, Byval addr As ZString Ptr) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byval socket As Any Ptr, Byval addr As ZString Ptr) As Long
    
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
' <param name="dllInstance"></param>
' <param name="socket"></param>
' <param name="options"></param>
' <param name="optval"></param>
' <param name="optvallen"></param>
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
' ZmqGetsockopt
' </summary>
' <param name="dllInstance"></param>
' <param name="socket"></param>
' <param name="options"></param>
' <param name="optval"></param>
' <param name="optvallen"></param>
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
' ZmqClose
' </summary>
' <param name="dllInstance"></param>
' <param name="socket"></param>
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