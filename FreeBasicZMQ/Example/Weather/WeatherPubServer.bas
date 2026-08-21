'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------
' Classic PUB/SUB weather demo (simulated updates; no external HTTP API).

#Include "../../Core/ZeroMQ.bi"

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

Dim hLibrary As Any Ptr = ZmqDllOpen(lpszLibZmqDll)

If hLibrary > 0 Then
    Dim Context As Any Ptr = ZmqCtxNew(hLibrary)
    Dim Socket As Any Ptr = ZmqSocket(hLibrary, Context, ZMQ_PUB)
    Dim Rc As Long = ZmqBind(hLibrary, Socket, lpszServerAddr)

    If Rc <> 0 Then
        Print("Bind failed: " & *ZmqStrerror(hLibrary, ZmqErrno(hLibrary)))
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

            If ZmqSend(hLibrary, Socket, StrPtr(lpszTopic), Len(lpszTopic), ZMQ_SNDMORE) = -1 Then
                Print("Send topic failed: " & *ZmqStrerror(hLibrary, ZmqErrno(hLibrary)))
            ElseIf ZmqSend(hLibrary, Socket, StrPtr(lpszPayload), Len(lpszPayload), 0) = -1 Then
                Print("Send message failed: " & *ZmqStrerror(hLibrary, ZmqErrno(hLibrary)))
            Else
                Print("Published: " & lpszPayload)
            End If

            Sleep(1000)
        Wend
    End If

    ZmqClose(hLibrary, Socket)
    ZmqCtxShutdown(hLibrary, Context)
    ZmqDllClose(hLibrary)
End If
