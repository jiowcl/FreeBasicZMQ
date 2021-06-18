'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Include "../../Core/Enums.bi"
#Include "../../Core/ZeroMQWrapper.bi"

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