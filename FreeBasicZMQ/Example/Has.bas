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
    Dim major As Long = 0
    Dim minor As Long = 0
    Dim patch As Long = 0

    ZmqVersion(hLibrary, major, minor, patch)
    Print("Zmq Version: " & major & "." & minor & "." & patch)

    Print("Has ipc: " & ZmqHas(hLibrary, "ipc"))
    Print("Has curve: " & ZmqHas(hLibrary, "curve"))
    Print("Has draft: " & ZmqHas(hLibrary, "draft"))

    Dim Context As Any Ptr = ZmqCtxNew(hLibrary)
    Dim Socket As Any Ptr = ZmqSocket(hLibrary, Context, ZMQ_REP)
    Dim SocketType As Long = 0

    ZmqSetsockoptInt(hLibrary, Socket, ZMQ_LINGER, 0)
    ZmqGetsockoptInt(hLibrary, Socket, ZMQ_TYPE, SocketType)
    Print("Socket Type: " & SocketType)

    ZmqClose(hLibrary, Socket)
    ZmqCtxShutdown(hLibrary, Context)
    ZmqDllClose(hLibrary)
End If

Print("Press any key to continue...")
Sleep()
