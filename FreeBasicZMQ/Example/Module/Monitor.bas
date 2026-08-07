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

Const lpszServerAddr As String = "tcp://*:1714"
Const lpszServerClientAddr As String = "tcp://127.0.0.1:1714"
Const lpszMonitorAddr As String = "inproc://monitor.rep"

Dim Shared ZmqSocketRec As LibZmqSocket
Dim Shared ZmqPollRec As LibZmqPoll

' Rep Server
Sub TestZmqThreadRepProc(Byval vData As Any Ptr)
    Dim Socket As Any Ptr = vData
    Dim i As Long

    Print("Bind an IP address: " & lpszServerAddr)

    For i = 1 To 5
        Dim lpszBuffer As ZString * 32
        Dim lpszMessage As String = "Hi "

        ZmqSocketRec.Recv(Socket, @lpszBuffer, SizeOf(lpszBuffer), 0)
        Sleep(10)
        Print("Received: " & lpszBuffer)
        ZmqSocketRec.Send(Socket, StrPtr(lpszMessage), Len(lpszMessage), 0)
    Next
End Sub

' Rep Server Monitor
Sub TestZmqThreadRepMonitorProc(Byval vData As Any Ptr)
    Dim Socket As Any Ptr = vData
    Dim items As ZmqPollItemT
    Dim i As Long

    Print("Monitor listening: " & lpszMonitorAddr)

    For i = 1 To 10
        Dim eventBuf As UByte Ptr
        Dim eventId As UShort
        Dim eventValue As Long
        Dim address As ZString * 256
        Dim Rc As Long
        Dim n As Long

        items.socket = Socket
        items.fd = 0
        items.events = ZMQ_POLLIN
        items.revents = 0

        Rc = ZmqPollRec.Poll(@items, 1, 500)
        If Rc <= 0 Then
            Continue For
        End If

        eventBuf = CAllocate(6)
        n = ZmqSocketRec.Recv(Socket, eventBuf, 6, ZMQ_DONTWAIT)
        If n < 6 Then
            Deallocate(eventBuf)
            Continue For
        End If

        eventId = Peek(UShort, eventBuf)
        eventValue = Peek(Long, eventBuf + 2)
        Deallocate(eventBuf)

        ZmqSocketRec.Recv(Socket, @address, SizeOf(address), ZMQ_DONTWAIT)

        Select Case eventId
            Case ZMQ_EVENT_ACCEPTED
                Print("Event ZMQ_EVENT_ACCEPTED value=" & eventValue & " addr=" & address)
            Case ZMQ_EVENT_CLOSED
                Print("Event ZMQ_EVENT_CLOSED value=" & eventValue & " addr=" & address)
            Case Else
                Print("Event id=" & eventId & " value=" & eventValue & " addr=" & address)
        End Select
    Next
End Sub

' Req Client
Sub TestZmqThreadReqProc(Byval vData As Any Ptr)
    Dim Socket As Any Ptr = vData
    Dim i As Long

    Print("Connect to Server: " & lpszServerClientAddr)

    For i = 1 To 5
        Dim lpszBuffer As ZString * 32
        Dim lpszMessage As String = "From Client"

        ZmqSocketRec.Send(Socket, StrPtr(lpszMessage), Len(lpszMessage), 0)
        Sleep(100)
        ZmqSocketRec.Recv(Socket, @lpszBuffer, SizeOf(lpszBuffer), 0)
        Print("Reply From Server: " & lpszBuffer)
    Next
End Sub

Dim ZmqContextRec As LibZmqContext
Dim ZmqHelperRec As LibZmqHelper

If LibZMQWrapper.DllOpen(lpszLibZmqDll) Then
    Dim ContextRep As Any Ptr = ZmqContextRec.NewCtx()
    Dim SocketRep As Any Ptr = ZmqSocketRec.Socket(ContextRep, ZMQ_REP)
    Dim SocketMonitor As Any Ptr
    Dim ContextReq As Any Ptr
    Dim SocketReq As Any Ptr
    Dim threadMonitor As Any Ptr
    Dim threadRep As Any Ptr
    Dim threadReq As Any Ptr

    ZmqSocketRec.SetsockoptInt(SocketRep, ZMQ_LINGER, 0)
    ZmqSocketRec.SocketMonitor(SocketRep, lpszMonitorAddr, ZMQ_EVENT_ACCEPTED Or ZMQ_EVENT_CLOSED)
    ZmqSocketRec.Bind(SocketRep, lpszServerAddr)

    SocketMonitor = ZmqSocketRec.Socket(ContextRep, ZMQ_PAIR)
    ZmqSocketRec.SetsockoptInt(SocketMonitor, ZMQ_LINGER, 0)
    ZmqSocketRec.Connect(SocketMonitor, lpszMonitorAddr)
    threadMonitor = ZmqHelperRec.Threadstart(@TestZmqThreadRepMonitorProc, SocketMonitor)

    ContextReq = ZmqContextRec.NewCtx()
    SocketReq = ZmqSocketRec.Socket(ContextReq, ZMQ_REQ)
    ZmqSocketRec.SetsockoptInt(SocketReq, ZMQ_LINGER, 0)
    ZmqSocketRec.Connect(SocketReq, lpszServerClientAddr)

    threadRep = ZmqHelperRec.Threadstart(@TestZmqThreadRepProc, SocketRep)
    threadReq = ZmqHelperRec.Threadstart(@TestZmqThreadReqProc, SocketReq)

    Sleep(3000)

    ZmqHelperRec.Threadclose(threadMonitor)
    ZmqHelperRec.Threadclose(threadRep)
    ZmqHelperRec.Threadclose(threadReq)

    ZmqSocketRec.Close(SocketMonitor)
    ZmqSocketRec.Close(SocketRep)
    ZmqContextRec.Shutdown(ContextRep)
    ZmqSocketRec.Close(SocketReq)
    ZmqContextRec.Shutdown(ContextReq)
    LibZMQWrapper.DllClose()
End If

Print("Press any key to continue...")
Sleep()
