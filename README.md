# FreeBasicZMQ

ZMQ Wrapper for FreeBasic Programming Language.

![GitHub](https://img.shields.io/github/license/jiowcl/FreeBasicZMQ.svg)
![FreeBasic](https://img.shields.io/badge/language-FreeBasic-blue.svg)

## Environment

- Windows 7 above (recommend)  
- FreeBasic 1.0 above (recommend)  
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

' Rnd with Range
' Source Code from: https://documentation.help/FreeBASIC/KeyPgRnd.html
Function RndRange(Byval first As Double, Byval last As Double) As Double
    Function = Rnd * (last - first) + first
End Function

Const lpszServerAddr As String = "tcp://*:1689"

Dim ZmqContextRec As LibZmqContext
Dim ZmqSocketRec As LibZmqSocket
Dim ZmqHelperRec As LibZmqHelper

If LibZMQWrapper.DllOpen(lpszLibZmqDll) Then
    Dim Context As Any Ptr = ZmqContextRec.NewCtx()
    Dim Socket As Any Ptr = ZmqSocketRec.Socket(Context, ZMQ_PUB)
    Dim Rc As Long = ZmqSocketRec.Bind(Socket, lpszServerAddr)

    Print("Bind an IP address: " & lpszServerAddr)

    Randomize
    
    While 1
        Dim lpszRecvBufferPtr As Any Ptr = CAllocate(32)
        Dim lpszSendBufferPtr As ZString Ptr
        Dim lpszTopicBufferPtr As ZString Ptr
        Dim lpszTopic As String = "quotes"
        Dim lpszSendMessage As String = "Bid: " & Str(RndRange(9000, 1000)) & ",Ask:" + Str(RndRange(9000, 1000))

        ZmqSocketRec.Recv(Socket, lpszRecvBufferPtr, 32, 0)
        
        Sleep(2)
        
        Dim lpszReturnMessage As String = *CPtr(Zstring Ptr, lpszRecvBufferPtr)
        
        If lpszReturnMessage <> "" Then
            Print("Received: ")
            Print(lpszReturnMessage)
        End If

        lpszTopicBufferPtr = CAllocate(Len(lpszTopic), SizeOfDefZStringPtr(lpszTopicBufferPtr))
        *lpszTopicBufferPtr = lpszTopic
        
        lpszSendBufferPtr = CAllocate(Len(lpszSendMessage), SizeOfDefZStringPtr(lpszSendBufferPtr))
        *lpszSendBufferPtr = lpszSendMessage

        ZmqSocketRec.Send(Socket, lpszTopicBufferPtr, Len(lpszTopic), ZMQ_SNDMORE)
        ZmqSocketRec.Send(Socket, lpszSendBufferPtr, Len(lpszSendMessage), 0)

        Deallocate(lpszRecvBufferPtr) 
        Deallocate(lpszSendBufferPtr) 
        Deallocate(lpszTopicBufferPtr) 

        lpszRecvBufferPtr = 0
        lpszSendBufferPtr = 0
        lpszTopicBufferPtr = 0
    Wend
    
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

Dim lpszCurrentDir As String = Curdir()
Dim lpszLibZmqDll As String = "libzmq.dll"

Const lpszServerAddr As String = "tcp://localhost:1689"

Dim ZmqContextRec As LibZmqContext
Dim ZmqSocketRec As LibZmqSocket
Dim ZmqHelperRec As LibZmqHelper

If LibZMQWrapper.DllOpen(lpszLibZmqDll) Then
    Dim Context As Any Ptr = ZmqContextRec.NewCtx()
    Dim Socket As Any Ptr = ZmqSocketRec.Socket(Context, ZMQ_SUB)
    Dim Rc As Long = ZmqSocketRec.Connect(Socket, lpszServerAddr)
    
    Dim lpszSubscribePtr As ZString Ptr
    Dim lpszSubscribe As String = "quotes"

    lpszSubscribePtr = CAllocate(Len(lpszSubscribe), SizeOfDefZStringPtr(lpszSubscribePtr))
    *lpszSubscribePtr = lpszSubscribe

    ZmqSocketRec.Setsockopt(Socket, ZMQ_SUBSCRIBE, lpszSubscribePtr, Len(lpszSubscribe))
    
    While 1
        Dim lpszTopicBufferPtr As Any Ptr = CAllocate(32)
        Dim lpszRecvBufferPtr As Any Ptr = CAllocate(64)

        ZmqSocketRec.Recv(Socket, lpszTopicBufferPtr, 32, 0)
        ZmqSocketRec.Recv(Socket, lpszRecvBufferPtr, 64, 0)

        Print(*CPtr(Zstring Ptr, lpszRecvBufferPtr))
        
        Deallocate(lpszTopicBufferPtr)
        Deallocate(lpszRecvBufferPtr)

        lpszTopicBufferPtr = 0
        lpszRecvBufferPtr = 0
        
        Sleep(2)
    Wend

    Deallocate(lpszSubscribePtr)

    lpszSubscribePtr = 0
    
    ZmqSocketRec.Close(Socket)
    ZmqContextRec.Shutdown(Context)
    
    Input("")

    LibZMQWrapper.DllClose()
End If
```

## License

Copyright (c) 2017-2023 Ji-Feng Tsai.  
Code released under the MIT license.  

## TODO

- More examples  

## Donation

If this application help you reduce time to coding, you can give me a cup of coffee :)

[![paypal](https://www.paypalobjects.com/en_US/TW/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=3RNMD6Q3B495N&source=url)

[Paypal Me](https://paypal.me/jiowcl?locale.x=zh_TW)
