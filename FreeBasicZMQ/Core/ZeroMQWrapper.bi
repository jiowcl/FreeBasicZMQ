'--------------------------------------------------------------------------------------------
'  Copyright (c) Ji-Feng Tsai. All rights reserved.
'  Code released under the MIT license.
'--------------------------------------------------------------------------------------------

#Include Once "crt/long.bi"
#Include Once "crt/longdouble.bi"

#Include Once "LibDll.bi"
#Include Once "Enums.bi"
#Include Once "Runtime.bi"
#Include Once "Context.bi"
#Include Once "Socket.bi"
#Include Once "Helper.bi"

' Declare Enum LIB_WRAPPER
Enum LIB_WRAPPER
    OPT_DLLOPEN  = 1
    OPT_DLLCLOSE = 2
    OPT_DLLLOAD  = 3
End Enum

' Declare Type LibZMQWrapper
Type LibZMQWrapper
public:
    Declare Static Function DllOpen(Byval lpszDllPath As String) As Any Ptr
    Declare Static Function DllClose() As Boolean
    Declare Static Function DllInstance() As Any Ptr
private:
    Declare Static Function Instance(Byval Opt As Integer, Byval lpszDllPath As String = "") As Any Ptr
    Dim As Integer ErrorCode
End Type

' Declare Type LibZmqContext
Type LibZmqContext Extends LibZMQWrapper
public:
    Declare Function NewCtx() As Any Ptr
    Declare Function Term(Byval context As Any Ptr) As Long
    Declare Function Shutdown(Byval context As Any Ptr) As Long
    Declare Function Set(Byval context As Any Ptr, Byval options As Long, Byval optval As Long) As Long
    Declare Function Get(Byval context As Any Ptr, Byval options As Long) As Long
End Type

' Declare Type LibZmqSocket
Type LibZmqSocket Extends LibZMQWrapper
public:
    Declare Function Socket(Byval s As Any Ptr, Byval stype As Long) As Any Ptr
    Declare Function Bind(Byval socket_ As Any Ptr, Byval addr As ZString Ptr) As Long
    Declare Function UnBind(Byval socket_ As Any Ptr, Byval addr As ZString Ptr) As Long
    Declare Function Recv(Byval socket_ As Any Ptr, Byval buf As Any Ptr, Byval buflen As Uinteger, Byval flags As Long) As Long
    Declare Function Send(Byval socket_ As Any Ptr, Byval buf As Any Ptr, Byval buflen As Uinteger, Byval flags As Long) As Long
    Declare Function SendConst(Byval socket_ As Any Ptr, Byval buf As Any Ptr, Byval buflen As Uinteger, Byval flags As Long) As Long
    Declare Function Connect(Byval socket_ As Any Ptr, Byval addr As ZString Ptr) As Long
    Declare Function DisConnect(Byval socket_ As Any Ptr, Byval addr As ZString Ptr) As Long
    Declare Function Setsockopt(Byval socket_ As Any Ptr, Byval options As Long, Byval optval As Any Ptr, Byval optvallen As Uinteger) As Long
    Declare Function Getsockopt(Byval socket_ As Any Ptr, Byval options As Long, Byref optval As String, Byval optvallen As Uinteger) As Long
    Declare Function Close(Byval socket_ As Any Ptr) As Long
End Type

' Declare Type LibZmqHelper
Type LibZmqHelper Extends LibZMQWrapper
public:
    Declare Function StopwatchStart() As Any Ptr
    Declare Function StopwatchIntermediate(Byval watch_ As Any Ptr) As Culong
    Declare Function StopwatchStop(Byval watch_ As Any Ptr) As CUlong
    Declare Sub Sleep(Byval seconds_ As Long)
    Declare Function Threadstart(Byval func_ As Sub(Byval As Any Ptr), Byval arg_ As Any Ptr) As Any Ptr
    Declare Sub Threadclose(Byval thread_ As Any Ptr)
End Type

' Type LibZMQWrapper

' <summary>
' DllOpen
' </summary>
' <param name="lpszDllPath"></param>
' <returns>Returns any ptr.</returns>
Static Function LibZMQWrapper.DllOpen(Byval lpszDllPath As String) As Any Ptr
    Function = LibZMQWrapper.Instance(LIB_WRAPPER.OPT_DLLOPEN, lpszDllPath)
End Function

' <summary>
' DllClose
' </summary>
' <returns>Returns boolean.</returns>
Static Function LibZMQWrapper.DllClose() As Boolean
    Function = False

    If (LibZMQWrapper.Instance(LIB_WRAPPER.OPT_DLLCLOSE) = 0) Then
        Function = True
    End If
End Function

