'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

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

Dim ZmqSecurityRec As LibZmqSecurity
Dim ZmqRuntimeRec As LibZmqRuntime

If LibZMQWrapper.DllOpen(lpszLibZmqDll) Then
    If ZmqRuntimeRec.Has("curve") = 0 Then
        Print("libzmq was built without CURVE support (zmq_has(""curve"") = 0).")
    Else
        Dim lpszPublic As ZString * (ZMQ_CURVE_KEYSIZE_Z85 + 1)
        Dim lpszSecret As ZString * (ZMQ_CURVE_KEYSIZE_Z85 + 1)
        Dim lpszDerived As String

        If ZmqSecurityRec.CurveKeypair(@lpszPublic, @lpszSecret) = 0 Then
            lpszDerived = ZmqSecurityRec.CurvePublicStr(lpszSecret)

            Print("Public Key : " & lpszPublic)
            Print("Secret Key : " & lpszSecret)
            Print("Derived Pub: " & lpszDerived)

            If lpszPublic = lpszDerived Then
                Print("CurvePublic matches CurveKeypair public key.")
            End If
        Else
            Print("CurveKeypair failed: " & *ZmqRuntimeRec.Strerror(ZmqRuntimeRec.Errno()))
        End If
    End If

    LibZMQWrapper.DllClose()
End If

Print("Press any key to continue...")
Sleep()
