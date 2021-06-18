'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Include "../Core/ZeroMQ.bi"

Dim lpszCurrentDir As String = Curdir()

' Libzmq version (x86/x64)
#ifdef __FB_WIN32__
    Dim lpszLibZmqDir As String = "/Library/x86"
    Dim lpszLibZmqDll As String = lpszCurrentDir & lpszLibZmqDir & "/libzmq.dll"
  
    Chdir(lpszCurrentDir & lpszLibZmqDir)
#else
    Dim lpszLibZmqDir As String = "/Library/x64"
    Dim lpszLibZmqDll As String = lpszCurrentDir & lpszLibZmqDir & "/libzmq.dll"
  
    Chdir(lpszCurrentDir & lpszLibZmqDir)
#endif

' Rnd with Range
' Source Code from: https://documentation.help/FreeBASIC/KeyPgRnd.html
Function RndRange(Byval first As Double, Byval last As Double) As Double
    Function = Rnd * (last - first) + first
End Function

Const lpszServerAddr As String = "tcp://*:1700"

Dim hLibrary As Any Ptr = ZmqDllOpen(lpszLibZmqDll)

If hLibrary > 0 Then
    Dim Context As Any Ptr = ZmqCtxNew(hLibrary)
    Dim Socket As Any Ptr = ZmqSocket(hLibrary, Context, ZMQ_PUB)
    Dim Rc As Long = ZmqBind(hLibrary, Socket, lpszServerAddr)
    
    Print("Bind an IP address: " & lpszServerAddr)

    Randomize
    
    While 1
        Dim lpszRecvBufferPtr As Any Ptr = CAllocate(32)
        Dim lpszSendBufferPtr As ZString Ptr
        Dim lpszTopicBufferPtr As ZString Ptr
        Dim lpszTopic As String = "quotes"
        Dim lpszSendMessage As String = "Bid: " & Str(RndRange(9000, 1000)) & ",Ask:" + Str(RndRange(9000, 1000))

        ZmqRecv(hLibrary, Socket, lpszRecvBufferPtr, 32, 0)
        
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

        ZmqSend(hLibrary, Socket, lpszTopicBufferPtr, Len(lpszTopic), ZMQ_SNDMORE)
        ZmqSend(hLibrary, Socket, lpszSendBufferPtr, Len(lpszSendMessage), 0)

        Deallocate(lpszRecvBufferPtr) 
        Deallocate(lpszSendBufferPtr) 
        Deallocate(lpszTopicBufferPtr) 

        lpszRecvBufferPtr = 0
        lpszSendBufferPtr = 0
        lpszTopicBufferPtr = 0
    Wend
    
    ZmqClose(hLibrary, Socket)
    ZmqCtxShutdown(hLibrary, Context)
    
    ZmqDllClose(hLibrary)
End If