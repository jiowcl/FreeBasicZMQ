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

' Rnd with Range
' Source Code from: https://documentation.help/FreeBASIC/KeyPgRnd.html
Function RndRange(Byval first As Double, Byval last As Double) As Double
    Function = Rnd * (last - first) + first
End Function

Const lpszServerAddr As String = "tcp://*:1689"

Dim hLibrary As Any Ptr = ZmqDllOpen(lpszLibZmqDll)

If hLibrary > 0 Then
    Dim Context As Any Ptr = ZmqCtxNew(hLibrary)
    Dim Socket As Any Ptr = ZmqSocket(hLibrary, Context, ZMQ_PUB)
    Dim Rc As Long = ZmqBind(hLibrary, Socket, lpszServerAddr)

    If Rc <> 0 Then
        Print("Bind failed: " & *ZmqStrerror(hLibrary, ZmqErrno(hLibrary)))
    Else
        Print("Bind an IP address: " & lpszServerAddr)

        ' Allow subscribers time to connect (slow joiner).
        Sleep(200)
        Randomize

        While 1
            Dim lpszTopic As String = "quotes"
            Dim lpszSendMessage As String = "Bid:" & Str(CInt(RndRange(1000, 9000))) & ",Ask:" & Str(CInt(RndRange(1000, 9000)))

            If ZmqSend(hLibrary, Socket, StrPtr(lpszTopic), Len(lpszTopic), ZMQ_SNDMORE) = -1 Then
                Print("Send topic failed: " & *ZmqStrerror(hLibrary, ZmqErrno(hLibrary)))
            ElseIf ZmqSend(hLibrary, Socket, StrPtr(lpszSendMessage), Len(lpszSendMessage), 0) = -1 Then
                Print("Send message failed: " & *ZmqStrerror(hLibrary, ZmqErrno(hLibrary)))
            Else
                Print("Published: " & lpszSendMessage)
            End If

            Sleep(100)
        Wend
    End If

    ZmqClose(hLibrary, Socket)
    ZmqCtxShutdown(hLibrary, Context)
    ZmqDllClose(hLibrary)
End If
