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

Const lpszServerAddr As String = "tcp://localhost:1692"

Dim ZmqContextRec As LibZmqContext
Dim ZmqSocketRec As LibZmqSocket
Dim ZmqRuntimeRec As LibZmqRuntime

If LibZMQWrapper.DllOpen(lpszLibZmqDll) Then
    Dim Context As Any Ptr = ZmqContextRec.NewCtx()
    Dim Socket As Any Ptr = ZmqSocketRec.Socket(Context, ZMQ_SUB)
    Dim lpszSubscribe As String = "weather"
    Dim Rc As Long

    ZmqSocketRec.Setsockopt(Socket, ZMQ_SUBSCRIBE, StrPtr(lpszSubscribe), Len(lpszSubscribe))
    Rc = ZmqSocketRec.Connect(Socket, lpszServerAddr)

    If Rc <> 0 Then
        Print("Connect failed: " & *ZmqRuntimeRec.Strerror(ZmqRuntimeRec.Errno()))
    Else
        Print("Connected: " & lpszServerAddr & " (subscribe=" & lpszSubscribe & ")")

        While 1
            Dim lpszTopicBuffer As ZString * 256
            Dim lpszRecvBuffer As ZString * 512
            Dim TopicBytes As Long
            Dim MessageBytes As Long

            TopicBytes = ZmqSocketRec.Recv(Socket, @lpszTopicBuffer, SizeOf(lpszTopicBuffer), 0)

            If TopicBytes = -1 Then
                Print("Recv topic failed: " & *ZmqRuntimeRec.Strerror(ZmqRuntimeRec.Errno()))
            Else
                MessageBytes = ZmqSocketRec.Recv(Socket, @lpszRecvBuffer, SizeOf(lpszRecvBuffer), 0)

                If MessageBytes = -1 Then
                    Print("Recv message failed: " & *ZmqRuntimeRec.Strerror(ZmqRuntimeRec.Errno()))
                Else
                    Print(Left(lpszRecvBuffer, MessageBytes))
                End If
            End If
        Wend
    End If

    ZmqSocketRec.Close(Socket)
    ZmqContextRec.Shutdown(Context)
    LibZMQWrapper.DllClose()
End If

Print("Press any key to continue...")
Sleep()
