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
Const lpszServerClientAddr As String = "tcp://localhost:1700"

Dim Shared ZmqContextRec As LibZmqContext
Dim Shared ZmqSocketRec As LibZmqSocket
Dim Shared ZmqHelperRec As LibZmqHelper

' Rep Server
Sub TestZmqThreadRepProc(Byval vData As Any Ptr)
    Dim Socket As Any Ptr = vData
    
    Print("Bind an IP address: " & lpszServerAddr)
    
    While 1
        Dim lpszRecvBufferPtr As Any Ptr = CAllocate(32)
        Dim lpszSendBufferPtr As ZString Ptr
        Dim lpszSendMessage As String = "Hi"

        ZmqSocketRec.Recv(Socket, lpszRecvBufferPtr, 32, 0)

        Sleep(2)

        lpszSendBufferPtr = CAllocate(Len(lpszSendMessage), SizeOfDefZStringPtr(lpszSendBufferPtr))
        *lpszSendBufferPtr = lpszSendMessage

        ZmqSocketRec.Send(Socket, lpszSendBufferPtr, Len(lpszSendMessage), 0)

        Print("Received: " & *CPtr(Zstring Ptr, lpszRecvBufferPtr))

        Deallocate(lpszRecvBufferPtr) 
        Deallocate(lpszSendBufferPtr) 

        lpszRecvBufferPtr = 0
        lpszSendBufferPtr = 0
    Wend
End Sub

' Req Client
Sub TestZmqThreadReqProc(Byval vData As Any Ptr)
    Dim Socket As Any Ptr = vData
    Dim i As Integer
    
    Print("Connect to Server: " & lpszServerAddr)
    
    For i = 0 To 20
        Dim lpszSendBufferPtr As ZString Ptr
        Dim lpszRecvBufferPtr As Any Ptr = CAllocate(32)
        Dim lpszSendMessage As String = "From Client"

        lpszSendBufferPtr = CAllocate(Len(lpszSendMessage), SizeOfDefZStringPtr(lpszSendBufferPtr))
        *lpszSendBufferPtr = lpszSendMessage

        ZmqSocketRec.Send(Socket, lpszSendBufferPtr, Len(lpszSendMessage), 0)

        Sleep(1)

        ZmqSocketRec.Recv(Socket, lpszRecvBufferPtr, 32, 0)

        Print("Reply From Server: ")
        Print(*CPtr(Zstring Ptr, lpszRecvBufferPtr))

        Deallocate(lpszSendBufferPtr) 
        Deallocate(lpszRecvBufferPtr) 

        lpszSendBufferPtr = 0
        lpszRecvBufferPtr = 0
    Next
End Sub

If LibZMQWrapper.DllOpen(lpszLibZmqDll) Then
    Dim ContextRep As Any Ptr = ZmqContextRec.NewCtx()
    Dim SocketRep As Any Ptr = ZmqSocketRec.Socket(ContextRep, ZMQ_REP)
    Dim RcRep As Long = ZmqSocketRec.Bind(SocketRep, lpszServerAddr)

    Dim ContextReq As Any Ptr = ZmqContextRec.NewCtx()
    Dim SocketReq As Any Ptr = ZmqSocketRec.Socket(ContextReq, ZMQ_REQ)
    Dim RcReq As Long = ZmqSocketRec.Connect(SocketReq, lpszServerClientAddr)

    Dim threadRepPtr As Any Ptr = ZmqHelperRec.Threadstart(@TestZmqThreadRepProc, SocketRep)
    Dim threadReqPtr As Any Ptr = ZmqHelperRec.Threadstart(@TestZmqThreadReqProc, SocketReq)
    
    Input("")
    
    ZmqHelperRec.Threadclose(threadRepPtr)
    ZmqHelperRec.Threadclose(threadReqPtr)
    
    ZmqSocketRec.Close(SocketRep)
    ZmqContextRec.Shutdown(ContextRep)
    
    ZmqSocketRec.Close(SocketReq)
    ZmqContextRec.Shutdown(ContextReq)
    
    LibZMQWrapper.DllClose()
End If