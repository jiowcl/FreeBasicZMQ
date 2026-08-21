'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Pragma Once

Declare Function ZmqProxy(Byval dllInstance As Any Ptr, Byval frontend As Any Ptr, Byval backend As Any Ptr, Byval capture As Any Ptr) As Long
Declare Function ZmqProxySteerable(Byval dllInstance As Any Ptr, Byval frontend As Any Ptr, Byval backend As Any Ptr, Byval capture As Any Ptr, Byval control As Any Ptr) As Long

Function ZmqProxy(Byval dllInstance As Any Ptr, Byval frontend As Any Ptr, Byval backend As Any Ptr, Byval capture As Any Ptr) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.Proxy > 0) Then
        lResult = g_ZmqApi.Proxy(frontend, backend, capture)
    End If

    Function = lResult
End Function

Function ZmqProxySteerable(Byval dllInstance As Any Ptr, Byval frontend As Any Ptr, Byval backend As Any Ptr, Byval capture As Any Ptr, Byval control As Any Ptr) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.ProxySteerable > 0) Then
        lResult = g_ZmqApi.ProxySteerable(frontend, backend, capture, control)
    End If

    Function = lResult
End Function
