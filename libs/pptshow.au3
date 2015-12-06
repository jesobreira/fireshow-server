Func _PPTStartup($visible = 1)
	Local $obj = ObjCreate("PowerPoint.Application")
	If IsObj($obj) <> 1 Then
		SetError(1)
		Return 0
	Else
		$obj.Visible = $visible
		Return $obj
	Endif
EndFunc