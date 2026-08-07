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

Dim Shared hLibrary As Any Ptr
Dim Shared Frontend As Any Ptr
Dim Shared Backend As Any Ptr
Dim Shared Control As Any Ptr

Sub TestZmqProxyProc(Byval vData As Any Ptr)
    Print("Proxy started")
    ZmqProxySteerable(hLibrary, Frontend, Backend, 0, Control)
    Print("Proxy stopped")
End Sub

hLibrary = ZmqDllOpen(lpszLibZmqDll)

If hLibrary > 0 Then
    Dim Context As Any Ptr = ZmqCtxNew(hLibrary)
    Dim ControlPeer As Any Ptr
    Dim threadProxy As Any Ptr
    Dim lpszTerminate As String = "TERMINATE"

    Frontend = ZmqSocket(hLibrary, Context, ZMQ_ROUTER)
    Backend = ZmqSocket(hLibrary, Context, ZMQ_DEALER)
    Control = ZmqSocket(hLibrary, Context, ZMQ_PAIR)
    ControlPeer = ZmqSocket(hLibrary, Context, ZMQ_PAIR)

    ZmqSetsockoptInt(hLibrary, Frontend, ZMQ_LINGER, 0)
    ZmqSetsockoptInt(hLibrary, Backend, ZMQ_LINGER, 0)
    ZmqSetsockoptInt(hLibrary, Control, ZMQ_LINGER, 0)
    ZmqSetsockoptInt(hLibrary, ControlPeer, ZMQ_LINGER, 0)

    ZmqBind(hLibrary, Frontend, "tcp://*:1710")
    ZmqBind(hLibrary, Backend, "tcp://*:1711")
    ZmqBind(hLibrary, Control, "inproc://proxy-control")
    ZmqConnect(hLibrary, ControlPeer, "inproc://proxy-control")

    Print("Frontend: tcp://*:1710")
    Print("Backend: tcp://*:1711")

    threadProxy = ZmqThreadstart(hLibrary, @TestZmqProxyProc, 0)
    Sleep(500)

    ZmqSend(hLibrary, ControlPeer, StrPtr(lpszTerminate), Len(lpszTerminate), 0)
    Sleep(200)
    ZmqThreadclose(hLibrary, threadProxy)

    ZmqClose(hLibrary, ControlPeer)
    ZmqClose(hLibrary, Control)
    ZmqClose(hLibrary, Backend)
    ZmqClose(hLibrary, Frontend)
    ZmqCtxShutdown(hLibrary, Context)
    ZmqDllClose(hLibrary)
End If

Print("Press any key to continue...")
Sleep()
