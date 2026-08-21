'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Include "../../Core/Enums.bi"
#Include "../../Core/ZeroMQWrapper.bi"

Dim lpszCurrentDir As String = Curdir()

#ifdef __FB_64BIT__
    Dim lpszLibZmqDir As String = "/Library/x64"
    Dim lpszLibZmqDll As String = lpszCurrentDir & lpszLibZmqDir & "/libzmq.dll"
    Chdir(lpszCurrentDir & lpszLibZmqDir)
#else
    Dim lpszLibZmqDir As String = "/Library/x86"
    Dim lpszLibZmqDll As String = lpszCurrentDir & lpszLibZmqDir & "/libzmq.dll"
    Chdir(lpszCurrentDir & lpszLibZmqDir)
#endif

Const lpszClientAddr As String = "tcp://127.0.0.1:1720"
Const lpszZapDomain As String = "plain"
Const lpszUsername As String = "admin"
Const lpszPassword As String = "secret"

Dim Shared ZmqSocketRec As LibZmqSocket
Dim Shared ZapRunning As Long = 1
Dim Shared RepDone As Long = 0
Dim Shared ZapDone As Long = 0

Function TestZmqRecvStr(Byval Socket As Any Ptr) As String
    Dim lpszBuffer As ZString * 256
    Dim Rc As Long = ZmqSocketRec.Recv(Socket, @lpszBuffer, SizeOf(lpszBuffer), 0)

    If Rc >= 0 Then
        Function = Left(lpszBuffer, Rc)
    Else
        Function = ""
    End If
End Function

Sub TestZmqZapProc(Byval vData As Any Ptr)
    Dim Socket As Any Ptr = vData

    While ZapRunning
        Dim lpszVersion As String = TestZmqRecvStr(Socket)
        Dim lpszSequence As String
        Dim lpszDomain As String
        Dim lpszAddress As String
        Dim lpszRoutingId As String
        Dim lpszMechanism As String
        Dim lpszUser As String
        Dim lpszPass As String
        Dim empty As String = ""

        If lpszVersion = "" Then
            Continue While
        End If

        lpszSequence = TestZmqRecvStr(Socket)
        lpszDomain = TestZmqRecvStr(Socket)
        lpszAddress = TestZmqRecvStr(Socket)
        lpszRoutingId = TestZmqRecvStr(Socket)
        lpszMechanism = TestZmqRecvStr(Socket)
        lpszUser = TestZmqRecvStr(Socket)
        lpszPass = TestZmqRecvStr(Socket)

        ZmqSocketRec.Send(Socket, StrPtr(lpszVersion), Len(lpszVersion), ZMQ_SNDMORE)
        ZmqSocketRec.Send(Socket, StrPtr(lpszSequence), Len(lpszSequence), ZMQ_SNDMORE)

        If (lpszUser = lpszUsername) And (lpszPass = lpszPassword) Then
            ZmqSocketRec.Send(Socket, StrPtr("200"), 3, ZMQ_SNDMORE)
            ZmqSocketRec.Send(Socket, StrPtr("OK"), 2, ZMQ_SNDMORE)
            ZmqSocketRec.Send(Socket, StrPtr("anonymous"), 9, ZMQ_SNDMORE)
            ZmqSocketRec.Send(Socket, StrPtr(empty), 0, 0)
        Else
            ZmqSocketRec.Send(Socket, StrPtr("400"), 3, ZMQ_SNDMORE)
            ZmqSocketRec.Send(Socket, StrPtr("Invalid username or password"), 28, ZMQ_SNDMORE)
            ZmqSocketRec.Send(Socket, StrPtr(empty), 0, ZMQ_SNDMORE)
            ZmqSocketRec.Send(Socket, StrPtr(empty), 0, 0)
        End If
    Wend

    ZmqSocketRec.Close(Socket)
    ZapDone = 1
End Sub

Sub TestZmqPlainRepProc(Byval vData As Any Ptr)
    Dim Socket As Any Ptr = vData
    Dim i As Long

    For i = 0 To 2
        Dim lpszBuffer As ZString * 64
        Dim lpszMessage As String = "Plain Hi"

        If ZmqSocketRec.Recv(Socket, @lpszBuffer, SizeOf(lpszBuffer), 0) < 0 Then
            Exit For
        End If

        ZmqSocketRec.Send(Socket, StrPtr(lpszMessage), Len(lpszMessage), 0)
    Next

    ZmqSocketRec.Close(Socket)
    RepDone = 1
