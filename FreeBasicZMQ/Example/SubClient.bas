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

Const lpszServerAddr As String = "tcp://localhost:1700"

Dim hLibrary As Any Ptr = ZmqDllOpen(lpszLibZmqDll)

If hLibrary > 0 Then
    Dim Context As Any Ptr = ZmqCtxNew(hLibrary)
    Dim Socket As Any Ptr = ZmqSocket(hLibrary, Context, ZMQ_SUB)
    Dim Rc As Long = ZmqConnect(hLibrary, Socket, lpszServerAddr)
    
    Dim lpszSubscribePtr As ZString Ptr
    Dim lpszSubscribe As String = "quotes"

    lpszSubscribePtr = CAllocate(Len(lpszSubscribe), SizeOfDefZStringPtr(lpszSubscribePtr))
    *lpszSubscribePtr = lpszSubscribe

    ZmqSetsockopt(hLibrary, Socket, ZMQ_SUBSCRIBE, lpszSubscribePtr, Len(lpszSubscribe))
    
    While 1
        Dim lpszTopicBufferPtr As Any Ptr = CAllocate(32)
        Dim lpszRecvBufferPtr As Any Ptr = CAllocate(64)

        ZmqRecv(hLibrary, Socket, lpszTopicBufferPtr, 32, 0)
        ZmqRecv(hLibrary, Socket, lpszRecvBufferPtr, 64, 0)

        Print(*CPtr(ZString Ptr, lpszRecvBufferPtr))
        
        Deallocate(lpszTopicBufferPtr)
        Deallocate(lpszRecvBufferPtr)

        lpszTopicBufferPtr = 0
        lpszRecvBufferPtr = 0
        
        Sleep(2)
    Wend

    Deallocate(lpszSubscribePtr)

    lpszSubscribePtr = 0
    
    ZmqClose(hLibrary, Socket)
    ZmqCtxShutdown(hLibrary, Context)
    
    Input("")
    
    ZmqDllClose(hLibrary)
End If