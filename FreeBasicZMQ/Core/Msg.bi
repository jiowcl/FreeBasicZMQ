'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Pragma Once

' Prototype Function
Declare Function ZmqMsgInit(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr) As Long
Declare Function ZmqMsgInitSize(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr, Byval msgsize As UInteger) As Long
Declare Function ZmqMsgInitData(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr, Byval msgdata As Any Ptr, Byval msgsize As UInteger, Byval ffn As ZmqFreeFnProc, Byval hint As Any Ptr) As Long
Declare Function ZmqMsgSend(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr, Byval socket As Any Ptr, Byval flags As Long) As Long
Declare Function ZmqMsgRecv(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr, Byval socket As Any Ptr, Byval flags As Long) As Long
Declare Function ZmqMsgClose(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr) As Long
Declare Function ZmqMsgMove(Byval dllInstance As Any Ptr, Byref destmsg As ZmqMsgT Ptr, Byref srcmsg As ZmqMsgT Ptr) As Long
Declare Function ZmqMsgCopy(Byval dllInstance As Any Ptr, Byref destmsg As ZmqMsgT Ptr, Byref srcmsg As ZmqMsgT Ptr) As Long
Declare Function ZmqMsgData(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr) As Any Ptr
Declare Function ZmqMsgSize(Byval dllInstance As Any Ptr, Byref msg As Const ZmqMsgT Ptr) As UInteger
Declare Function ZmqMsgMore(Byval dllInstance As Any Ptr, Byref msg As Const ZmqMsgT Ptr) As Long
Declare Function ZmqMsgGet(Byval dllInstance As Any Ptr, Byref msg As Const ZmqMsgT Ptr, Byval property_ As Long) As Long
Declare Function ZmqMsgSet(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr, Byval property_ As Long, Byval optval As Long) As Long
Declare Function ZmqMsgGets(Byval dllInstance As Any Ptr, Byref msg As Const ZmqMsgT Ptr, Byval property_ As Const ZString Ptr) As Const ZString Ptr

' Zmq Function Declare

' <summary>
' ZmqMsgInit
' </summary>
' <param name="dllInstance"></param>
' <param name="msg"></param>
' <returns>Returns long.</returns>
Function ZmqMsgInit(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byref msg As ZmqMsgT Ptr) As Long
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_msg_init")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(msg)
        End If
    End If
      
    Function = lResult
End Function

' <summary>
' ZmqMsgInitSize
' </summary>
' <param name="dllInstance"></param>
' <param name="msg"></param>
' <param name="msgsize"></param>
' <returns>Returns long.</returns>
Function ZmqMsgInitSize(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr, Byval msgsize As UInteger) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byref msg As ZmqMsgT Ptr, Byval msgsize As UInteger) As Long
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_msg_init_size")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(msg, msgsize)
        End If
    End If
      
    Function = lResult
End Function

' <summary>
' ZmqMsgInitData
' </summary>
' <param name="dllInstance"></param>
' <param name="msg"></param>
' <param name="msgdata"></param>
' <param name="msgsize"></param>
' <param name="ffn"></param>
' <param name="hint"></param>
' <returns>Returns long.</returns>
Function ZmqMsgInitData(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr, Byval msgdata As Any Ptr, Byval msgsize As UInteger, Byval ffn As ZmqFreeFnProc, Byval hint As Any Ptr) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byref msg As ZmqMsgT Ptr, Byval msgdata As Any Ptr, Byval msgsize As UInteger, Byval ffn As ZmqFreeFnProc, Byval hint As Any Ptr) As Long
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_msg_init_data")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(msg, msgdata, msgsize, ffn, hint)
        End If
    End If
      
    Function = lResult
End Function

' <summary>
' ZmqMsgSend
' </summary>
' <param name="dllInstance"></param>
' <param name="msg"></param>
' <param name="socket"></param>
' <param name="flags"></param>
' <returns>Returns long.</returns>
Function ZmqMsgSend(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr, Byval socket As Any Ptr, Byval flags As Long) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byref msg As ZmqMsgT Ptr, Byval socket As Any Ptr, Byval flags As Long) As Long
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_msg_send")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(msg, socket, flags)
        End If
    End If
      
    Function = lResult
End Function

' <summary>
' ZmqMsgRecv
' </summary>
' <param name="dllInstance"></param>
' <param name="msg"></param>
' <param name="socket"></param>
' <param name="flags"></param>
' <returns>Returns long.</returns>
Function ZmqMsgRecv(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr, Byval socket As Any Ptr, Byval flags As Long) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byref msg As ZmqMsgT Ptr, Byval socket As Any Ptr, Byval flags As Long) As Long
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_msg_recv")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(msg, socket, flags)
        End If
    End If
      
    Function = lResult
