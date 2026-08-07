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

Dim Shared Frontend As Any Ptr
Dim Shared Backend As Any Ptr
Dim Shared Control As Any Ptr

Dim Shared ZmqProxyRec As LibZmqProxy

Sub TestZmqProxyProc(Byval vData As Any Ptr)
    Print("Proxy started")
    ZmqProxyRec.Steerable(Frontend, Backend, 0, Control)
    Print("Proxy stopped")
End Sub

Dim ZmqContextRec As LibZmqContext
Dim ZmqSocketRec As LibZmqSocket
Dim ZmqHelperRec As LibZmqHelper

If LibZMQWrapper.DllOpen(lpszLibZmqDll) Then
    Dim Context As Any Ptr = ZmqContextRec.NewCtx()
    Dim ControlPeer As Any Ptr
    Dim threadProxy As Any Ptr
    Dim lpszTerminate As String = "TERMINATE"

    Frontend = ZmqSocketRec.Socket(Context, ZMQ_ROUTER)
    Backend = ZmqSocketRec.Socket(Context, ZMQ_DEALER)
    Control = ZmqSocketRec.Socket(Context, ZMQ_PAIR)
    ControlPeer = ZmqSocketRec.Socket(Context, ZMQ_PAIR)

    ZmqSocketRec.SetsockoptInt(Frontend, ZMQ_LINGER, 0)
    ZmqSocketRec.SetsockoptInt(Backend, ZMQ_LINGER, 0)
    ZmqSocketRec.SetsockoptInt(Control, ZMQ_LINGER, 0)
    ZmqSocketRec.SetsockoptInt(ControlPeer, ZMQ_LINGER, 0)

    ZmqSocketRec.Bind(Frontend, "tcp://*:1710")
    ZmqSocketRec.Bind(Backend, "tcp://*:1711")
    ZmqSocketRec.Bind(Control, "inproc://proxy-control")
    ZmqSocketRec.Connect(ControlPeer, "inproc://proxy-control")

    Print("Frontend: tcp://*:1710")
    Print("Backend: tcp://*:1711")

    threadProxy = ZmqHelperRec.Threadstart(@TestZmqProxyProc, 0)
    Sleep(500)

    ZmqSocketRec.Send(ControlPeer, StrPtr(lpszTerminate), Len(lpszTerminate), 0)
    Sleep(200)
    ZmqHelperRec.Threadclose(threadProxy)

    ZmqSocketRec.Close(ControlPeer)
    ZmqSocketRec.Close(Control)
    ZmqSocketRec.Close(Backend)
    ZmqSocketRec.Close(Frontend)
    ZmqContextRec.Shutdown(Context)
    LibZMQWrapper.DllClose()
End If

Print("Press any key to continue...")
Sleep()
