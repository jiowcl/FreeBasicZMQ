'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Pragma Once

' Declare Function
Declare Function ZmqCtxNew(Byval dllInstance As Any Ptr) As Any Ptr
Declare Function ZmqCtxTerm(Byval dllInstance As Any Ptr, Byval context As Any Ptr) As Long
Declare Function ZmqCtxShutdown(Byval dllInstance As Any Ptr, Byval context As Any Ptr) As Long
Declare Function ZmqCtxSet(Byval dllInstance As Any Ptr, Byval context As Any Ptr, Byval options As Long, Byval optval As Long) As Long
Declare Function ZmqCtxGet(Byval dllInstance As Any Ptr, Byval context As Any Ptr, Byval options As Long) As Long

' Zmq Function Declare

Function ZmqCtxNew(Byval dllInstance As Any Ptr) As Any Ptr
    Dim lResult As Any Ptr

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.CtxNew > 0) Then
        lResult = g_ZmqApi.CtxNew()
    End If

    Function = lResult
End Function

Function ZmqCtxTerm(Byval dllInstance As Any Ptr, Byval context As Any Ptr) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.CtxTerm > 0) Then
        lResult = g_ZmqApi.CtxTerm(context)
    End If

    Function = lResult
End Function

Function ZmqCtxShutdown(Byval dllInstance As Any Ptr, Byval context As Any Ptr) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.CtxShutdown > 0) Then
        lResult = g_ZmqApi.CtxShutdown(context)
    End If

    Function = lResult
End Function

Function ZmqCtxSet(Byval dllInstance As Any Ptr, Byval context As Any Ptr, Byval options As Long, Byval optval As Long) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.CtxSet > 0) Then
        lResult = g_ZmqApi.CtxSet(context, options, optval)
    End If

    Function = lResult
End Function

Function ZmqCtxGet(Byval dllInstance As Any Ptr, Byval context As Any Ptr, Byval options As Long) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.CtxGet > 0) Then
        lResult = g_ZmqApi.CtxGet(context, options)
    End If

    Function = lResult
End Function
