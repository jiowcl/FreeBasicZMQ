'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Include "crt/string.bi"
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
        Dim vMsgRecv As ZmqMsgT Ptr

        ZmqMsgInit(dllInstance, vMsgRecv)

        If ZmqMsgRecv(dllInstance, vMsgRecv, Socket, 0) > 0 Then
            Print("Received: " & *CPtr(ZString Ptr, ZmqMsgData(dllInstance, vMsgRecv)))
        End If

        ZmqMsgClose(dllInstance, vMsgRecv)

        Sleep(1)

        Dim vMsgSend As ZmqMsgT Ptr
        Dim lpszSendMessage As String = "Hi"

        ZmqMsgInitSize(dllInstance, vMsgSend, Len(lpszSendMessage))

        MemCpy(ZmqMsgData(dllInstance, vMsgSend), StrPtr(lpszSendMessage), Len(lpszSendMessage))

        ZmqMsgSend(dllInstance, vMsgSend, Socket, 0)
        ZmqMsgClose(dllInstance, vMsgSend)
    Wend
End Sub

' Req Client
Sub TestZmqThreadReqProc(Byval vData As Any Ptr)
    Dim dllInstance As Any Ptr = hZmqLibrary.dllInstance
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

        ZmqMsgInitSize(dllInstance, vMsgSend, lpszSendMessageSize)

        MemCpy(ZmqMsgData(dllInstance, vMsgSend), lpszSendBufferPtr, lpszSendMessageSize)

        ZmqMsgSend(dllInstance, vMsgSend, Socket, 0)
        ZmqMsgClose(dllInstance, vMsgSend)

        Deallocate(lpszSendBufferPtr)

        Sleep(1)

        ZmqMsgInit(dllInstance, vMsgRecv)

        If ZmqMsgRecv(dllInstance, vMsgRecv, Socket, 0) > 0 Then
            Dim lpszRecvBufferSize As Long = ZmqMsgSize(dllInstance, vMsgRecv)
            Dim lpszRecvBufferPtr As ZString Ptr = CAllocate(lpszRecvBufferSize)

            MemCpy(lpszRecvBufferPtr, ZmqMsgData(dllInstance, vMsgRecv), lpszRecvBufferSize)

            Print("Reply From Server: ")
            Print(*CPtr(ZString Ptr, lpszRecvBufferPtr))

            Deallocate(lpszRecvBufferPtr)
        End If

        ZmqMsgClose(dllInstance, vMsgRecv)
    Next
End Sub

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