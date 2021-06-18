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

Const lpszServerAddr As String = "tcp://*:1700"

Dim hLibrary As Any Ptr = ZmqDllOpen(lpszLibZmqDll)

If hLibrary > 0 Then
    Dim Context As Any Ptr = ZmqCtxNew(hLibrary)
    Dim Socket As Any Ptr = ZmqSocket(hLibrary, Context, ZMQ_REP)
    Dim Rc As Long = ZmqBind(hLibrary, Socket, lpszServerAddr)
    
    Print("Bind an IP address: " & lpszServerAddr)
    
    Dim lTotal As Integer = 0
    
    While 1
        lTotal = lTotal + 1
        
        Dim lpszRecvBufferPtr As Any Ptr = CAllocate(32)
        Dim lpszSendBufferPtr As ZString Ptr
        Dim lpszSendMessage As String = "Hi " & lTotal

        ZmqRecv(hLibrary, Socket, lpszRecvBufferPtr, 32, 0)
        
        Sleep(2)
        
        Print("Received: ")
        Print(*CPtr(Zstring Ptr, lpszRecvBufferPtr))
        
        lpszSendBufferPtr = CAllocate(Len(lpszSendMessage), SizeOfDefZStringPtr(lpszSendBufferPtr))
        *lpszSendBufferPtr = lpszSendMessage

        ZmqSend(hLibrary, Socket, lpszSendBufferPtr, Len(lpszSendMessage), 0)
        
        Deallocate(lpszRecvBufferPtr) 
        Deallocate(lpszSendBufferPtr) 

        lpszRecvBufferPtr = 0
        lpszSendBufferPtr = 0
    Wend
    
    ZmqClose(hLibrary, Socket)
    ZmqCtxShutdown(hLibrary, Context)
    
    ZmqDllClose(hLibrary)
End If