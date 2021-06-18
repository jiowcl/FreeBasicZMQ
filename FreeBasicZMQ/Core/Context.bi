'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

' Declare Function
Declare Function ZmqCtxNew(Byval dllInstance As Any Ptr) As Any Ptr
Declare Function ZmqCtxTerm(Byval dllInstance As Any Ptr, Byval context As Any Ptr) As Long
Declare Function ZmqCtxShutdown(Byval dllInstance As Any Ptr, Byval context As Any Ptr) As Long
Declare Function ZmqCtxSet(Byval dllInstance As Any Ptr, Byval context As Any Ptr, Byval options As Long, Byval optval As Long) As Long
Declare Function ZmqCtxGet(Byval dllInstance As Any Ptr, Byval context As Any Ptr, Byval options As Long) As Long

' Zmq Function Declare

' <summary>
' ZmqCtxNew
' </summary>
' <param name="dllInstance"></param>
' <returns>Returns any ptr.</returns>
Function ZmqCtxNew(Byval dllInstance As Any Ptr) As Any Ptr
    Dim lResult As Any Ptr
    Dim pFuncCall As Function() As Any Ptr

    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_ctx_new")

        If (pFuncCall > 0) Then
            lResult = pFuncCall()
        End If
    End If
  
    Function = lResult
End Function

' <summary>
' ZmqCtxTerm
' </summary>
' <param name="dllInstance"></param>
' <param name="context"></param>
' <returns>Returns long.</returns>
Function ZmqCtxTerm(Byval dllInstance As Any Ptr, Byval context As Any Ptr) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byval context As Any Ptr) As Long
  
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_ctx_term")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(context)
        End If
    End If
  
    Function = lResult
End Function

' <summary>
' ZmqCtxShutdown
' </summary>
' <param name="dllInstance"></param>
' <param name="context"></param>
' <returns>Returns long.</returns>
Function ZmqCtxShutdown(Byval dllInstance As Any Ptr, Byval context As Any Ptr) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byval context As Any Ptr) As Long
  
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_ctx_shutdown")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(context)
        End If
    End If
    
    Function = lResult
End Function

' <summary>
' ZmqCtxSet
' </summary>
' <param name="dllInstance"></param>
' <param name="context"></param>
' <param name="options"></param>
' <param name="optval"></param>
' <returns>Returns long.</returns>
Function ZmqCtxSet(Byval dllInstance As Any Ptr, Byval context As Any Ptr, Byval options As Long, Byval optval As Long) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byval context As Any Ptr, Byval options As Long, Byval optval As Long) As Long
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_ctx_set")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(context, options, optval)
        End If
    End If
    
    Function = lResult
End Function

' <summary>
' ZmqCtxGet
' </summary>
' <param name="dllInstance"></param>
' <param name="context"></param>
' <param name="options"></param>
' <returns>Returns long.</returns>
Function ZmqCtxGet(Byval dllInstance As Any Ptr, Byval context As Any Ptr, Byval options As Long) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byval context As Any Ptr, Byval options As Long) As Long
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_ctx_get")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(context, options)
        End If
    End If
    
    Function = lResult
End Function