'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Pragma Once

' Declare Function
Declare Function ZmqProxy(Byval dllInstance As Any Ptr, Byval frontend As Any Ptr, Byval backend As Any Ptr, Byval capture As Any Ptr) As Long
Declare Function ZmqProxySteerable(Byval dllInstance As Any Ptr, Byval frontend As Any Ptr, Byval backend As Any Ptr, Byval capture As Any Ptr, Byval control As Any Ptr) As Long

' Zmq Function Declare

' <summary>
' ZmqProxy
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="frontend">Ptr</param>
' <param name="backend">Ptr</param>
' <param name="capture">Ptr</param>
' <returns>Returns long.</returns>
Function ZmqProxy(Byval dllInstance As Any Ptr, Byval frontend As Any Ptr, Byval backend As Any Ptr, Byval capture As Any Ptr) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byval frontend As Any Ptr, Byval backend As Any Ptr, Byval capture As Any Ptr) As Long

    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_proxy")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(frontend, backend, capture)
        End If
    End If

    Function = lResult
End Function

' <summary>
' ZmqProxySteerable
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="frontend">Ptr</param>
' <param name="backend">Ptr</param>
' <param name="capture">Ptr</param>
' <param name="control">Ptr</param>
' <returns>Returns long.</returns>
Function ZmqProxySteerable(Byval dllInstance As Any Ptr, Byval frontend As Any Ptr, Byval backend As Any Ptr, Byval capture As Any Ptr, Byval control As Any Ptr) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byval frontend As Any Ptr, Byval backend As Any Ptr, Byval capture As Any Ptr, Byval control As Any Ptr) As Long

    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_proxy_steerable")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(frontend, backend, capture, control)
        End If
    End If

    Function = lResult
End Function
