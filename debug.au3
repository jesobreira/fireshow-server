If _CmdLine_KeyExists('debug') Then
	_DebugSetup("Fireshow server debug", True)
EndIf

Func fsdebug($str)
	If _CmdLine_KeyExists('debug') Then _DebugOut($str)
EndFunc