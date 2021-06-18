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

Const lpszServerAddr As String = "tcp://*:1700"

Dim ZmqContextRec As LibZmqContext
Dim ZmqSocketRec As LibZmqSocket
Dim ZmqHelperRec As LibZmqHelper

If LibZMQWrapper.DllOpen(lpszLibZmqDll) Then
    Dim Context As Any Ptr = ZmqContextRec.NewCtx()
    Dim Socket As Any Ptr = ZmqSocketRec.Socket(Context, ZMQ_REP)
    Dim Rc As Long = ZmqSocketRec.Bind(Socket, lpszServerAddr)
    
    Print("Bind an IP address: " & lpszServerAddr)
    
    Dim lTotal As Integer = 0
    
    While 1
        lTotal = lTotal + 1
        
        Dim lpszRecvBufferPtr As Any Ptr = CAllocate(32)
        Dim lpszSendBufferPtr As ZString Ptr
        Dim lpszSendMessage As String = "Hi " & lTotal

        ZmqSocketRec.Recv(Socket, lpszRecvBufferPtr, 32, 0)
        
        Sleep(2)
        
        Print("Received: ")
        Print(*CPtr(Zstring Ptr, lpszRecvBufferPtr))
        
        lpszSendBufferPtr = CAllocate(Len(lpszSendMessage), SizeOfDefZStringPtr(lpszSendBufferPtr))
        *lpszSendBufferPtr = lpszSendMessage

        ZmqSocketRec.Send(Socket, lpszSendBufferPtr, Len(lpszSendMessage), 0)
        
        Deallocate(lpszRecvBufferPtr) 
        Deallocate(lpszSendBufferPtr) 

        lpszRecvBufferPtr = 0
        lpszSendBufferPtr = 0
    Wend
    
    ZmqSocketRec.Close(Socket)
    ZmqContextRec.Shutdown(Context)
    
    LibZMQWrapper.DllClose()
End If