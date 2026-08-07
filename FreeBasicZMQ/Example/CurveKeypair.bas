'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

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

Dim hLibrary As Any Ptr = ZmqDllOpen(lpszLibZmqDll)

If hLibrary > 0 Then
    If ZmqHas(hLibrary, "curve") = 0 Then
        Print("libzmq was built without CURVE support (zmq_has(""curve"") = 0).")
    Else
        Dim lpszPublic As ZString * (ZMQ_CURVE_KEYSIZE_Z85 + 1)
        Dim lpszSecret As ZString * (ZMQ_CURVE_KEYSIZE_Z85 + 1)
        Dim lpszDerived As String

        If ZmqCurveKeypair(hLibrary, @lpszPublic, @lpszSecret) = 0 Then
            lpszDerived = ZmqCurvePublicStr(hLibrary, lpszSecret)

            Print("Public Key : " & lpszPublic)
            Print("Secret Key : " & lpszSecret)
            Print("Derived Pub: " & lpszDerived)

            If lpszPublic = lpszDerived Then
                Print("CurvePublic matches CurveKeypair public key.")
            End If
        Else
            Print("CurveKeypair failed: " & *ZmqStrerror(hLibrary, ZmqErrno(hLibrary)))
        End If
    End If

    ZmqDllClose(hLibrary)
End If

Print("Press any key to continue...")
Sleep()
