'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Pragma Once

Declare Function ZmqPoll(Byval dllInstance As Any Ptr, Byval items As ZmqPollItemT Ptr, Byval nitems As Long, Byval timeout As Clong) As Long

Function ZmqPoll(Byval dllInstance As Any Ptr, Byval items As ZmqPollItemT Ptr, Byval nitems As Long, Byval timeout As Clong) As Long
    Dim lResult As Long

    If ZmqApiEnsure(dllInstance) And (g_ZmqApi.Poll > 0) Then
        lResult = g_ZmqApi.Poll(items, nitems, timeout)
    End If

    Function = lResult
End Function
