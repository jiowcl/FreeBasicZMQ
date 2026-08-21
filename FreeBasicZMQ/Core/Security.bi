'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Pragma Once

Declare Function ZmqZ85Encode(Byval dllInstance As Any Ptr, Byval dest As Any Ptr, Byval data_ As Any Ptr, Byval size As UInteger) As Any Ptr
Declare Function ZmqZ85Decode(Byval dllInstance As Any Ptr, Byval dest As Any Ptr, Byval string_ As Const ZString Ptr) As Any Ptr
Declare Function ZmqZ85EncodeStr(Byval dllInstance As Any Ptr, Byval data_ As Any Ptr, Byval size As UInteger) As String
Declare Function ZmqZ85DecodeStr(Byval dllInstance As Any Ptr, Byval string_ As String, Byval dest As Any Ptr, Byval destSize As UInteger) As Any Ptr
Declare Function ZmqCurveKeypair(Byval dllInstance As Any Ptr, Byval z85Public As Any Ptr, Byval z85Secret As Any Ptr) As Long
Declare Function ZmqCurvePublic(Byval dllInstance As Any Ptr, Byval z85Public As Any Ptr, Byval z85Secret As Const ZString Ptr) As Long
Declare Function ZmqCurvePublicStr(Byval dllInstance As Any Ptr, Byval z85Secret As String) As String

Function ZmqZ85Encode(Byval dllInstance As Any Ptr, Byval dest As Any Ptr, Byval data_ As Any Ptr, Byval size As UInteger) As Any Ptr
    Dim lResult As Any Ptr

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.Z85Encode > 0) Then
        lResult = g_ZmqApi.Z85Encode(dest, data_, size)
    End If

    Function = lResult
End Function

Function ZmqZ85Decode(Byval dllInstance As Any Ptr, Byval dest As Any Ptr, Byval string_ As Const ZString Ptr) As Any Ptr
    Dim lResult As Any Ptr

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.Z85Decode > 0) Then
        lResult = g_ZmqApi.Z85Decode(dest, string_)
    End If

    Function = lResult
End Function

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

Function ZmqZ85DecodeStr(Byval dllInstance As Any Ptr, Byval string_ As String, Byval dest As Any Ptr, Byval destSize As UInteger) As Any Ptr
    Dim needSize As UInteger = (Len(string_) * 4) \ 5

    If (needSize <= 0) Or (destSize < needSize) Or (dest = 0) Then
        Function = 0
        Exit Function
    End If

    Function = ZmqZ85Decode(dllInstance, dest, StrPtr(string_))
End Function

Function ZmqCurveKeypair(Byval dllInstance As Any Ptr, Byval z85Public As Any Ptr, Byval z85Secret As Any Ptr) As Long
    Dim lResult As Long = -1

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.CurveKeypair > 0) Then
        lResult = g_ZmqApi.CurveKeypair(z85Public, z85Secret)
    End If

    Function = lResult
End Function

Function ZmqCurvePublic(Byval dllInstance As Any Ptr, Byval z85Public As Any Ptr, Byval z85Secret As Const ZString Ptr) As Long
    Dim lResult As Long = -1

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.CurvePublic > 0) Then
        lResult = g_ZmqApi.CurvePublic(z85Public, z85Secret)
    End If

    Function = lResult
End Function

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
