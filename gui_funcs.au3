Func fAbout()
	ShellExecute("http://jesobreira.github.io/fireshow")
EndFunc
Func frmMainClose()
	If _TCPServer_IsServerActive() Then
		$do = _ExtMsgBox(32, _("dokill") & "|" & _("dominimize"), "Fireshow", _("dowhat"), 0, $frmMain, 0, False)
		If $do = 1 Then
			_TCPServer_Stop()
			_WinAPI_AnimateWindow($frmMain, BitOR($AW_BLEND, $AW_HIDE))
			Exit
		Else
			_Minimize()
		EndIf
	Else
		_WinAPI_AnimateWindow($frmMain, BitOR($AW_BLEND, $AW_HIDE))
		Exit
	EndIf
EndFunc
Func frmMainMinimize()
	; nothing
EndFunc
Func frmMainRestore()
	_Restore()
EndFunc
Func fToggleserver()
	If _CmdLine_KeyExists('debug') Then _TCPServer_DebugMode(True)

	If Not test_ppt() Then
		MsgBox(48, _("error"), _("pptnotfound"))
		Return False
	EndIf

	_TCPServer_DebugMode()

	If Not _TCPServer_IsServerActive() Then
		$port = GUICtrlRead($gPort)
		$max = GUICtrlRead($gMax)

		_TCPServer_OnConnect('OnConnect')
		_TCPServer_OnDisconnect('OnDisconnect')
		_TCPServer_OnReceive('OnRecv_http')

		_TCPServer_SetMaxClients($max+10)

		$interf = GUICtrlRead($gInterface)
		If $interf = _("anyinterface") Or Not $interf Then $interf = "0.0.0.0"

		If _TCPServer_Start($port, $interf) Then
			_GUICtrlPasswordDisplay($gPassword, 0)
			GUICtrlSetBkColor($gServerstatus, 0x008000)
			GUICtrlSetData($gServerstatus, _("serverrunning"))
			GUICtrlSetData($gToggleserver, _("stopserver"))
			TrayItemSetText($fToggleserver, _("stopserver"))
			TraySetToolTip("Fireshow - " & _("onlineat") & " " & (($interf = '0.0.0.0') ? @IPAddress1 : $interf)  & ":" & $port)
			GUICtrlSetState($gPort, $GUI_DISABLE)
			GUICtrlSetState($gMax, $GUI_DISABLE)
			TrayTip("Fireshow " & _("online"), _("runningat") & " " & (($interf = '0.0.0.0') ? @IPAddress1 : $interf) & ":" & $port, 30)
		Else
			Dim $iMsgBoxAnswer
			$iMsgBoxAnswer = MsgBox(309, _("error"), _("couldnotopenport"))
			Select
			   Case $iMsgBoxAnswer = 4 ;Retry
				Return fToggleserver()
			   Case $iMsgBoxAnswer = 2 ;Cancel
				Return
			EndSelect
		EndIf
	Else
		_TCPServer_Stop()
		$DefaultPassChar = GUICtrlSendMsg($gPassword, $EM_GETPASSWORDCHAR, 0, 0)
		_GUICtrlPasswordDisplay($gPassword, 1)
		GUICtrlSetBkColor($gServerstatus, 0x808080)
		GUICtrlSetData($gServerstatus, _("serverstopped"))
		GUICtrlSetData($gToggleserver, _("startserver"))
		TrayItemSetText($fToggleserver, _("startserver"))
		TraySetToolTip("Fireshow - " & _("offline"))
		GUICtrlSetState($gPort, $GUI_ENABLE)
		GUICtrlSetState($gMax, $GUI_ENABLE)
	EndIf
EndFunc

Func boot()
	$savedpwd = IniRead(@LocalAppDataDir & "\fireshow.ini", "cfg", "pwd", randompwd())
	$savedport = IniRead(@LocalAppDataDir & "\fireshow.ini", "cfg", "port", "8081")
	$savedmax = IniRead(@LocalAppDataDir & "\fireshow.ini", "cfg", "max", "1")

	_GUICtrlPasswordDisplay($gPassword, 1)

	GUICtrlSetData($gPort, $savedport)
	GUICtrlSetData($gMax, $savedmax)
	GUICtrlSetData($gPassword, $savedpwd)

	_GUICtrlComboBox_AddString($gInterface, "0.0.0.0")
	If @IPAddress1 <> "0.0.0.0" Then _GUICtrlComboBox_AddString($gInterface, @IPAddress1)
	If @IPAddress2 <> "0.0.0.0" Then _GUICtrlComboBox_AddString($gInterface, @IPAddress2)
	If @IPAddress3 <> "0.0.0.0" Then _GUICtrlComboBox_AddString($gInterface, @IPAddress3)
	If @IPAddress4 <> "0.0.0.0" Then _GUICtrlComboBox_AddString($gInterface, @IPAddress4)

	; load external ip inside adlib
	; so we dont have to wait until it's loaded to open the main window
	;AdlibRegister("boot_getexternalip") ; disabled because its freezing the app

	GUIDelete($gLoading)
	GUISetState(@SW_SHOW, $frmMain)
EndFunc

Func boot_getexternalip()
	$getip = _GetIP()
	If $getip <> -1 Then _GUICtrlComboBox_AddString($gInterface, $getip)
	AdlibUnRegister("boot_getexternalip") ; remove this func from adlib, so it wont loop
EndFunc

Func loop()
	If _DesktopDimensions()[0] > 1 Then
		GUICtrlSetState($frm2ndmon, $GUI_ENABLE)
	Else
		GUICtrlSetState($frm2ndmon, $GUI_UNCHECKED + $GUI_DISABLE)
	EndIf
EndFunc