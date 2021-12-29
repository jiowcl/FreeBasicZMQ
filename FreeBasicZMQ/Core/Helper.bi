'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Pragma Once

' Declare Function
Declare Function ZmqStopwatchStart(Byval dllInstance As Any Ptr) As Any Ptr
Declare Function ZmqStopwatchIntermediate(Byval dllInstance As Any Ptr, Byval watch_ As Any Ptr) As Culong
Declare Function ZmqStopwatchStop(Byval dllInstance As Any Ptr, Byval watch_ As Any Ptr) As CUlong
Declare Sub ZmqSleep(Byval dllInstance As Any Ptr, Byval seconds_ As Long)
Declare Function ZmqThreadstart(Byval dllInstance As Any Ptr, Byval func_ As ZmqThreadFnProc, Byval arg_ As Any Ptr) As Any Ptr
Declare Sub ZmqThreadclose(Byval dllInstance As Any Ptr, Byval thread_ As Any Ptr)

' Zmq Function Declare

' <summary>
' ZmqStopwatchStart
' </summary>
' <param name="dllInstance"></param>
' <returns>Returns any ptr.</returns>
Function ZmqStopwatchStart(Byval dllInstance As Any Ptr) As Any Ptr
    Dim lResult As Any Ptr
    Dim pFuncCall As Function() As Any Ptr
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_stopwatch_start")

        If (pFuncCall > 0) Then
            lResult = pFuncCall()
        End If
    End If
    
    Function = lResult
End Function

' <summary>
' ZmqStopwatchIntermediate
' </summary>
' <param name="dllInstance"></param>
' <param name="watch_"></param>
' <returns>Returns CUlong.</returns>
Function ZmqStopwatchIntermediate(Byval dllInstance As Any Ptr, Byval watch_ As Any Ptr) As CUlong
    Dim lResult As CUlong
    Dim pFuncCall As Function(Byval watch_ As Any Ptr) As CUlong
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_stopwatch_intermediate")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(watch_)
        End If
    End If
    
    Function = lResult
End Function

' <summary>
' ZmqStopwatchStop
' </summary>
' <param name="dllInstance"></param>
' <param name="watch_"></param>
' <returns>Returns CUlong.</returns>
Function ZmqStopwatchStop(Byval dllInstance As Any Ptr, Byval watch_ As Any Ptr) As CUlong
    Dim lResult As CUlong
    Dim pFuncCall As Function(Byval watch_ As Any Ptr) As CUlong
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_stopwatch_stop")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(watch_)
        End If
    End If
    
    Function = lResult
End Function

' <summary>
' ZmqSleep
' </summary>
' <param name="dllInstance"></param>
' <param name="seconds_"></param>
' <returns>Returns void.</returns>
Sub ZmqSleep(Byval dllInstance As Any Ptr, Byval seconds_ As Long)
    Dim pFuncCall As Function(Byval seconds_ As Long) As CUlong
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_sleep")

        If (pFuncCall > 0) Then
            pFuncCall(seconds_)
        End If
    End If
End Sub

' <summary>
' ZmqThreadstart
' </summary>
' <param name="dllInstance"></param>
' <param name="*func_"></param>
' <param name="arg_"></param>
' <returns>Returns any ptr.</returns>
Function ZmqThreadstart(Byval dllInstance As Any Ptr, Byval func_ As ZmqThreadFnProc, Byval arg_ As Any Ptr) As Any Ptr
    Dim lResult As Any Ptr
    Dim pFuncCall As Function(Byval func_ As ZmqThreadFnProc, Byval arg_ As Any Ptr) As Any Ptr
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_threadstart")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(func_, arg_)
        End If
    End If
    
    Function = lResult
End Function

' <summary>
' ZmqThreadclose
' </summary>
' <param name="dllInstance"></param>
' <param name="thread_"></param>
' <returns>Returns void.</returns>
Sub ZmqThreadclose(Byval dllInstance As Any Ptr, Byval thread_ As Any Ptr)
    Dim pFuncCall As Sub(Byval thread_ As Any Ptr)
    
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_threadclose")

        If (pFuncCall > 0) Then
            pFuncCall(thread_)
        End If
    End If
End Sub