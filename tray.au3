Opt("TrayIconDebug", 0)
Opt("TrayAutoPause", 0)
Opt("TrayMenuMode", 1+8)
Opt("TrayOnEventMode", 1)

Global $hTray = ControlGetHandle('[CLASS:Shell_TrayWnd]', '', 'ToolbarWindow32')
Global $fMinimized = False

TraySetIcon(@AutoItExe)
TraySetOnEvent($TRAY_EVENT_PRIMARYDOUBLE, 'frmMainRestore')
TraySetClick(16+2)
TraySetToolTip("Fireshow - " & _("offline"))
$fToggleserver = TrayCreateItem(_("startserver"), -1, -1, 0)
TrayItemSetOnEvent(-1, "fToggleserver")
$tRestore = TrayCreateItem(_("restore"), -1, -1, 0)
TrayItemSetOnEvent(-1, "tRestore")
$MenuItem3 = TrayCreateItem(_("exit"), -1, -1, 0)
TrayItemSetOnEvent(-1, "tExit")

Func tExit()
	If _TCPServer_IsServerActive() Then
		If 6 = MsgBox(36,"Fireshow",_("sureclose")) Then
			_WinAPI_AnimateWindow($frmMain, BitOR($AW_BLEND, $AW_HIDE))
			Exit
		EndIf
	Else
		_WinAPI_AnimateWindow($frmMain, BitOR($AW_BLEND, $AW_HIDE))
		Exit
	EndIf
EndFunc

Func tRestore()
	_Restore()
EndFunc


Func _Minimize()
    Local $tRcFrom , $tRcTo

    If Not $fMinimized Then
        $tRcFrom = _WinAPI_GetWindowRect($frmMain)
        $tRcTo = _WinAPI_GetWindowRect($hTray)
        _WinAPI_DrawAnimatedRects($frmMain, $tRcFrom, $tRcTo)
        GUISetState(@SW_HIDE)
        $fMinimized = True
    EndIf
EndFunc

Func _Restore()
	Local $tRcFrom , $tRcTo

    If $fMinimized Then
        $tRcFrom = _WinAPI_GetWindowRect($hTray)
        $tRcTo = _WinAPI_GetWindowRect($frmMain)
        _WinAPI_DrawAnimatedRects($frmMain, $tRcFrom, $tRcTo)
        GUISetState(@SW_SHOW)
        $fMinimized = False
    EndIf
EndFunc