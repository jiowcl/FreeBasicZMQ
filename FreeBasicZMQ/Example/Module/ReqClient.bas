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

Const lpszServerAddr As String = "tcp://localhost:1700"

Dim ZmqContextRec As LibZmqContext
Dim ZmqSocketRec As LibZmqSocket
Dim ZmqHelperRec As LibZmqHelper

If LibZMQWrapper.DllOpen(lpszLibZmqDll) Then
    Dim Context As Any Ptr = ZmqContextRec.NewCtx()
    Dim Socket As Any Ptr = ZmqSocketRec.Socket(Context, ZMQ_REQ)
    Dim Rc As Long = ZmqSocketRec.Connect(Socket, lpszServerAddr)
    
    Print("Connect to Server: " & lpszServerAddr)
    
    Dim i As Integer
    
    For i = 0 To 10 
        Dim lpszSendBufferPtr As ZString Ptr
        Dim lpszRecvBufferPtr As Any Ptr = CAllocate(32)
        Dim lpszSendMessage As String = "From Client"

        lpszSendBufferPtr = CAllocate(Len(lpszSendMessage), SizeOfDefZStringPtr(lpszSendBufferPtr))
        *lpszSendBufferPtr = lpszSendMessage

        ZmqSocketRec.Send(Socket, lpszSendBufferPtr, Len(lpszSendMessage), 0)
        ZmqSocketRec.Recv(Socket, lpszRecvBufferPtr, 32, 0)
        
        Print("Reply From Server: ")
        Print(*CPtr(Zstring Ptr, lpszRecvBufferPtr))
        
        Deallocate(lpszSendBufferPtr)
        Deallocate(lpszRecvBufferPtr) 

        lpszSendBufferPtr = 0
        lpszRecvBufferPtr = 0
    Next
    
    ZmqSocketRec.Close(Socket)
    ZmqContextRec.Shutdown(Context)
    
    Input("")
    
    LibZMQWrapper.DllClose()
End If