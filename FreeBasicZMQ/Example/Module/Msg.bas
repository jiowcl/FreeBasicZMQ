'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Include "crt/string.bi"
#Include "../../Core/Enums.bi"
#Include "../../Core/ZeroMQWrapper.bi"

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

Const lpszServerAddr As String = "tcp://*:1700"
Const lpszServerClientAddr As String = "tcp://localhost:1700"

Dim Shared ZmqContextRec As LibZmqContext
Dim Shared ZmqSocketRec As LibZmqSocket
Dim Shared ZmqMsgRec As LibZmqMsg
Dim Shared ZmqHelperRec As LibZmqHelper

' Rep Server
Sub TestZmqThreadRepProc(Byval vData As Any Ptr)
    Dim Socket As Any Ptr = vData
    
    Print("Bind an IP address: " & lpszServerAddr)
    
    While 1
        Dim vMsgRecv As ZmqMsgT Ptr

        ZmqMsgRec.Init(vMsgRecv)

        If ZmqMsgRec.Recv(vMsgRecv, Socket, 0) > 0 Then
            Print("Received: " & *CPtr(ZString Ptr, ZmqMsgRec.Data(vMsgRecv)))
        End If

        ZmqMsgRec.Close(vMsgRecv)

        Sleep(1)

        Dim vMsgSend As ZmqMsgT Ptr
        Dim lpszSendMessage As String = "Hi"

        ZmqMsgRec.InitSize(vMsgSend, Len(lpszSendMessage))

        MemCpy(ZmqMsgRec.Data(vMsgSend), StrPtr(lpszSendMessage), Len(lpszSendMessage))

        ZmqMsgRec.Send(vMsgSend, Socket, 0)
        ZmqMsgRec.Close(vMsgSend)
    Wend
End Sub

' Req Client
Sub TestZmqThreadReqProc(Byval vData As Any Ptr)
    Dim Socket As Any Ptr = vData
    Dim i As Integer
    
    Print("Connect to Server: " & lpszServerAddr)
    
    Static vMsgSend As ZmqMsgT Ptr
    Static vMsgRecv As ZmqMsgT Ptr

    For i = 0 To 20
        Dim lpszSendBufferPtr As ZString Ptr
        Dim lpszSendMessage As String = "From Client"
        Dim lpszSendMessageSize As Long = Len(lpszSendMessage)

        lpszSendBufferPtr = CAllocate(lpszSendMessageSize, SizeOfDefZStringPtr(lpszSendBufferPtr))
        *lpszSendBufferPtr = lpszSendMessage

        ZmqMsgRec.InitSize(vMsgSend, lpszSendMessageSize)

        MemCpy(ZmqMsgRec.Data(vMsgSend), lpszSendBufferPtr, lpszSendMessageSize)

        ZmqMsgRec.Send(vMsgSend, Socket, 0)
        ZmqMsgRec.Close(vMsgSend)

        Deallocate(lpszSendBufferPtr)

        Sleep(1)

        ZmqMsgRec.Init(vMsgRecv)

        If ZmqMsgRec.Recv(vMsgRecv, Socket, 0) > 0 Then
            Dim lpszRecvBufferSize As Long = ZmqMsgRec.Size(vMsgRecv)
            Dim lpszRecvBufferPtr As ZString Ptr = CAllocate(lpszRecvBufferSize)

            MemCpy(lpszRecvBufferPtr, ZmqMsgRec.Data(vMsgRecv), lpszRecvBufferSize)

            Print("Reply From Server: ")
            Print(*CPtr(ZString Ptr, lpszRecvBufferPtr))

            Deallocate(lpszRecvBufferPtr)
        End If

        ZmqMsgRec.Close(vMsgRecv)
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