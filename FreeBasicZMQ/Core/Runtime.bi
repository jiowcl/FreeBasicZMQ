'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Pragma Once

' Declare Function
Declare Function ZmqErrno(Byval dllInstance As Any Ptr) As Long
Declare Function ZmqStrerror(Byval dllInstance As Any Ptr, Byval errnum_ As Integer) As Const ZString Ptr
Declare Sub ZmqVersion(Byval dllInstance As Any Ptr, Byref major As Long, Byref minor As Long, Byref patch As Long)
Declare Function ZmqHas(Byval dllInstance As Any Ptr, Byval capability As Const ZString Ptr) As Long

' Zmq Function Declare

' <summary>
' ZmqErrno
' </summary>
Function ZmqErrno(Byval dllInstance As Any Ptr) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.Errno > 0) Then
        lResult = g_ZmqApi.Errno()
    End If

    Function = lResult
End Function

' <summary>
' ZmqStrerror
' </summary>
Function ZmqStrerror(Byval dllInstance As Any Ptr, Byval errnum_ As Integer) As Const ZString Ptr
    Dim lResult As Const ZString Ptr

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.Strerror > 0) Then
        lResult = g_ZmqApi.Strerror(errnum_)
    End If

    Function = lResult
End Function

' <summary>
' ZmqVersion
' </summary>
Sub ZmqVersion(Byval dllInstance As Any Ptr, Byref major As Long, Byref minor As Long, Byref patch As Long)
    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.Version > 0) Then
        g_ZmqApi.Version(major, minor, patch)
    End If
End Sub

' <summary>
' ZmqHas
' </summary>
Function ZmqHas(Byval dllInstance As Any Ptr, Byval capability As Const ZString Ptr) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.Has > 0) Then
        lResult = g_ZmqApi.Has(capability)
    End If

    Function = lResult
End Function
