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

Const lpszServerAddr As String = "tcp://localhost:1700"

Dim hLibrary As Any Ptr = ZmqDllOpen(lpszLibZmqDll)

If hLibrary > 0 Then
    Dim Context As Any Ptr = ZmqCtxNew(hLibrary)
    Dim Socket As Any Ptr = ZmqSocket(hLibrary, Context, ZMQ_REQ)
    Dim Rc As Long = ZmqConnect(hLibrary, Socket, lpszServerAddr)
    
    Print("Connect to Server: " & lpszServerAddr)
    
    Dim i As Integer
    
    For i = 0 To 10 
        Dim lpszSendBufferPtr As ZString Ptr
        Dim lpszRecvBufferPtr As Any Ptr = CAllocate(32)
        Dim lpszSendMessage As String = "From Client"

        lpszSendBufferPtr = CAllocate(Len(lpszSendMessage), SizeOfDefZStringPtr(lpszSendBufferPtr))
        *lpszSendBufferPtr = lpszSendMessage

        ZmqSend(hLibrary, Socket, lpszSendBufferPtr, Len(lpszSendMessage), 0)
        ZmqRecv(hLibrary, Socket, lpszRecvBufferPtr, 32, 0)
        
        Print("Reply From Server: ")
        Print(*CPtr(Zstring Ptr, lpszRecvBufferPtr))
        
        Deallocate(lpszSendBufferPtr)
        Deallocate(lpszRecvBufferPtr) 

        lpszSendBufferPtr = 0
        lpszRecvBufferPtr = 0
    Next 
    
    ZmqClose(hLibrary, Socket)
    ZmqCtxShutdown(hLibrary, Context)
    
    Input("")
    
    ZmqDllClose(hLibrary)
End If