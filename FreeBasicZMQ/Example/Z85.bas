'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Include "../Core/ZeroMQ.bi"

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

Dim hLibrary As Any Ptr = ZmqDllOpen(lpszLibZmqDll)

If hLibrary > 0 Then
    Dim lpszData As ZString * 9 = "TestData"
    Dim lpszDecoded As ZString * 9
    Dim lpszEncoded As String

    lpszEncoded = ZmqZ85EncodeStr(hLibrary, @lpszData, 8)
    Print("Z85 Encode: " & lpszEncoded)

    If ZmqZ85DecodeStr(hLibrary, lpszEncoded, @lpszDecoded, 8) > 0 Then
        Print("Z85 Decode: " & Left(lpszDecoded, 8))
    Else
        Print("Z85 Decode failed: " & *ZmqStrerror(hLibrary, ZmqErrno(hLibrary)))
    End If

    ZmqDllClose(hLibrary)
End If

Print("Press any key to continue...")
Sleep()
