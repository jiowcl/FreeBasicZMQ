'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Pragma Once

' Declare Function
Declare Function ZmqZ85Encode(Byval dllInstance As Any Ptr, Byval dest As Any Ptr, Byval data_ As Any Ptr, Byval size As UInteger) As Any Ptr
Declare Function ZmqZ85Decode(Byval dllInstance As Any Ptr, Byval dest As Any Ptr, Byval string_ As Const ZString Ptr) As Any Ptr
Declare Function ZmqZ85EncodeStr(Byval dllInstance As Any Ptr, Byval data_ As Any Ptr, Byval size As UInteger) As String
Declare Function ZmqZ85DecodeStr(Byval dllInstance As Any Ptr, Byval string_ As String, Byval dest As Any Ptr, Byval destSize As UInteger) As Any Ptr
Declare Function ZmqCurveKeypair(Byval dllInstance As Any Ptr, Byval z85Public As Any Ptr, Byval z85Secret As Any Ptr) As Long
Declare Function ZmqCurvePublic(Byval dllInstance As Any Ptr, Byval z85Public As Any Ptr, Byval z85Secret As Const ZString Ptr) As Long
Declare Function ZmqCurvePublicStr(Byval dllInstance As Any Ptr, Byval z85Secret As String) As String

' Zmq Function Declare

' <summary>
' ZmqZ85Encode
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="dest">Ptr</param>
' <param name="data_">Ptr</param>
' <param name="size">UInteger</param>
' <returns>Returns any ptr.</returns>
Function ZmqZ85Encode(Byval dllInstance As Any Ptr, Byval dest As Any Ptr, Byval data_ As Any Ptr, Byval size As UInteger) As Any Ptr
    Dim lResult As Any Ptr
    Dim pFuncCall As Function(Byval dest As Any Ptr, Byval data_ As Any Ptr, Byval size As UInteger) As Any Ptr

    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_z85_encode")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(dest, data_, size)
        End If
    End If

    Function = lResult
End Function

' <summary>
' ZmqZ85Decode
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="dest">Ptr</param>
' <param name="string_">Const ZString Ptr</param>
' <returns>Returns any ptr.</returns>
Function ZmqZ85Decode(Byval dllInstance As Any Ptr, Byval dest As Any Ptr, Byval string_ As Const ZString Ptr) As Any Ptr
    Dim lResult As Any Ptr
    Dim pFuncCall As Function(Byval dest As Any Ptr, Byval string_ As Const ZString Ptr) As Any Ptr

    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_z85_decode")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(dest, string_)
        End If
    End If

    Function = lResult
End Function

' <summary>
' ZmqZ85EncodeStr
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="data_">Ptr</param>
' <param name="size">UInteger</param>
' <returns>Returns string.</returns>
Function ZmqZ85EncodeStr(Byval dllInstance As Any Ptr, Byval data_ As Any Ptr, Byval size As UInteger) As String
    Dim lResult As String
    Dim destSize As UInteger
    Dim dest As Any Ptr

    If (size <= 0) Or ((size Mod 4) <> 0) Then
        Function = ""
        Exit Function
    End If

    destSize = ((size * 5) \ 4) + 1
    dest = Allocate(destSize)

    If (dest > 0) Then
        If (ZmqZ85Encode(dllInstance, dest, data_, size) > 0) Then
            lResult = *Cast(ZString Ptr, dest)
        End If

        Deallocate(dest)
    End If

    Function = lResult
End Function

' <summary>
' ZmqZ85DecodeStr
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="string_">String</param>
' <param name="dest">Ptr</param>
' <param name="destSize">UInteger</param>
' <returns>Returns any ptr.</returns>
Function ZmqZ85DecodeStr(Byval dllInstance As Any Ptr, Byval string_ As String, Byval dest As Any Ptr, Byval destSize As UInteger) As Any Ptr
    Dim needSize As UInteger = (Len(string_) * 4) \ 5

    If (needSize <= 0) Or (destSize < needSize) Or (dest = 0) Then
        Function = 0
        Exit Function
    End If

    Function = ZmqZ85Decode(dllInstance, dest, StrPtr(string_))
End Function

' <summary>
' ZmqCurveKeypair
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="z85Public">Ptr</param>
' <param name="z85Secret">Ptr</param>
' <returns>Returns long.</returns>
Function ZmqCurveKeypair(Byval dllInstance As Any Ptr, Byval z85Public As Any Ptr, Byval z85Secret As Any Ptr) As Long
    Dim lResult As Long = -1
    Dim pFuncCall As Function(Byval z85Public As Any Ptr, Byval z85Secret As Any Ptr) As Long

    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_curve_keypair")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(z85Public, z85Secret)
        End If
    End If

    Function = lResult
End Function

' <summary>
' ZmqCurvePublic
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="z85Public">Ptr</param>
' <param name="z85Secret">Const ZString Ptr</param>
' <returns>Returns long.</returns>
Function ZmqCurvePublic(Byval dllInstance As Any Ptr, Byval z85Public As Any Ptr, Byval z85Secret As Const ZString Ptr) As Long
    Dim lResult As Long = -1
    Dim pFuncCall As Function(Byval z85Public As Any Ptr, Byval z85Secret As Const ZString Ptr) As Long

    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_curve_public")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(z85Public, z85Secret)
        End If
    End If

    Function = lResult
End Function

' <summary>
' ZmqCurvePublicStr
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="z85Secret">String</param>
' <returns>Returns string.</returns>
Function ZmqCurvePublicStr(Byval dllInstance As Any Ptr, Byval z85Secret As String) As String
    Dim lResult As String
    Dim z85Public As Any Ptr = Allocate(ZMQ_CURVE_KEYSIZE_Z85 + 1)

    If (z85Public > 0) Then
        If (ZmqCurvePublic(dllInstance, z85Public, StrPtr(z85Secret)) = 0) Then
            lResult = *Cast(ZString Ptr, z85Public)
        End If

        Deallocate(z85Public)
    End If

    Function = lResult
End Function
