'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Include "../../Core/Enums.bi"
#Include "../../Core/ZeroMQWrapper.bi"

Dim lpszCurrentDir As String = Curdir()

' Libzmq version (x86/x64)
#ifdef __FB_64BIT__
    Dim lpszLibZmqDir As String = "/Library/x64"
    Dim lpszLibZmqDll As String = lpszCurrentDir & lpszLibZmqDir & "/libzmq.dll"
  
    Chdir(lpszCurrentDir & lpszLibZmqDir)
#else
    Dim lpszLibZmqDir As String = "/Library/x86"
    Dim lpszLibZmqDll As String = lpszCurrentDir & lpszLibZmqDir & "/libzmq.dll"
  
    Chdir(lpszCurrentDir & lpszLibZmqDir)
#endif

Dim ZmqSecurityRec As LibZmqSecurity
Dim ZmqRuntimeRec As LibZmqRuntime

If LibZMQWrapper.DllOpen(lpszLibZmqDll) Then
    Dim lpszData As ZString * 9 = "TestData"
    Dim lpszDecoded As ZString * 9
    Dim lpszEncoded As String

    lpszEncoded = ZmqSecurityRec.Z85EncodeStr(@lpszData, 8)
    Print("Z85 Encode: " & lpszEncoded)

    If ZmqSecurityRec.Z85DecodeStr(lpszEncoded, @lpszDecoded, 8) > 0 Then
        Print("Z85 Decode: " & Left(lpszDecoded, 8))
    Else
        Print("Z85 Decode failed: " & *ZmqRuntimeRec.Strerror(ZmqRuntimeRec.Errno()))
    End If

    LibZMQWrapper.DllClose()
End If

Print("Press any key to continue...")
Sleep()
