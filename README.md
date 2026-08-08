# FreeBasicZMQ

ZMQ Wrapper for FreeBasic Programming Language.

![GitHub](https://img.shields.io/github/license/jiowcl/FreeBasicZMQ.svg)
![FreeBasic](https://img.shields.io/badge/language-FreeBasic-blue.svg)
![Dependency](https://img.shields.io/badge/ZeroMQ-libzmq-FF6600?style=flat-square&logo=zeromq&logoColor=white)

## Environment

- Windows 7 above (recommend)  
- FreeBasic 1.10.1 above (recommend)  
- [ZeroMQ](https://github.com/zeromq)  

## How to Build

Building requires FreeBasic Compiler and test under Windows 10.  

## Example

Publisher Server

```bash
fbc PubServer.bas -target win64
```

```freebasic
#Include "../../Core/Enums.bi"
#Include "../../Core/ZeroMQWrapper.bi"

Dim lpszLibZmqDll As String = "libzmq.dll"

Function RndRange(Byval first As Double, Byval last As Double) As Double
    Function = Rnd * (last - first) + first
End Function

Const lpszServerAddr As String = "tcp://*:1689"

Dim ZmqContextRec As LibZmqContext
Dim ZmqSocketRec As LibZmqSocket
Dim ZmqRuntimeRec As LibZmqRuntime

If LibZMQWrapper.DllOpen(lpszLibZmqDll) Then
    Dim Context As Any Ptr = ZmqContextRec.NewCtx()
    Dim Socket As Any Ptr = ZmqSocketRec.Socket(Context, ZMQ_PUB)
    Dim Rc As Long = ZmqSocketRec.Bind(Socket, lpszServerAddr)

    If Rc <> 0 Then
        Print("Bind failed: " & *ZmqRuntimeRec.Strerror(ZmqRuntimeRec.Errno()))
    Else
        Print("Bind an IP address: " & lpszServerAddr)

        ' Allow subscribers time to connect (slow joiner).
        Sleep(200)
        Randomize

        While 1
            Dim lpszTopic As String = "quotes"
            Dim lpszSendMessage As String = "Bid:" & Str(CInt(RndRange(1000, 9000))) & ",Ask:" & Str(CInt(RndRange(1000, 9000)))

            If ZmqSocketRec.Send(Socket, StrPtr(lpszTopic), Len(lpszTopic), ZMQ_SNDMORE) = -1 Then
                Print("Send topic failed: " & *ZmqRuntimeRec.Strerror(ZmqRuntimeRec.Errno()))
            ElseIf ZmqSocketRec.Send(Socket, StrPtr(lpszSendMessage), Len(lpszSendMessage), 0) = -1 Then
                Print("Send message failed: " & *ZmqRuntimeRec.Strerror(ZmqRuntimeRec.Errno()))
            Else
                Print("Published: " & lpszSendMessage)
            End If

            Sleep(100)
        Wend
    End If

    ZmqSocketRec.Close(Socket)
    ZmqContextRec.Shutdown(Context)
    LibZMQWrapper.DllClose()
End If
```

Subscribe Client

```bash
fbc SubClient.bas -target win64
```

```freebasic
#Include "../../Core/Enums.bi"
#Include "../../Core/ZeroMQWrapper.bi"

Dim lpszLibZmqDll As String = "libzmq.dll"
Const lpszServerAddr As String = "tcp://localhost:1689"

Dim ZmqContextRec As LibZmqContext
Dim ZmqSocketRec As LibZmqSocket
Dim ZmqRuntimeRec As LibZmqRuntime

If LibZMQWrapper.DllOpen(lpszLibZmqDll) Then
    Dim Context As Any Ptr = ZmqContextRec.NewCtx()
    Dim Socket As Any Ptr = ZmqSocketRec.Socket(Context, ZMQ_SUB)
    Dim lpszSubscribe As String = "quotes"
    Dim Rc As Long

    ' Subscribe before connect to reduce missed early messages.
    ZmqSocketRec.Setsockopt(Socket, ZMQ_SUBSCRIBE, StrPtr(lpszSubscribe), Len(lpszSubscribe))
    Rc = ZmqSocketRec.Connect(Socket, lpszServerAddr)

    If Rc <> 0 Then
        Print("Connect failed: " & *ZmqRuntimeRec.Strerror(ZmqRuntimeRec.Errno()))
    Else
        Print("Connected: " & lpszServerAddr & " (subscribe=" & lpszSubscribe & ")")

        While 1
            Dim lpszTopicBuffer As ZString * 256
            Dim lpszRecvBuffer As ZString * 256
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
```

## License

Copyright (c) 2017-2026 Ji-Feng Tsai.  
Code released under the MIT license.  

## TODO

- More examples  

## Donation

If this application help you reduce time to coding, you can give me a cup of coffee :)

[![paypal](https://www.paypalobjects.com/en_US/TW/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=3RNMD6Q3B495N&source=url)

[Paypal Me](https://paypal.me/jiowcl?locale.x=zh_TW)
