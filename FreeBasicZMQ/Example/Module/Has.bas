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

Dim ZmqRuntimeRec As LibZmqRuntime

If LibZMQWrapper.DllOpen(lpszLibZmqDll) Then
    Dim major As Long = 0
    Dim minor As Long = 0
    Dim patch As Long = 0

    ZmqRuntimeRec.Version(major, minor, patch)
    Print("Zmq Version: " & major & "." & minor & "." & patch)

    Print("Has ipc: " & ZmqRuntimeRec.Has("ipc"))
    Print("Has curve: " & ZmqRuntimeRec.Has("curve"))
    Print("Has draft: " & ZmqRuntimeRec.Has("draft"))

    Dim ZmqContextRec As LibZmqContext
    Dim ZmqSocketRec As LibZmqSocket
    Dim Context As Any Ptr = ZmqContextRec.NewCtx()
    Dim Socket As Any Ptr = ZmqSocketRec.Socket(Context, ZMQ_REP)
    Dim SocketType As Long = 0

    ZmqSocketRec.SetsockoptInt(Socket, ZMQ_LINGER, 0)
    ZmqSocketRec.GetsockoptInt(Socket, ZMQ_TYPE, SocketType)
    Print("Socket Type: " & SocketType)

    ZmqSocketRec.Close(Socket)
    ZmqContextRec.Shutdown(Context)
    LibZMQWrapper.DllClose()
End If

Print("Press any key to continue...")
Sleep()
