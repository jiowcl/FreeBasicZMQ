'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Include "../Core/ZeroMQ.bi"

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

Dim Shared hLibrary As Any Ptr
Dim Shared ZapRunning As Long = 1
Dim Shared RepDone As Long = 0
Dim Shared ZapDone As Long = 0

Function TestZmqRecvStr(Byval Socket As Any Ptr) As String
    Dim lpszBuffer As ZString * 256
    Dim Rc As Long = ZmqRecv(hLibrary, Socket, @lpszBuffer, SizeOf(lpszBuffer), 0)

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

        ZmqSend(hLibrary, Socket, StrPtr(lpszVersion), Len(lpszVersion), ZMQ_SNDMORE)
        ZmqSend(hLibrary, Socket, StrPtr(lpszSequence), Len(lpszSequence), ZMQ_SNDMORE)

        If (lpszUser = lpszUsername) And (lpszPass = lpszPassword) Then
            ZmqSend(hLibrary, Socket, StrPtr("200"), 3, ZMQ_SNDMORE)
            ZmqSend(hLibrary, Socket, StrPtr("OK"), 2, ZMQ_SNDMORE)
            ZmqSend(hLibrary, Socket, StrPtr("anonymous"), 9, ZMQ_SNDMORE)
            ZmqSend(hLibrary, Socket, StrPtr(empty), 0, 0)
        Else
            ZmqSend(hLibrary, Socket, StrPtr("400"), 3, ZMQ_SNDMORE)
            ZmqSend(hLibrary, Socket, StrPtr("Invalid username or password"), 28, ZMQ_SNDMORE)
            ZmqSend(hLibrary, Socket, StrPtr(empty), 0, ZMQ_SNDMORE)
            ZmqSend(hLibrary, Socket, StrPtr(empty), 0, 0)
        End If
    Wend

    ZmqClose(hLibrary, Socket)
    ZapDone = 1
End Sub

Sub TestZmqPlainRepProc(Byval vData As Any Ptr)
    Dim Socket As Any Ptr = vData
    Dim i As Long

    For i = 0 To 2
        Dim lpszBuffer As ZString * 64
        Dim lpszMessage As String = "Plain Hi"

        If ZmqRecv(hLibrary, Socket, @lpszBuffer, SizeOf(lpszBuffer), 0) < 0 Then
            Exit For
        End If

        ZmqSend(hLibrary, Socket, StrPtr(lpszMessage), Len(lpszMessage), 0)
    Next

    ZmqClose(hLibrary, Socket)
    RepDone = 1
End Sub

hLibrary = ZmqDllOpen(lpszLibZmqDll)

If hLibrary > 0 Then
    Dim Context As Any Ptr = ZmqCtxNew(hLibrary)
    Dim SocketZap As Any Ptr = ZmqSocket(hLibrary, Context, ZMQ_REP)
    Dim SocketRep As Any Ptr = ZmqSocket(hLibrary, Context, ZMQ_REP)
    Dim SocketReq As Any Ptr = ZmqSocket(hLibrary, Context, ZMQ_REQ)
    Dim threadZap As Any Ptr
    Dim threadRep As Any Ptr
    Dim Mechanism As Long = 0
    Dim i As Long
    Dim ReplyCount As Long = 0
    Dim wait_ As Long

    ZmqSetsockoptInt(hLibrary, SocketZap, ZMQ_LINGER, 0)
    ZmqSetsockoptInt(hLibrary, SocketRep, ZMQ_LINGER, 0)
    ZmqSetsockoptInt(hLibrary, SocketReq, ZMQ_LINGER, 0)
    ZmqSetsockoptInt(hLibrary, SocketZap, ZMQ_RCVTIMEO, 100)
    ZmqSetsockoptInt(hLibrary, SocketRep, ZMQ_RCVTIMEO, 1000)
    ZmqSetsockoptInt(hLibrary, SocketReq, ZMQ_RCVTIMEO, 1000)
    ZmqSetsockoptInt(hLibrary, SocketReq, ZMQ_SNDTIMEO, 1000)

    ' ZAP handler must run in another thread before connect/handshake.
    ZmqBind(hLibrary, SocketZap, "inproc://zeromq.zap.01")
    threadZap = ZmqThreadstart(hLibrary, @TestZmqZapProc, SocketZap)
    Sleep(50)

    ZmqSetsockopt(hLibrary, SocketRep, ZMQ_ZAP_DOMAIN, StrPtr(lpszZapDomain), Len(lpszZapDomain))
    ZmqSetsockoptInt(hLibrary, SocketRep, ZMQ_PLAIN_SERVER, 1)
    ZmqSetsockopt(hLibrary, SocketReq, ZMQ_PLAIN_USERNAME, StrPtr(lpszUsername), Len(lpszUsername))
    ZmqSetsockopt(hLibrary, SocketReq, ZMQ_PLAIN_PASSWORD, StrPtr(lpszPassword), Len(lpszPassword))

    ZmqBind(hLibrary, SocketRep, "tcp://127.0.0.1:1720")
    threadRep = ZmqThreadstart(hLibrary, @TestZmqPlainRepProc, SocketRep)
    Sleep(50)

    ZmqConnect(hLibrary, SocketReq, lpszClientAddr)

    ZmqGetsockoptInt(hLibrary, SocketReq, ZMQ_MECHANISM, Mechanism)
    Print("Client mechanism: " & Mechanism & " (PLAIN=1)")
    Print("PLAIN REQ/REP on " & lpszClientAddr)

    For i = 0 To 2
        Dim lpszBuffer As ZString * 64
        Dim lpszMessage As String = "From Plain Client"

        If ZmqSend(hLibrary, SocketReq, StrPtr(lpszMessage), Len(lpszMessage), 0) < 0 Then
            Print("Send failed: " & *ZmqStrerror(hLibrary, ZmqErrno(hLibrary)))
            Exit For
        End If

        If ZmqRecv(hLibrary, SocketReq, @lpszBuffer, SizeOf(lpszBuffer), 0) < 0 Then
            Print("Recv failed: " & *ZmqStrerror(hLibrary, ZmqErrno(hLibrary)))
            Exit For
        End If

        Print("Client Reply: " & lpszBuffer)
        ReplyCount += 1
    Next

    Print("Plain replies: " & ReplyCount)

    ZmqClose(hLibrary, SocketReq)
    ZapRunning = 0

    For wait_ = 1 To 50
        If RepDone And ZapDone Then
            Exit For
        End If
        Sleep(100)
    Next

    ZmqThreadclose(hLibrary, threadRep)
    ZmqThreadclose(hLibrary, threadZap)
    ZmqCtxTerm(hLibrary, Context)
    ZmqDllClose(hLibrary)
End If

Print("Press any key to continue...")
Sleep()
