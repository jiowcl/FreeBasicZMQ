'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

' Function Declare
Declare Function ZmqDllOpen(Byval lpszDllPath As String) As Any Ptr
Declare Function ZmqDllClose(Byval dllInstance As Any Ptr) As Boolean

Declare Function SizeOfDefZStringPtr(Byval varToPtr As ZString Ptr) As Integer
Declare Function SizeOfDefWStringPtr(Byval varToPtr As WString Ptr) As Integer

' <summary>
' ZmqDllOpen
' </summary>
' <param name="lpszDllPath"></param>
' <returns>Returns any pty.</returns>
Function ZmqDllOpen(Byval lpszDllPath As String) As Any Ptr
    Function = DyLibLoad(lpszDllPath)
End Function

' <summary>
' ZmqDllClose
' </summary>
' <param name="dllInstance"></param>
' <returns>Returns boolean.</returns>
Function ZmqDllClose(Byval dllInstance As Any Ptr) As Boolean
    If (dllInstance > 0) Then
        DyLibFree(dllInstance)
    End If
  
    Function = True
End Function

' <summary>
' SizeOfDefZStringPtr
' </summary>
' <param name="varToPtr"></param>
' <returns>Returns integer.</returns>
Function SizeOfDefZStringPtr(Byval varToPtr As ZString Ptr) As Integer
    Function = SizeOf(*Cast(TypeOf(varToPtr), 0))
End Function

' <summary>
' SizeOfDefWStringPtr
' </summary>
' <param name="varToPtr"></param>
' <returns>Returns integer.</returns>
Function SizeOfDefWStringPtr(Byval varToPtr As WString Ptr) As Integer
    Function = SizeOf(*Cast(TypeOf(varToPtr), 0))
End Function