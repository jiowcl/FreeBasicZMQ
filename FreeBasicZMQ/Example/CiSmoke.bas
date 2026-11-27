'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------
' Headless smoke test for CI (no Sleep / no blocking demos).
' Run from the package root (directory containing Core/, Example/, Library/).

#Include "../Core/ZeroMQ.bi"

Sub CiFail(Byval msg As String)
    Print("CI_SMOKE_FAIL: " & msg)
    End 1
End Sub

Function LibZmqLoad() As Any Ptr
    Dim root As String = Curdir()
    Dim libPath As String

    #If Defined(__FB_WIN32__) Or Defined(__FB_WIN64__)
        #If Defined(__FB_64BIT__)
            Dim libDir As String = root & "/Library/x64"
            libPath = libDir & "/libzmq.dll"
        #Else
            Dim libDir As String = root & "/Library/x86"
            libPath = libDir & "/libzmq.dll"
        #EndIf
        ChDir(libDir)
        Function = ZmqDllOpen(libPath)
    #Else
        Dim h As Any Ptr = ZmqDllOpen("libzmq.so.5")
        If h = 0 Then
            h = ZmqDllOpen("libzmq.so")
        End If
        Function = h
    #EndIf
End Function

Dim hLib As Any Ptr = LibZmqLoad()
If hLib = 0 Then CiFail("DyLibLoad libzmq")

Dim major As Long = 0
Dim minor As Long = 0
Dim patch As Long = 0
ZmqVersion(hLib, major, minor, patch)
If major <= 0 Then CiFail("zmq_version")

Print("CI_SMOKE: version=" & major & "." & minor & "." & patch)
Print("CI_SMOKE: has_ipc=" & ZmqHas(hLib, "ipc"))
Print("CI_SMOKE: has_curve=" & ZmqHas(hLib, "curve"))

Dim lpszData As ZString * 9 = "TestData"
Dim lpszDecoded As ZString * 9
Dim lpszEncoded As String = ZmqZ85EncodeStr(hLib, @lpszData, 8)
If Len(lpszEncoded) = 0 Then CiFail("z85_encode")
If ZmqZ85DecodeStr(hLib, lpszEncoded, @lpszDecoded, 8) = 0 Then CiFail("z85_decode")
If Left(lpszDecoded, 8) <> "TestData" Then CiFail("z85_roundtrip")

Dim ctx As Any Ptr = ZmqCtxNew(hLib)
If ctx = 0 Then CiFail("zmq_ctx_new")

Dim repSock As Any Ptr = ZmqSocket(hLib, ctx, ZMQ_REP)
Dim reqSock As Any Ptr = ZmqSocket(hLib, ctx, ZMQ_REQ)
If repSock = 0 Or reqSock = 0 Then CiFail("zmq_socket")

ZmqSetsockoptInt(hLib, repSock, ZMQ_LINGER, 0)
ZmqSetsockoptInt(hLib, reqSock, ZMQ_LINGER, 0)

Const addr As String = "inproc://freebasiczmq-ci-smoke"
If ZmqBind(hLib, repSock, addr) <> 0 Then CiFail("zmq_bind")
If ZmqConnect(hLib, reqSock, addr) <> 0 Then CiFail("zmq_connect")

Dim sendPing As ZString * 16 = "ping"
Dim recvBuf As ZString * 32
Dim rc As Long

rc = ZmqSend(hLib, reqSock, @sendPing, 4, 0)
If rc < 0 Then CiFail("req_send")
rc = ZmqRecv(hLib, repSock, @recvBuf, SizeOf(recvBuf) - 1, 0)
If rc < 0 Then CiFail("rep_recv")
If Left(recvBuf, 4) <> "ping" Then CiFail("rep_payload")

Dim sendPong As ZString * 16 = "pong"
rc = ZmqSend(hLib, repSock, @sendPong, 4, 0)
If rc < 0 Then CiFail("rep_send")
recvBuf = ""
rc = ZmqRecv(hLib, reqSock, @recvBuf, SizeOf(recvBuf) - 1, 0)
If rc < 0 Then CiFail("req_recv")
If Left(recvBuf, 4) <> "pong" Then CiFail("req_payload")

ZmqClose(hLib, reqSock)
ZmqClose(hLib, repSock)
ZmqCtxShutdown(hLib, ctx)
ZmqDllClose(hLib)

Print("CI_SMOKE_OK")
End 0