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

Const lpszClientAddr As String = "tcp://127.0.0.1:1721"

Dim Shared ZmqSocketRec As LibZmqSocket
Dim Shared RepDone As Long = 0

Sub TestZmqCurveRepProc(Byval vData As Any Ptr)
    Dim Socket As Any Ptr = vData
    Dim i As Long

    For i = 0 To 2
        Dim lpszBuffer As ZString * 64
        Dim lpszMessage As String = "Curve Hi"

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
Dim ZmqSecurityRec As LibZmqSecurity

If LibZMQWrapper.DllOpen(lpszLibZmqDll) Then
    If ZmqRuntimeRec.Has("curve") = 0 Then
        Print("libzmq was built without CURVE support (zmq_has(""curve"") = 0).")
        Print("Replace Library/*/libzmq.dll with a CURVE-enabled build (libsodium) to run this demo.")
    Else
        Dim lpszServerPublic As ZString * (ZMQ_CURVE_KEYSIZE_Z85 + 1)
        Dim lpszServerSecret As ZString * (ZMQ_CURVE_KEYSIZE_Z85 + 1)
        Dim lpszClientPublic As ZString * (ZMQ_CURVE_KEYSIZE_Z85 + 1)
        Dim lpszClientSecret As ZString * (ZMQ_CURVE_KEYSIZE_Z85 + 1)

        If (ZmqSecurityRec.CurveKeypair(@lpszServerPublic, @lpszServerSecret) <> 0) Or _
           (ZmqSecurityRec.CurveKeypair(@lpszClientPublic, @lpszClientSecret) <> 0) Then
            Print("CurveKeypair failed: " & *ZmqRuntimeRec.Strerror(ZmqRuntimeRec.Errno()))
        Else
            Dim Context As Any Ptr = ZmqContextRec.NewCtx()
            Dim SocketRep As Any Ptr = ZmqSocketRec.Socket(Context, ZMQ_REP)
            Dim SocketReq As Any Ptr = ZmqSocketRec.Socket(Context, ZMQ_REQ)
            Dim threadRep As Any Ptr
            Dim i As Long
            Dim ReplyCount As Long = 0
            Dim wait_ As Long

            ZmqSocketRec.SetsockoptInt(SocketRep, ZMQ_LINGER, 0)
            ZmqSocketRec.SetsockoptInt(SocketReq, ZMQ_LINGER, 0)
            ZmqSocketRec.SetsockoptInt(SocketRep, ZMQ_RCVTIMEO, 1000)
            ZmqSocketRec.SetsockoptInt(SocketReq, ZMQ_RCVTIMEO, 1000)
            ZmqSocketRec.SetsockoptInt(SocketReq, ZMQ_SNDTIMEO, 1000)

            ZmqSocketRec.SetsockoptInt(SocketRep, ZMQ_CURVE_SERVER, 1)
            ZmqSocketRec.Setsockopt(SocketRep, ZMQ_CURVE_SECRETKEY, @lpszServerSecret, ZMQ_CURVE_KEYSIZE_Z85)

            ZmqSocketRec.Setsockopt(SocketReq, ZMQ_CURVE_PUBLICKEY, @lpszClientPublic, ZMQ_CURVE_KEYSIZE_Z85)
            ZmqSocketRec.Setsockopt(SocketReq, ZMQ_CURVE_SECRETKEY, @lpszClientSecret, ZMQ_CURVE_KEYSIZE_Z85)
            ZmqSocketRec.Setsockopt(SocketReq, ZMQ_CURVE_SERVERKEY, @lpszServerPublic, ZMQ_CURVE_KEYSIZE_Z85)

            ZmqSocketRec.Bind(SocketRep, "tcp://127.0.0.1:1721")
            threadRep = ZmqHelperRec.Threadstart(@TestZmqCurveRepProc, SocketRep)
            Sleep(50)

            ZmqSocketRec.Connect(SocketReq, lpszClientAddr)

            Print("CURVE REQ/REP on " & lpszClientAddr)
            Print("Server Public: " & lpszServerPublic)

            For i = 0 To 2
                Dim lpszBuffer As ZString * 64
                Dim lpszMessage As String = "From Curve Client"

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

            Print("Curve replies: " & ReplyCount)

            ZmqSocketRec.Close(SocketReq)

            For wait_ = 1 To 50
                If RepDone Then
                    Exit For
                End If
                Sleep(100)
            Next

            ZmqHelperRec.Threadclose(threadRep)
            ZmqContextRec.Term(Context)
        End If
    End If

    LibZMQWrapper.DllClose()
End If

Print("Press any key to continue...")
Sleep()
