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

Const lpszServerAddr As String = "tcp://localhost:1689"

Dim hLibrary As Any Ptr = ZmqDllOpen(lpszLibZmqDll)

If hLibrary > 0 Then
    Dim Context As Any Ptr = ZmqCtxNew(hLibrary)
    Dim Socket As Any Ptr = ZmqSocket(hLibrary, Context, ZMQ_SUB)
    Dim lpszSubscribe As String = "quotes"
    Dim Rc As Long

    ' Subscribe before connect to reduce missed early messages.
    ZmqSetsockopt(hLibrary, Socket, ZMQ_SUBSCRIBE, StrPtr(lpszSubscribe), Len(lpszSubscribe))
    Rc = ZmqConnect(hLibrary, Socket, lpszServerAddr)

    If Rc <> 0 Then
        Print("Connect failed: " & *ZmqStrerror(hLibrary, ZmqErrno(hLibrary)))
    Else
        Print("Connected: " & lpszServerAddr & " (subscribe=" & lpszSubscribe & ")")

        While 1
            Dim lpszTopicBuffer As ZString * 256
            Dim lpszRecvBuffer As ZString * 256
            Dim TopicBytes As Long
            Dim MessageBytes As Long

            TopicBytes = ZmqRecv(hLibrary, Socket, @lpszTopicBuffer, SizeOf(lpszTopicBuffer), 0)

            If TopicBytes = -1 Then
                Print("Recv topic failed: " & *ZmqStrerror(hLibrary, ZmqErrno(hLibrary)))
            Else
                MessageBytes = ZmqRecv(hLibrary, Socket, @lpszRecvBuffer, SizeOf(lpszRecvBuffer), 0)

                If MessageBytes = -1 Then
                    Print("Recv message failed: " & *ZmqStrerror(hLibrary, ZmqErrno(hLibrary)))
                Else
                    Print(Left(lpszRecvBuffer, MessageBytes))
                End If
            End If
        Wend
    End If

    ZmqClose(hLibrary, Socket)
    ZmqCtxShutdown(hLibrary, Context)
    ZmqDllClose(hLibrary)
End If

Print("Press any key to continue...")
Sleep()
