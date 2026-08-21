'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Include "../../Core/Enums.bi"
#Include "../../Core/ZeroMQWrapper.bi"

Dim lpszCurrentDir As String = Curdir()

#ifdef __FB_64BIT__
    Dim lpszLibZmqDir As String = "/Library/x64"
    Dim lpszLibZmqDll As String = lpszCurrentDir & lpszLibZmqDir & "/libzmq.dll"
    Chdir(lpszCurrentDir & lpszLibZmqDir)
#else
    Dim lpszLibZmqDir As String = "/Library/x86"
    Dim lpszLibZmqDll As String = lpszCurrentDir & lpszLibZmqDir & "/libzmq.dll"
    Chdir(lpszCurrentDir & lpszLibZmqDir)
#endif

Function RndRange(Byval first As Double, Byval last As Double) As Double
    Function = Rnd * (last - first) + first
End Function

Const lpszServerAddr As String = "tcp://*:1692"

Dim ZmqContextRec As LibZmqContext
Dim ZmqSocketRec As LibZmqSocket
Dim ZmqRuntimeRec As LibZmqRuntime

If LibZMQWrapper.DllOpen(lpszLibZmqDll) Then
    Dim Context As Any Ptr = ZmqContextRec.NewCtx()
    Dim Socket As Any Ptr = ZmqSocketRec.Socket(Context, ZMQ_PUB)
    Dim Rc As Long = ZmqSocketRec.Bind(Socket, lpszServerAddr)

    If Rc <> 0 Then
        Print("Bind failed: " & *ZmqRuntimeRec.Strerror(ZmqRuntimeRec.Errno()))
    Else
        Print("Bind an IP address: " & lpszServerAddr)
        Print("Publishing simulated weather updates (topic=weather). Start WeatherSubClient next.")

        Sleep(200)
        Randomize

        While 1
            Dim lpszTopic As String = "weather"
            Dim zipcode As Long = CInt(RndRange(10000, 99999))
            Dim temperature As Long = CInt(RndRange(-10, 35))
            Dim humidity As Long = CInt(RndRange(10, 90))
            Dim lpszPayload As String = "zip=" & zipcode & " temp=" & temperature & "C humidity=" & humidity & "%"

            If ZmqSocketRec.Send(Socket, StrPtr(lpszTopic), Len(lpszTopic), ZMQ_SNDMORE) = -1 Then
                Print("Send topic failed: " & *ZmqRuntimeRec.Strerror(ZmqRuntimeRec.Errno()))
            ElseIf ZmqSocketRec.Send(Socket, StrPtr(lpszPayload), Len(lpszPayload), 0) = -1 Then
                Print("Send message failed: " & *ZmqRuntimeRec.Strerror(ZmqRuntimeRec.Errno()))
            Else
                Print("Published: " & lpszPayload)
            End If

            Sleep(1000)
        Wend
    End If

    ZmqSocketRec.Close(Socket)
    ZmqContextRec.Shutdown(Context)
    LibZMQWrapper.DllClose()
End If
