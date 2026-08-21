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

Function ZmqMsgInit(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.MsgInit > 0) Then
        lResult = g_ZmqApi.MsgInit(msg)
    End If

    Function = lResult
End Function

Function ZmqMsgInitSize(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr, Byval msgsize As UInteger) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.MsgInitSize > 0) Then
        lResult = g_ZmqApi.MsgInitSize(msg, msgsize)
    End If

    Function = lResult
End Function

Function ZmqMsgInitData(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr, Byval msgdata As Any Ptr, Byval msgsize As UInteger, Byval ffn As ZmqFreeFnProc, Byval hint As Any Ptr) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.MsgInitData > 0) Then
        lResult = g_ZmqApi.MsgInitData(msg, msgdata, msgsize, ffn, hint)
    End If

    Function = lResult
End Function

Function ZmqMsgSend(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr, Byval socket As Any Ptr, Byval flags As Long) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.MsgSend > 0) Then
        lResult = g_ZmqApi.MsgSend(msg, socket, flags)
    End If

    Function = lResult
End Function

Function ZmqMsgRecv(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr, Byval socket As Any Ptr, Byval flags As Long) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.MsgRecv > 0) Then
        lResult = g_ZmqApi.MsgRecv(msg, socket, flags)
    End If

    Function = lResult
End Function

Function ZmqMsgClose(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.MsgClose > 0) Then
        lResult = g_ZmqApi.MsgClose(msg)
    End If

    Function = lResult
End Function

Function ZmqMsgMove(Byval dllInstance As Any Ptr, Byref destmsg As ZmqMsgT Ptr, Byref srcmsg As ZmqMsgT Ptr) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.MsgMove > 0) Then
        lResult = g_ZmqApi.MsgMove(destmsg, srcmsg)
    End If

    Function = lResult
End Function

Function ZmqMsgCopy(Byval dllInstance As Any Ptr, Byref destmsg As ZmqMsgT Ptr, Byref srcmsg As ZmqMsgT Ptr) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.MsgCopy > 0) Then
        lResult = g_ZmqApi.MsgCopy(destmsg, srcmsg)
    End If

    Function = lResult
End Function

Function ZmqMsgData(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr) As Any Ptr
    Dim lResult As Any Ptr

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.MsgData > 0) Then
        lResult = g_ZmqApi.MsgData(msg)
    End If

    Function = lResult
End Function

Function ZmqMsgSize(Byval dllInstance As Any Ptr, Byref msg As Const ZmqMsgT Ptr) As UInteger
    Dim lResult As UInteger

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.MsgSize > 0) Then
        lResult = g_ZmqApi.MsgSize(msg)
    End If

    Function = lResult
End Function

Function ZmqMsgMore(Byval dllInstance As Any Ptr, Byref msg As Const ZmqMsgT Ptr) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.MsgMore > 0) Then
        lResult = g_ZmqApi.MsgMore(msg)
    End If

    Function = lResult
End Function

Function ZmqMsgGet(Byval dllInstance As Any Ptr, Byref msg As Const ZmqMsgT Ptr, Byval property_ As Long) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.MsgGet > 0) Then
        lResult = g_ZmqApi.MsgGet(msg, property_)
    End If

    Function = lResult
End Function

Function ZmqMsgSet(Byval dllInstance As Any Ptr, Byref msg As ZmqMsgT Ptr, Byval property_ As Long, Byval optval As Long) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.MsgSet > 0) Then
        lResult = g_ZmqApi.MsgSet(msg, property_, optval)
    End If

    Function = lResult
End Function

Function ZmqMsgGets(Byval dllInstance As Any Ptr, Byref msg As Const ZmqMsgT Ptr, Byval property_ As Const ZString Ptr) As Const ZString Ptr
    Dim lResult As Const ZString Ptr

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.MsgGets > 0) Then
        lResult = g_ZmqApi.MsgGets(msg, property_)
    End If

    Function = lResult
End Function