End Sub

Dim ZmqContextRec As LibZmqContext
Dim ZmqHelperRec As LibZmqHelper
Dim ZmqRuntimeRec As LibZmqRuntime

If LibZMQWrapper.DllOpen(lpszLibZmqDll) Then
    Dim Context As Any Ptr = ZmqContextRec.NewCtx()
    Dim SocketZap As Any Ptr = ZmqSocketRec.Socket(Context, ZMQ_REP)
    Dim SocketRep As Any Ptr = ZmqSocketRec.Socket(Context, ZMQ_REP)
    Dim SocketReq As Any Ptr = ZmqSocketRec.Socket(Context, ZMQ_REQ)
    Dim threadZap As Any Ptr
    Dim threadRep As Any Ptr
    Dim Mechanism As Long = 0
    Dim i As Long
    Dim ReplyCount As Long = 0
    Dim wait_ As Long

    ZmqSocketRec.SetsockoptInt(SocketZap, ZMQ_LINGER, 0)
    ZmqSocketRec.SetsockoptInt(SocketRep, ZMQ_LINGER, 0)
    ZmqSocketRec.SetsockoptInt(SocketReq, ZMQ_LINGER, 0)
    ZmqSocketRec.SetsockoptInt(SocketZap, ZMQ_RCVTIMEO, 100)
    ZmqSocketRec.SetsockoptInt(SocketRep, ZMQ_RCVTIMEO, 1000)
    ZmqSocketRec.SetsockoptInt(SocketReq, ZMQ_RCVTIMEO, 1000)
    ZmqSocketRec.SetsockoptInt(SocketReq, ZMQ_SNDTIMEO, 1000)

    ZmqSocketRec.Bind(SocketZap, "inproc://zeromq.zap.01")
    threadZap = ZmqHelperRec.Threadstart(@TestZmqZapProc, SocketZap)
    Sleep(50)

    ZmqSocketRec.Setsockopt(SocketRep, ZMQ_ZAP_DOMAIN, StrPtr(lpszZapDomain), Len(lpszZapDomain))
    ZmqSocketRec.SetsockoptInt(SocketRep, ZMQ_PLAIN_SERVER, 1)
    ZmqSocketRec.Setsockopt(SocketReq, ZMQ_PLAIN_USERNAME, StrPtr(lpszUsername), Len(lpszUsername))
    ZmqSocketRec.Setsockopt(SocketReq, ZMQ_PLAIN_PASSWORD, StrPtr(lpszPassword), Len(lpszPassword))

    ZmqSocketRec.Bind(SocketRep, "tcp://127.0.0.1:1720")
    threadRep = ZmqHelperRec.Threadstart(@TestZmqPlainRepProc, SocketRep)
    Sleep(50)

    ZmqSocketRec.Connect(SocketReq, lpszClientAddr)

    ZmqSocketRec.GetsockoptInt(SocketReq, ZMQ_MECHANISM, Mechanism)
    Print("Client mechanism: " & Mechanism & " (PLAIN=1)")
    Print("PLAIN REQ/REP on " & lpszClientAddr)

    For i = 0 To 2
        Dim lpszBuffer As ZString * 64
        Dim lpszMessage As String = "From Plain Client"

        If ZmqSocketRec.Send(SocketReq, StrPtr(lpszMessage), Len(lpszMessage), 0) < 0 Then
            Print("Send failed: " & *ZmqRuntimeRec.Strerror(ZmqRuntimeRec.Errno()))
            Exit For
        End If

        If ZmqSocketRec.Recv(SocketReq, @lpszBuffer, SizeOf(lpszBuffer), 0) < 0 Then
            Print("Recv failed: " & *ZmqRuntimeRec.Strerror(ZmqRuntimeRec.Errno()))
            Exit For
        End If

        Print("Client Reply: " & lpszBuffer)
        ReplyCount += 1
    Next

    Print("Plain replies: " & ReplyCount)

    ZmqSocketRec.Close(SocketReq)
    ZapRunning = 0

    For wait_ = 1 To 50
        If RepDone And ZapDone Then
            Exit For
        End If
        Sleep(100)
    Next

    ZmqHelperRec.Threadclose(threadRep)
    ZmqHelperRec.Threadclose(threadZap)
    ZmqContextRec.Term(Context)
    LibZMQWrapper.DllClose()
End If

Print("Press any key to continue...")
Sleep()
