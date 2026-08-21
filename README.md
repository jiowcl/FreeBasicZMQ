# FreeBasicZMQ

ZMQ Wrapper for FreeBasic Programming Language.

![GitHub](https://img.shields.io/github/license/jiowcl/FreeBasicZMQ.svg)
![FreeBasic](https://img.shields.io/badge/language-FreeBasic-blue.svg)
![Dependency](https://img.shields.io/badge/ZeroMQ-libzmq-FF6600?style=flat-square&logo=zeromq&logoColor=white)

## Environment

- Windows 7 above (recommend)  
- FreeBasic 1.10.1 above (recommend)  
- [ZeroMQ](https://github.com/zeromq) / libzmq **4.3.6** (binding targets this API)

## How to Build

Building requires FreeBasic Compiler (tested under Windows 10/11).  

```bash
fbc Example/PubServer.bas -target win64
```

## Running Examples

1. Set the process working directory to the package root that contains `Core/`, `Example/`, and `Library/` (for example `FreeBasicZMQ/FreeBasicZMQ`).
2. Examples load `Library/x64/libzmq.dll` or `Library/x86/libzmq.dll` (and `libsodium.dll` when present) via `Chdir` into that folder.
3. Prefer `fbc64.exe` for x64 binaries so the x64 DLL is used.

### Pub / Sub start order

1. Start **Pub** first (`PubServer`, `WeatherPubServer`, …).
2. Wait for the bind message (publishers also pause ~200 ms for the slow-joiner case).
3. Start **Sub** (`SubClient`, `WeatherSubClient`, …).
4. Subscribers call `ZMQ_SUBSCRIBE` **before** `Connect`.

### Capability Probe (`zmq_has`)

Run `Example/Has.bas` (or `Example/Module/Has.bas`) after loading the DLL:

| Capability string | Meaning |
|-------------------|--------|
| `ipc` | IPC transport |
| `curve` | CURVE security (`zmq_curve_*`) |
| `draft` | Draft API build |
| `pgm` / `norm` / `tipc` / … | Optional transports (if compiled in) |

The bundled Windows `libzmq.dll` may report **`curve=0`**. CURVE helpers are still bound; use a CURVE-enabled libzmq (typically linked with libsodium) for `Curve` / `CurveKeypair` demos to succeed. DLL symbols are resolved once on open (`Core/Symbols.bi`).

## Example (PUB / SUB)

Publisher Server

```bash
fbc Example/PubServer.bas -target win64
```

```freebasic
#Include "Core/Enums.bi"
#Include "Core/ZeroMQWrapper.bi"

Dim lpszLibZmqDll As String = "libzmq.dll"

Function RndRange(Byval first As Double, Byval last As Double) As Double
    Function = Rnd * (last - first) + first
End Function

Const lpszServerAddr As String = "tcp://*:1689"

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
        Sleep(200)
        Randomize

        While 1
            Dim lpszTopic As String = "quotes"
            Dim lpszSendMessage As String = "Bid:" & Str(CInt(RndRange(1000, 9000))) & ",Ask:" & Str(CInt(RndRange(1000, 9000)))

            If ZmqSocketRec.Send(Socket, StrPtr(lpszTopic), Len(lpszTopic), ZMQ_SNDMORE) = -1 Then
                Print("Send topic failed: " & *ZmqRuntimeRec.Strerror(ZmqRuntimeRec.Errno()))
            ElseIf ZmqSocketRec.Send(Socket, StrPtr(lpszSendMessage), Len(lpszSendMessage), 0) = -1 Then
                Print("Send message failed: " & *ZmqRuntimeRec.Strerror(ZmqRuntimeRec.Errno()))
            Else
                Print("Published: " & lpszSendMessage)
            End If

            Sleep(100)
        Wend
    End If

    ZmqSocketRec.Close(Socket)
    ZmqContextRec.Shutdown(Context)
    LibZMQWrapper.DllClose()
End If
```

Subscribe Client

```bash
fbc Example/SubClient.bas -target win64
```

```freebasic
#Include "Core/Enums.bi"
#Include "Core/ZeroMQWrapper.bi"

Dim lpszLibZmqDll As String = "libzmq.dll"
Const lpszServerAddr As String = "tcp://localhost:1689"

Dim ZmqContextRec As LibZmqContext
Dim ZmqSocketRec As LibZmqSocket
Dim ZmqRuntimeRec As LibZmqRuntime

If LibZMQWrapper.DllOpen(lpszLibZmqDll) Then
    Dim Context As Any Ptr = ZmqContextRec.NewCtx()
    Dim Socket As Any Ptr = ZmqSocketRec.Socket(Context, ZMQ_SUB)
    Dim lpszSubscribe As String = "quotes"
    Dim Rc As Long

    ZmqSocketRec.Setsockopt(Socket, ZMQ_SUBSCRIBE, StrPtr(lpszSubscribe), Len(lpszSubscribe))
    Rc = ZmqSocketRec.Connect(Socket, lpszServerAddr)

    If Rc <> 0 Then
        Print("Connect failed: " & *ZmqRuntimeRec.Strerror(ZmqRuntimeRec.Errno()))
    Else
        Print("Connected: " & lpszServerAddr & " (subscribe=" & lpszSubscribe & ")")

        While 1
            Dim lpszTopicBuffer As ZString * 256
            Dim lpszRecvBuffer As ZString * 256
            Dim TopicBytes As Long
            Dim MessageBytes As Long

            TopicBytes = ZmqSocketRec.Recv(Socket, @lpszTopicBuffer, SizeOf(lpszTopicBuffer), 0)

            If TopicBytes <> -1 Then
                MessageBytes = ZmqSocketRec.Recv(Socket, @lpszRecvBuffer, SizeOf(lpszRecvBuffer), 0)
                If MessageBytes <> -1 Then
                    Print(Left(lpszRecvBuffer, MessageBytes))
                End If
            End If
        Wend
    End If

    ZmqSocketRec.Close(Socket)
    ZmqContextRec.Shutdown(Context)
    LibZMQWrapper.DllClose()
End If
```

## Examples  

| Example | Pattern | Notes |
|---------|---------|--------|
| `Zmq` / `Has` | Version / `zmq_has` / sockopt | Smoke / capability |
| `PubServer` + `SubClient` | PUB/SUB multipart | Port **1689**, topic `quotes` |
| `Weather/*` + `Module/Weather*` | PUB/SUB weather | Port **1692**, simulated updates (no HTTP API) |
| `ReqClient` + `RepServer` | REQ/REP | |
| `Plain` | PLAIN + ZAP | Port **1720**, user `admin` / `secret` |
| `Curve` / `CurveKeypair` | CURVE | Needs `zmq_has("curve")=1` |
| `Poll` / `Proxy` / `Monitor` | Poll, steerable proxy, monitor | |
| `Z85` | Z85 encode/decode | |
| `Msg` / `Thread` / `Stopwatch` | Msg API / helpers | |

Each major sample has a procedural copy under `Example/` and an OOP twin under `Example/Module/`.

## License

Copyright (c) 2017-2026 Ji-Feng Tsai.  
Code released under the MIT license.  

## TODO

- Optional: atomic counters / timers  
- Optional: draft APIs (gated)  

## Donation

If this application help you reduce time to coding, you can give me a cup of coffee :)

[![paypal](https://www.paypalobjects.com/en_US/TW/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=3RNMD6Q3B495N&source=url)

[Paypal Me](https://paypal.me/jiowcl?locale.x=zh_TW)
