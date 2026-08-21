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

Const lpszClientAddr As String = "tcp://127.0.0.1:1721"

Dim Shared hLibrary As Any Ptr
Dim Shared RepDone As Long = 0

Sub TestZmqCurveRepProc(Byval vData As Any Ptr)
    Dim Socket As Any Ptr = vData
    Dim i As Long

    For i = 0 To 2
        Dim lpszBuffer As ZString * 64
        Dim lpszMessage As String = "Curve Hi"

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
    If ZmqHas(hLibrary, "curve") = 0 Then
        Print("libzmq was built without CURVE support (zmq_has(""curve"") = 0).")
        Print("Replace Library/*/libzmq.dll with a CURVE-enabled build (libsodium) to run this demo.")
    Else
        Dim lpszServerPublic As ZString * (ZMQ_CURVE_KEYSIZE_Z85 + 1)
        Dim lpszServerSecret As ZString * (ZMQ_CURVE_KEYSIZE_Z85 + 1)
        Dim lpszClientPublic As ZString * (ZMQ_CURVE_KEYSIZE_Z85 + 1)
        Dim lpszClientSecret As ZString * (ZMQ_CURVE_KEYSIZE_Z85 + 1)

        If (ZmqCurveKeypair(hLibrary, @lpszServerPublic, @lpszServerSecret) <> 0) Or _
           (ZmqCurveKeypair(hLibrary, @lpszClientPublic, @lpszClientSecret) <> 0) Then
            Print("CurveKeypair failed: " & *ZmqStrerror(hLibrary, ZmqErrno(hLibrary)))
        Else
            Dim Context As Any Ptr = ZmqCtxNew(hLibrary)
            Dim SocketRep As Any Ptr = ZmqSocket(hLibrary, Context, ZMQ_REP)
            Dim SocketReq As Any Ptr = ZmqSocket(hLibrary, Context, ZMQ_REQ)
            Dim threadRep As Any Ptr
            Dim i As Long
            Dim ReplyCount As Long = 0
            Dim wait_ As Long

            ZmqSetsockoptInt(hLibrary, SocketRep, ZMQ_LINGER, 0)
            ZmqSetsockoptInt(hLibrary, SocketReq, ZMQ_LINGER, 0)
            ZmqSetsockoptInt(hLibrary, SocketRep, ZMQ_RCVTIMEO, 1000)
            ZmqSetsockoptInt(hLibrary, SocketReq, ZMQ_RCVTIMEO, 1000)
            ZmqSetsockoptInt(hLibrary, SocketReq, ZMQ_SNDTIMEO, 1000)

            ZmqSetsockoptInt(hLibrary, SocketRep, ZMQ_CURVE_SERVER, 1)
            ZmqSetsockopt(hLibrary, SocketRep, ZMQ_CURVE_SECRETKEY, @lpszServerSecret, ZMQ_CURVE_KEYSIZE_Z85)

            ZmqSetsockopt(hLibrary, SocketReq, ZMQ_CURVE_PUBLICKEY, @lpszClientPublic, ZMQ_CURVE_KEYSIZE_Z85)
            ZmqSetsockopt(hLibrary, SocketReq, ZMQ_CURVE_SECRETKEY, @lpszClientSecret, ZMQ_CURVE_KEYSIZE_Z85)
            ZmqSetsockopt(hLibrary, SocketReq, ZMQ_CURVE_SERVERKEY, @lpszServerPublic, ZMQ_CURVE_KEYSIZE_Z85)

            ZmqBind(hLibrary, SocketRep, "tcp://127.0.0.1:1721")
            threadRep = ZmqThreadstart(hLibrary, @TestZmqCurveRepProc, SocketRep)
            Sleep(50)

            ZmqConnect(hLibrary, SocketReq, lpszClientAddr)

            Print("CURVE REQ/REP on " & lpszClientAddr)
            Print("Server Public: " & lpszServerPublic)

            For i = 0 To 2
                Dim lpszBuffer As ZString * 64
                Dim lpszMessage As String = "From Curve Client"

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

            Print("Curve replies: " & ReplyCount)

            ZmqClose(hLibrary, SocketReq)

            For wait_ = 1 To 50
                If RepDone Then
                    Exit For
                End If
                Sleep(100)
            Next

            ZmqThreadclose(hLibrary, threadRep)
            ZmqCtxTerm(hLibrary, Context)
        End If
    End If

    ZmqDllClose(hLibrary)
End If

Print("Press any key to continue...")
Sleep()
