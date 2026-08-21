'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Pragma Once

Declare Function ZmqStopwatchStart(Byval dllInstance As Any Ptr) As Any Ptr
Declare Function ZmqStopwatchIntermediate(Byval dllInstance As Any Ptr, Byval watch_ As Any Ptr) As Culong
Declare Function ZmqStopwatchStop(Byval dllInstance As Any Ptr, Byval watch_ As Any Ptr) As CUlong
Declare Sub ZmqSleep(Byval dllInstance As Any Ptr, Byval seconds_ As Long)
Declare Function ZmqThreadstart(Byval dllInstance As Any Ptr, Byval func_ As ZmqThreadFnProc, Byval arg_ As Any Ptr) As Any Ptr
Declare Sub ZmqThreadclose(Byval dllInstance As Any Ptr, Byval thread_ As Any Ptr)

Function ZmqStopwatchStart(Byval dllInstance As Any Ptr) As Any Ptr
    Dim lResult As Any Ptr

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.StopwatchStart > 0) Then
        lResult = g_ZmqApi.StopwatchStart()
    End If

    Function = lResult
End Function

Function ZmqStopwatchIntermediate(Byval dllInstance As Any Ptr, Byval watch_ As Any Ptr) As CUlong
    Dim lResult As CUlong

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.StopwatchIntermediate > 0) Then
        lResult = g_ZmqApi.StopwatchIntermediate(watch_)
    End If

    Function = lResult
End Function

Function ZmqStopwatchStop(Byval dllInstance As Any Ptr, Byval watch_ As Any Ptr) As CUlong
    Dim lResult As CUlong

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.StopwatchStop > 0) Then
        lResult = g_ZmqApi.StopwatchStop(watch_)
    End If

    Function = lResult
End Function

Sub ZmqSleep(Byval dllInstance As Any Ptr, Byval seconds_ As Long)
    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.Sleep > 0) Then
        g_ZmqApi.Sleep(seconds_)
    End If
End Sub

Function ZmqThreadstart(Byval dllInstance As Any Ptr, Byval func_ As ZmqThreadFnProc, Byval arg_ As Any Ptr) As Any Ptr
    Dim lResult As Any Ptr

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.Threadstart > 0) Then
        lResult = g_ZmqApi.Threadstart(func_, arg_)
    End If

    Function = lResult
End Function

Sub ZmqThreadclose(Byval dllInstance As Any Ptr, Byval thread_ As Any Ptr)
    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.Threadclose > 0) Then
        g_ZmqApi.Threadclose(thread_)
    End If
End Sub
