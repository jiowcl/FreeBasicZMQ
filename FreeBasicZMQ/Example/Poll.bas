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

Const lpszServerAddr As String = "tcp://*:1712"

Dim hLibrary As Any Ptr = ZmqDllOpen(lpszLibZmqDll)

If hLibrary > 0 Then
    Dim Context As Any Ptr = ZmqCtxNew(hLibrary)
    Dim Socket As Any Ptr = ZmqSocket(hLibrary, Context, ZMQ_PULL)
    Dim Rc As Long = ZmqBind(hLibrary, Socket, lpszServerAddr)
    Dim linger As Long = 0
    Dim items As ZmqPollItemT
    Dim i As Long

    ZmqSetsockopt(hLibrary, Socket, ZMQ_LINGER, @linger, SizeOf(linger))

    Print("Bind an IP address: " & lpszServerAddr)
    Print("Polling for 5 timeouts (500 ms each)...")

    For i = 1 To 5
        items.socket = Socket
        items.fd = 0
        items.events = ZMQ_POLLIN
        items.revents = 0

        Rc = ZmqPoll(hLibrary, @items, 1, 500)

        If (Rc > 0) And ((items.revents And ZMQ_POLLIN) <> 0) Then
            Dim lpszBuffer As ZString * 64

            ZmqRecv(hLibrary, Socket, @lpszBuffer, SizeOf(lpszBuffer), 0)
            Print("Received: " & lpszBuffer)
        ElseIf Rc = 0 Then
            Print("Poll timeout #" & i)
        Else
            Print("Poll error: " & *ZmqStrerror(hLibrary, ZmqErrno(hLibrary)))
        End If
    Next

    ZmqClose(hLibrary, Socket)
    ZmqCtxShutdown(hLibrary, Context)
    ZmqDllClose(hLibrary)
End If

Print("Press any key to continue...")
Sleep()
