'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Pragma Once

' Function Declare
Declare Function ZmqDllOpen(Byval lpszDllPath As String) As Any Ptr
Declare Function ZmqDllClose(Byval dllInstance As Any Ptr) As Boolean

Declare Function SizeOfDefZStringPtr(Byval varToPtr As ZString Ptr) As Integer
Declare Function SizeOfDefWStringPtr(Byval varToPtr As WString Ptr) As Integer

' <summary>
' ZmqDllOpen
' </summary>
' <param name="lpszDllPath">String</param>
' <returns>Returns any ptr.</returns>
Function ZmqDllOpen(Byval lpszDllPath As String) As Any Ptr
    Dim hLibrary As Any Ptr = DyLibLoad(lpszDllPath)

    If (hLibrary > 0) Then
        ZmqApiBind(hLibrary)
    End If

    Function = hLibrary
End Function

' <summary>
' ZmqDllClose
' </summary>
' <param name="dllInstance">Ptr</param>
' <returns>Returns boolean.</returns>
Function ZmqDllClose(Byval dllInstance As Any Ptr) As Boolean
    If (dllInstance > 0) Then
        If (g_ZmqApi.dllInstance = dllInstance) Then
            ZmqApiClear()
        End If

        DyLibFree(dllInstance)
    End If
  
    Function = True
End Function

' <summary>
' SizeOfDefZStringPtr
' </summary>
' <param name="varToPtr">ZString Ptr</param>
' <returns>Returns integer.</returns>
Function SizeOfDefZStringPtr(Byval varToPtr As ZString Ptr) As Integer
    Function = SizeOf(*Cast(TypeOf(varToPtr), 0))
End Function

' <summary>
' SizeOfDefWStringPtr
' </summary>
' <param name="varToPtr">WString Ptr</param>
' <returns>Returns integer.</returns>
Function SizeOfDefWStringPtr(Byval varToPtr As WString Ptr) As Integer
    Function = SizeOf(*Cast(TypeOf(varToPtr), 0))
End Function
