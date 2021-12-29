'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Pragma Once

' Declare Function
Declare Function ZmqErrno(Byval dllInstance As Any Ptr) As Long
Declare Function ZmqStrerror(Byval dllInstance As Any Ptr, Byval errnum_ As Integer) As Const ZString Ptr
Declare Sub ZmqVersion(Byval dllInstance As Any Ptr, Byref major As Long, Byref minor As Long, Byref patch As Long)

' Zmq Function Declare

' <summary>
' ZmqErrno
' </summary>
' <param name="dllInstance"></param>
' <returns>Returns integer.</returns>
Function ZmqErrno(Byval dllInstance As Any Ptr) As Long
    Dim lResult As Long
    Dim pFuncCall As Function() As Long
  
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_errno")

        If (pFuncCall > 0) Then
            lResult = pFuncCall()
        End If
    End If
  
    Function = lResult
End Function

' <summary>
' ZmqStrerror
' </summary>
' <param name="dllInstance"></param>
' <param name="errnum_"></param>
' <returns>Returns zstring ptr.</returns>
Function ZmqStrerror(Byval dllInstance As Any Ptr, Byval errnum_ As Integer) As Const ZString Ptr
    Dim lResult As Const ZString Ptr
    Dim pFuncCall As Function(Byval errnum_ As Integer) As ZString Ptr
  
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_strerror")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(errnum_)
        End If
    End If
  
    Function = lResult
End Function

' <summary>
' ZmqVersion
' </summary>
' <param name="dllInstance"></param>
' <param name="major"></param>
' <param name="minor"></param>
' <param name="patch"></param>
' <returns>Returns void.</returns>
Sub ZmqVersion(Byval dllInstance As Any Ptr, Byref major As Long, Byref minor As Long, Byref patch As Long)
    Dim pFuncCall As Sub(Byref major As Long, Byref minor As Long, Byref patch As Long)
  
    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_version")
        
        If (pFuncCall > 0) Then
            pFuncCall(major, minor, patch)
        End If
    End If
End Sub