End Function

' <summary>
' ZmqMsgClose
' </summary>
' <param name="dllInstance"></param>
' <param name="msg"></param>
' <returns>Returns long.</returns>
Function ZmqMsgClose(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byref msg As ZmqMsgT Ptr) As Long
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_msg_close")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(msg)
        End If
    End If
      
    Function = lResult
End Function

' <summary>
' ZmqMsgMove
' </summary>
' <param name="dllInstance"></param>
' <param name="destmsg"></param>
' <param name="srcmsg"></param>
' <returns>Returns long.</returns>
Function ZmqMsgMove(Byval dllInstance As Any Ptr, Byref destmsg As ZmqMsgT Ptr, Byref srcmsg As ZmqMsgT Ptr) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byref destmsg As ZmqMsgT Ptr, Byref srcmsg As ZmqMsgT Ptr) As Long
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_msg_move")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(destmsg, srcmsg)
        End If
    End If
      
    Function = lResult
End Function

' <summary>
' ZmqMsgCopy
' </summary>
' <param name="dllInstance"></param>
' <param name="destmsg"></param>
' <param name="srcmsg"></param>
' <returns>Returns long.</returns>
Function ZmqMsgCopy(Byval dllInstance As Any Ptr, Byref destmsg As ZmqMsgT Ptr, Byref srcmsg As ZmqMsgT Ptr) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byref destmsg As ZmqMsgT Ptr, Byref srcmsg As ZmqMsgT Ptr) As Long
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_msg_copy")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(destmsg, srcmsg)
        End If
    End If
      
    Function = lResult
End Function

' <summary>
' ZmqMsgData
' </summary>
' <param name="dllInstance"></param>
' <param name="msg"></param>
' <returns>Returns any ptr.</returns>
Function ZmqMsgData(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr) As Any Ptr
    Dim lResult As Any Ptr
    Dim pFuncCall As Function(Byref msg As ZmqMsgT Ptr) As Any Ptr
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_msg_data")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(msg)
        End If
    End If
      
    Function = lResult
End Function

' <summary>
' ZmqMsgSize
' </summary>
' <param name="dllInstance"></param>
' <param name="msg"></param>
' <returns>Returns uinteger.</returns>
Function ZmqMsgSize(Byval dllInstance As Any Ptr, Byref msg As Const ZmqMsgT Ptr) As UInteger
    Dim lResult As UInteger
    Dim pFuncCall As Function(Byref msg As Const ZmqMsgT Ptr) As UInteger
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_msg_size")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(msg)
        End If
    End If
      
    Function = lResult
End Function

' <summary>
' ZmqMsgMore
' </summary>
' <param name="dllInstance"></param>
' <param name="msg"></param>
' <returns>Returns long.</returns>
Function ZmqMsgMore(Byval dllInstance As Any Ptr, Byref msg As Const ZmqMsgT Ptr) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byref msg As Const ZmqMsgT Ptr) As Long
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_msg_more")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(msg)
        End If
    End If
      
    Function = lResult
End Function

' <summary>
' ZmqMsgGet
' </summary>
' <param name="dllInstance"></param>
' <param name="msg"></param>
' <param name="property_"></param>
' <returns>Returns long.</returns>
Function ZmqMsgGet(Byval dllInstance As Any Ptr, Byref msg As Const ZmqMsgT Ptr, Byval property_ As Long) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byref msg As Const ZmqMsgT Ptr, Byval property_ As Long) As Long
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_msg_get")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(msg, property_)
        End If
    End If
      
    Function = lResult
End Function

' <summary>
' ZmqMsgSet
' </summary>
' <param name="dllInstance"></param>
' <param name="msg"></param>
' <param name="property_"></param>
' <param name="optval"></param>
' <returns>Returns long.</returns>
Function ZmqMsgSet(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr, Byval property_ As Long, Byval optval As Long) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byref msg As ZmqMsgT Ptr, Byval property_ As Long, Byval optval As Long) As Long
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_msg_set")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(msg, property_, optval)
        End If
    End If
      
    Function = lResult
End Function

' <summary>
' ZmqMsgGets
' </summary>
' <param name="dllInstance"></param>
' <param name="msg"></param>
' <param name="property_"></param>
' <returns>Returns const zstring ptr.</returns>
Function ZmqMsgGets(Byval dllInstance As Any Ptr, Byref msg As Const ZmqMsgT Ptr, Byval property_ As Const ZString Ptr) As Const ZString Ptr
    Dim lResult As Const ZString Ptr
    Dim pFuncCall As Function(Byref msg As Const ZmqMsgT Ptr, Byval property_ As Const ZString Ptr) As Const ZString Ptr
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_msg_gets")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(msg, property_)
        End If
    End If
      
    Function = lResult
End Function