' <summary>
' DllInstance
' </summary>
' <returns>Returns any ptr.</returns>
Static Function LibZMQWrapper.DllInstance() As Any Ptr
    Function = LibZMQWrapper.Instance(LIB_WRAPPER.OPT_DLLLOAD)
End Function

' <summary>
' Instance
' </summary>
' <returns>Returns any ptr.</returns>
Static Function LibZMQWrapper.Instance(Byval Opt As Integer, Byval lpszDllPath As String = "") As Any Ptr
    Static LibDllPath As String
    Static LibDllInstancePtr As Any Ptr

    If (Opt = LIB_WRAPPER.OPT_DLLOPEN) Then
        If (Len(LibDllPath) = 0) Then
            If (Len(lpszDllPath) > 0) Then
                LibDllPath = lpszDllPath
            End If

            If (LibDllInstancePtr = 0) Then
                LibDllInstancePtr = DyLibLoad(lpszDllPath)
            End If
        End If
    End If

    If (Opt = LIB_WRAPPER.OPT_DLLCLOSE) Then
        If (LibDllInstancePtr > 0) Then
            DyLibFree(LibDllInstancePtr)

            LibDllPath = ""
            LibDllInstancePtr = 0
        End If
    End If

    If (Opt = LIB_WRAPPER.OPT_DLLLOAD) Then

    End If

    Function = LibDllInstancePtr
End Function

' Type LibZmqContext
  
' <summary>
' NewCtx
' </summary>
' <returns>Returns any ptr.</returns>
Function LibZmqContext.NewCtx() As Any Ptr
    Function = ZmqCtxNew(LibZMQWrapper.DllInstance())
End Function
  
' <summary>
' Term
' </summary>
' <param name="context"></param>
' <returns>Returns long.</returns>
Function LibZmqContext.Term(byval context As Any Ptr) As Long
    Function = ZmqCtxTerm(LibZMQWrapper.DllInstance(), context)
End Function
  
' <summary>
' Shutdown
' </summary>
' <param name="context"></param>
' <returns>Returns long.</returns>
Function LibZmqContext.Shutdown(byval context As Any Ptr) As Long
    Function = ZmqCtxShutdown(LibZMQWrapper.DllInstance(), context)
End Function
  
' <summary>
' Set
' </summary>
' <param name="context"></param>
' <param name="options"></param>
' <param name="optval"></param>
' <returns>Returns long.</returns>
Function LibZmqContext.Set(Byval context As Any Ptr, Byval options As Long, Byval optval As Long) As Long
    Function = ZmqCtxSet(LibZMQWrapper.DllInstance(), context, options, optval)
End Function
  
' <summary>
' Get
' </summary>
' <param name="context"></param>
' <param name="options"></param>
' <returns>Returns long.</returns>
Function LibZmqContext.Get(Byval context As Any Ptr, Byval options As Long) As Long
    Function = ZmqCtxGet(LibZMQWrapper.DllInstance(), context, options)
End Function

' Module LibZmqSocket

' <summary>
' Socket
' </summary>
' <param name="s"></param>
' <param name="stype"></param>
' <returns>Returns any ptr.</returns>
Function LibZmqSocket.Socket(Byval s As Any Ptr, Byval stype As Long) As Any Ptr
    Function = ZmqSocket(LibZMQWrapper.DllInstance(), s, stype)
End Function
  
' <summary>
' Bind
' </summary>
' <param name="socket_"></param>
' <param name="addr"></param>
' <returns>Returns long.</returns>
Function LibZmqSocket.Bind(Byval socket_ As Any Ptr, Byval addr As ZString Ptr) As Long
    Function = ZmqBind(LibZMQWrapper.DllInstance(), socket_, addr)
End Function

' <summary>
' UnBind
' </summary>
' <param name="socket_"></param>
' <param name="addr"></param>
' <returns>Returns long.</returns>
Function LibZmqSocket.UnBind(Byval socket_ As Any Ptr, Byval addr As ZString Ptr) As Long
    Function = ZmqUnBind(LibZMQWrapper.DllInstance(), socket_, addr)
End Function

' <summary>
' Recv
' </summary>
' <param name="socket_"></param>
' <param name="buf"></param>
' <param name="buflen"></param>
' <param name="flags"></param>
' <returns>Returns long.</returns>
Function LibZmqSocket.Recv(Byval socket_ As Any Ptr, Byval buf As Any Ptr, Byval buflen As Uinteger, Byval flags As Long) As Long
    Function = ZmqRecv(LibZMQWrapper.DllInstance(), socket_, buf, buflen, flags)
End Function

' <summary>
' Send
' </summary>
' <param name="socket_"></param>
' <param name="buf"></param>
' <param name="buflen"></param>
' <param name="flags"></param>
' <returns>Returns long.</returns>
Function LibZmqSocket.Send(Byval socket_ As Any Ptr, Byval buf As Any Ptr, Byval buflen As Uinteger, Byval flags As Long) As Long
    Function = ZmqSend(LibZMQWrapper.DllInstance(), socket_, buf, buflen, flags)
