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

' Rnd with Range
' Source Code from: https://documentation.help/FreeBASIC/KeyPgRnd.html
Function RndRange(Byval first As Double, Byval last As Double) As Double
    Function = Rnd * (last - first) + first
End Function

Const lpszServerAddr As String = "tcp://*:1689"

Dim ZmqContextRec As LibZmqContext
Dim ZmqSocketRec As LibZmqSocket
Dim ZmqHelperRec As LibZmqHelper

If LibZMQWrapper.DllOpen(lpszLibZmqDll) Then
    Dim Context As Any Ptr = ZmqContextRec.NewCtx()
    Dim Socket As Any Ptr = ZmqSocketRec.Socket(Context, ZMQ_PUB)
    Dim Rc As Long = ZmqSocketRec.Bind(Socket, lpszServerAddr)

    Print("Bind an IP address: " & lpszServerAddr)

    Randomize
    
    While 1
        Dim lpszRecvBufferPtr As Any Ptr = CAllocate(32)
        Dim lpszSendBufferPtr As ZString Ptr
        Dim lpszTopicBufferPtr As ZString Ptr
        Dim lpszTopic As String = "quotes"
        Dim lpszSendMessage As String = "Bid: " & Str(RndRange(9000, 1000)) & ",Ask:" + Str(RndRange(9000, 1000))

        ZmqSocketRec.Recv(Socket, lpszRecvBufferPtr, 32, 0)
        
        Sleep(2)
        
        Dim lpszReturnMessage As String = *CPtr(Zstring Ptr, lpszRecvBufferPtr)
        
        If lpszReturnMessage <> "" Then
            Print("Received: ")
            Print(lpszReturnMessage)
        End If

        lpszTopicBufferPtr = CAllocate(Len(lpszTopic), SizeOfDefZStringPtr(lpszTopicBufferPtr))
        *lpszTopicBufferPtr = lpszTopic
        
        lpszSendBufferPtr = CAllocate(Len(lpszSendMessage), SizeOfDefZStringPtr(lpszSendBufferPtr))
        *lpszSendBufferPtr = lpszSendMessage

        ZmqSocketRec.Send(Socket, lpszTopicBufferPtr, Len(lpszTopic), ZMQ_SNDMORE)
        ZmqSocketRec.Send(Socket, lpszSendBufferPtr, Len(lpszSendMessage), 0)

        Deallocate(lpszRecvBufferPtr) 
        Deallocate(lpszSendBufferPtr) 
        Deallocate(lpszTopicBufferPtr) 

        lpszRecvBufferPtr = 0
        lpszSendBufferPtr = 0
        lpszTopicBufferPtr = 0
    Wend
    
    ZmqSocketRec.Close(Socket)
    ZmqContextRec.Shutdown(Context)
    
    LibZMQWrapper.DllClose()
End If