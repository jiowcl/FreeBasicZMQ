'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Pragma Once

' Declare Function
Declare Function ZmqPoll(Byval dllInstance As Any Ptr, Byval items As ZmqPollItemT Ptr, Byval nitems As Long, Byval timeout As Clong) As Long

' Zmq Function Declare

' <summary>
' ZmqPoll
' </summary>
' <param name="dllInstance">Ptr</param>
' <param name="items">ZmqPollItemT Ptr</param>
' <param name="nitems">Long</param>
' <param name="timeout">Clong</param>
' <returns>Returns long.</returns>
Function ZmqPoll(Byval dllInstance As Any Ptr, Byval items As ZmqPollItemT Ptr, Byval nitems As Long, Byval timeout As Clong) As Long
    Dim lResult As Long
    Dim pFuncCall As Function(Byval items As ZmqPollItemT Ptr, Byval nitems As Long, Byval timeout As Clong) As Long

    If (dllInstance > 0) Then
        pFuncCall = DyLibSymbol(dllInstance, "zmq_poll")

        If (pFuncCall > 0) Then
            lResult = pFuncCall(items, nitems, timeout)
        End If
    End If

    Function = lResult
End Function