End Function

' <summary>
' SendConst
' </summary>
' <param name="socket_"></param>
' <param name="buf"></param>
' <param name="buflen"></param>
' <param name="flags"></param>
' <returns>Returns long.</returns>
Function LibZmqSocket.SendConst(Byval socket_ As Any Ptr, Byval buf As Any Ptr, Byval buflen As Uinteger, Byval flags As Long) As Long
    Function = ZmqSendConst(LibZMQWrapper.DllInstance(), socket_, buf, buflen, flags)
End Function

' <summary>
' Connect
' </summary>
' <param name="socket_"></param>
' <param name="addr"></param>
' <returns>Returns long.</returns>
Function LibZmqSocket.Connect(Byval socket_ As Any Ptr, Byval addr As ZString Ptr) As Long
    Function = ZmqConnect(LibZMQWrapper.DllInstance(), socket_, addr)
End Function

' <summary>
' DisConnect
' </summary>
' <param name="socket_"></param>
' <param name="addr"></param>
' <returns>Returns long.</returns>
Function LibZmqSocket.DisConnect(Byval socket_ As Any Ptr, Byval addr As ZString Ptr) As Long
    Function = ZmqDisConnect(LibZMQWrapper.DllInstance(), socket_, addr)
End Function

' <summary>
' Setsockopt
' </summary>
' <param name="socket_"></param>
' <param name="options"></param>
' <param name="optval"></param>
' <param name="optvallen"></param>
' <returns>Returns long.</returns>
Function LibZmqSocket.Setsockopt(Byval socket_ As Any Ptr, Byval options As Long, Byval optval As Any Ptr, Byval optvallen As Uinteger) As Long
    Function = ZmqSetsockopt(LibZMQWrapper.DllInstance(), socket_, options, optval, optvallen)
End Function

' <summary>
' Getsockopt
' </summary>
' <param name="socket_"></param>
' <param name="options"></param>
' <param name="optval"></param>
' <param name="optvallen"></param>
' <returns>Returns long.</returns>
Function LibZmqSocket.Getsockopt(Byval socket_ As Any Ptr, Byval options As Long, Byref optval As String, Byval optvallen As Uinteger) As Long
    Function = ZmqGetsockopt(LibZMQWrapper.DllInstance(), socket_, options, optval, optvallen)
End Function

' <summary>
' Close
' </summary>
' <param name="socket_"></param>
' <returns>Returns long.</returns>
Function LibZmqSocket.Close(Byval socket_ As Any Ptr) As Long
    Function = ZmqClose(LibZMQWrapper.DllInstance(), socket_)
End Function 

' Type LibZmqHelper
  
' <summary>
' StopwatchStart
' </summary>
' <returns>Returns any ptr.</returns>
Function LibZmqHelper.StopwatchStart() As Any Ptr
    Function = ZmqStopwatchStart(LibZMQWrapper.DllInstance())
End Function

' <summary>
' StopwatchIntermediate
' </summary>
' <param name="watch_"></param>
' <returns>Returns culong.</returns>
Function LibZmqHelper.StopwatchIntermediate(Byval watch_ As Any Ptr) As Culong
    Function = ZmqStopwatchIntermediate(LibZMQWrapper.DllInstance(), watch_)
End Function

' <summary>
' StopwatchStop
' </summary>
' <param name="watch_"></param>
' <returns>Returns culong.</returns>
Function LibZmqHelper.StopwatchStop(Byval watch_ As Any Ptr) As CUlong
    Function = ZmqStopwatchStop(LibZMQWrapper.DllInstance(), watch_)
End Function

' <summary>
' Sleep
' </summary>
' <param name="seconds_"></param>
' <returns>Returns void.</returns>
Sub LibZmqHelper.Sleep(Byval seconds_ As Long)
    ZmqSleep(LibZMQWrapper.DllInstance(), seconds_)
End Sub

' <summary>
' Threadstart
' </summary>
' <param name="func_"></param>
' <param name="arg_"></param>
' <returns>Returns any ptr.</returns>
Function LibZmqHelper.Threadstart(Byval func_ As Sub(Byval As Any Ptr), Byval arg_ As Any Ptr) As Any Ptr
    Function = ZmqThreadstart(LibZMQWrapper.DllInstance(), func_, arg_)
End Function

' <summary>
' Threadclose
' </summary>
' <param name="thread_"></param>
' <returns>Returns void.</returns>
Sub LibZmqHelper.Threadclose(Byval thread_ As Any Ptr)
    ZmqThreadclose(LibZMQWrapper.DllInstance(), thread_)
End Sub
