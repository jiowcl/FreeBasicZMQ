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

' Type for Zmq Dll Instance
Type ZmqHelpType
    Dim dllInstance As Any Ptr
End Type

Const lpszServerAddr As String = "tcp://*:1700"
Const lpszServerClientAddr As String = "tcp://localhost:1700"

Dim Shared hZmqLibrary As ZmqHelpType
Dim hLibrary As Any Ptr = ZmqDllOpen(lpszLibZmqDll)

hZmqLibrary.dllInstance = hLibrary

' Rep Server
Sub TestZmqThreadRepProc(Byval vData As Any Ptr)
    Dim dllInstance As Any Ptr = hZmqLibrary.dllInstance
    Dim Socket As Any Ptr = vData
    
    Print("Bind an IP address: " & lpszServerAddr)
    
    While 1
        Dim lpszRecvBufferPtr As Any Ptr = CAllocate(32)
        Dim lpszSendBufferPtr As ZString Ptr
        Dim lpszSendMessage As String = "Hi"

        ZmqRecv(dllInstance, Socket, lpszRecvBufferPtr, 32, 0)

        Sleep(2)

        lpszSendBufferPtr = CAllocate(Len(lpszSendMessage), SizeOfDefZStringPtr(lpszSendBufferPtr))
        *lpszSendBufferPtr = lpszSendMessage

        ZmqSend(dllInstance, Socket, lpszSendBufferPtr, Len(lpszSendMessage), 0)

        Print("Received: " & *CPtr(Zstring Ptr, lpszRecvBufferPtr))

        Deallocate(lpszRecvBufferPtr) 
        Deallocate(lpszSendBufferPtr) 

        lpszRecvBufferPtr = 0
        lpszSendBufferPtr = 0
    Wend
End Sub

' Req Client
Sub TestZmqThreadReqProc(Byval vData As Any Ptr)
    Dim dllInstance As Any Ptr = hZmqLibrary.dllInstance
    Dim Socket As Any Ptr = vData
    Dim i As Integer
    
    Print("Connect to Server: " & lpszServerAddr)
    
    For i = 0 To 20
        Dim lpszSendBufferPtr As ZString Ptr
        Dim lpszRecvBufferPtr As Any Ptr = CAllocate(32)
        Dim lpszSendMessage As String = "From Client"

        lpszSendBufferPtr = CAllocate(Len(lpszSendMessage), SizeOfDefZStringPtr(lpszSendBufferPtr))
        *lpszSendBufferPtr = lpszSendMessage

        ZmqSend(dllInstance, Socket, lpszSendBufferPtr, Len(lpszSendMessage), 0)

        Sleep(1)

        ZmqRecv(dllInstance, Socket, lpszRecvBufferPtr, 32, 0)

        Print("Reply From Server: ")
        Print(*CPtr(Zstring Ptr, lpszRecvBufferPtr))

        Deallocate(lpszSendBufferPtr) 
        Deallocate(lpszRecvBufferPtr) 

        lpszSendBufferPtr = 0
        lpszRecvBufferPtr = 0
    Next
End Sub

#define sizeofDerefPtr(ptrToDeref) SizeOf(*Cast(TypeOf(ptrToDeref), 0))

If hLibrary > 0 Then
    Dim ContextRep As Any Ptr = ZmqCtxNew(hLibrary)
    Dim SocketRep As Any Ptr = ZmqSocket(hLibrary, ContextRep, ZMQ_REP)
    Dim RcRep As Long = ZmqBind(hLibrary, SocketRep, lpszServerAddr)

    Dim ContextReq As Any Ptr = ZmqCtxNew(hLibrary)
    Dim SocketReq As Any Ptr = ZmqSocket(hLibrary, ContextReq, ZMQ_REQ)
    Dim RcReq As Long = ZmqConnect(hLibrary, SocketReq, lpszServerClientAddr)

    Dim threadRepPtr As Any Ptr = ZmqThreadstart(hLibrary, @TestZmqThreadRepProc, SocketRep)
    Dim threadReqPtr As Any Ptr = ZmqThreadstart(hLibrary, @TestZmqThreadReqProc, SocketReq)
    
    Input("")
    
    ZmqThreadclose(hLibrary, threadRepPtr)
    ZmqThreadclose(hLibrary, threadReqPtr)
    
    ZmqClose(hLibrary, SocketRep)
    ZmqCtxShutdown(hLibrary, ContextRep)
    
    ZmqClose(hLibrary, SocketReq)
    ZmqCtxShutdown(hLibrary, ContextReq)
    
    ZmqDllClose(hLibrary)
End If