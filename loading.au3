Global $gLoading
Func gLoading()
	Global $gLoading = GUICreate("Fireshow", 220, 60, -1, -1, $WS_DLGFRAME)

	GUICtrlCreateProgress(10, 10, 200, 20, $PBS_MARQUEE)
	_SendMessage(GUICtrlGetHandle(-1), $PBM_SETMARQUEE, True, 50)

	GUISetState()
EndFunc