Func OnConnect($iSocket, $sIP)
	fsdebug("Someone connected with IP " & $sIP)
	_GUICtrlListBox_AddString($gConnectedusers, $sIP)
EndFunc

Func OnDisconnect($iSocket, $sIP)
	_GUICtrlListBox_ResetContent($gConnectedusers)
	$aActive = _TCPServer_ListClients()
	For $i = 1 To _TCPServer_GetMaxClients()
		$sIP = _TCPServer_SocketToIP($aActive[$i])
		If $sIP <> 0 Then
			GUICtrlCreateListViewItem($sIP & "|" & $aActive[$i], $gConnectedusers)
		EndIf
	Next
EndFunc

Func OnRecv_http($iSocket, $sIP, $sData, $sPar)
	; Request: /[server]/[command]/[parameter]?callback=[]
	fsdebug("Message received")
	Dim $sCallback
	_TCPServer_Send($iSocket, "HTTP/1.0 200 OK" & @CRLF & _
					"Server: Fireshow" & @CRLF & _
					"Access-Control-Allow-Origin: *" & @CRLF & _
					"Content-Type: text/javascript" & @CRLF & @CRLF)

	$sData = StringSplit($sData, @CRLF & @CR & @LF)
	$sData = $sData[1]
	$sData = StringReplace($sData, "GET ", Null)
	$sData = StringReplace($sData, " HTTP/1.1", Null)
	$sData = StringReplace($sData, " HTTP/1.0", Null)
	$sData = StringSplit($sData, "/")
	_ArrayDelete($sData, 1)
	Dim $sToBeSent
	If UBound($sData) = 3 Or UBound($sData) = 4 Then
		$sPwd = $sData[1]

		; get callback parameter
		$sRequest = StringSplit($sData[2], "?callback=", 1)

		;_ArrayDisplay($sRequest)
		If $sRequest[0] = 2 Then
			; Remove &_= additional jquery parameter
			$sCallback = StringSplit($sRequest[2], "&_=", 1)
			$sCallback = $sCallback[1]
			$sRequest = $sRequest[1]
		Else
			$sRequest = $sRequest[1]
		EndIf


		If $sRequest = "isfireshow" Then
			$sToBeSent = "yes"
		ElseIf $sRequest = "checkpwd" Then
			If $sPwd = GUICtrlRead($gPassword) Then
				$sToBeSent = "ok"
			Else
				$sToBeSent = "invalidpwd"
			EndIf
		Else
			If $sPwd = GUICtrlRead($gPassword) Then
				_log($sIP, _("command") & $sRequest)
				$sReturn = processa($sRequest)
				If $sReturn Then
					$sToBeSent = $sReturn
				Else
					$sToBeSent = "ok"
				EndIf
			Else
				_log($sIP, _("invalidpwd"))
				$sToBeSent = "invalidpwd"
			EndIf
		EndIf
	Else
		_log($sIP, _("invalidreq"))
		$sToBeSent = "404 Not Found"
	EndIf

	;_ArrayDisplay($sData)

	; send response
	_TCPServer_Send($iSocket, make_response($sToBeSent, $sCallback))
	_TCPServer_Close($iSocket)
EndFunc   ;==>received

Func processa($sData)
	$sData = StringSplit($sData, "-")
	Dim $command,$par
	If $sData[0] = 2 Then
		$par = $sData[2]
	EndIf
	$command = $sData[1]

	If test_ppt() Then
		$objPPT = _PPTStartup()
		$pptcount = $objPPT.SlideShowWindows.Count
		If $pptcount Or $command = "start" Then ; start command will run even if ppt isnt showing
			Switch $command
				Case "next"
					$objPPT.SlideShowWindows(1).View.Next
					Return $objPPT.SlideShowWindows(1).View.Slide.SlideIndex

				Case "previous"
					$objPPT.SlideShowWindows(1).View.Previous
					Return $objPPT.SlideShowWindows(1).View.Slide.SlideIndex

				Case "first"
					$objPPT.SlideShowWindows(1).View.First
					Return $objPPT.SlideShowWindows(1).View.Slide.SlideIndex

				Case "last"
					$objPPT.SlideShowWindows(1).View.Last
					Return $objPPT.SlideShowWindows(1).View.Slide.SlideIndex

				Case "current"
					Return $objPPT.SlideShowWindows(1).View.Slide.SlideIndex

				Case "howmany"
					Return $objPPT.Presentations(1).Slides.Count

				Case "picture"
					$handler = WinGetHandle("[CLASS:screenClass]")
					$filename = _TempFile(@TempDir, "", ".png")
					_ScreenCapture_CaptureWnd($filename, $handler)
					$filecontent = _Base64Encode(FileRead($filename))
					FileDelete($filename)
					Return 'data:image/png;base64,' & $filecontent

				Case "notes"
					$currentslide = $objPPT.SlideShowWindows(1).View.Slide.SlideIndex
					Return $objPPT.ActivePresentation.Slides($currentslide).NotesPage.Shapes.Placeholders(2).TextFrame.TextRange.Text

				Case "exit"
					$objPPT.SlideShowWindows(1).View.Exit

				Case "goto"
					$objPPT.SlideShowWindows(1).View.GotoSlide($par)

				Case "blackout"
					; not working yet
					; see https://social.msdn.microsoft.com/Forums/en-US/16a4cd3b-2da4-4bbb-926c-44f7b52ac483/problem-with-toggling-black-screen-option-in-powerpoint-2010

				Case "start"
					$objPPT.Presentations(1).SlideShowSettings.Run

				Case Else
					Return "unrecogcmd"

			EndSwitch
		Else
			Return "nopptavail"
		EndIf
	EndIf
EndFunc

Func _log($ip, $data)
	_GUICtrlListBox_AddString($gLog, "[" & @HOUR & ":" & @MIN & "] [" & $ip & "] " & $data)
	_GUICtrlListBox_SetTopIndex($gLog, _GUICtrlListBox_GetCount($gLog)-1)
EndFunc

Func make_response($data, $callback = Null)
	; Sanitize
	$data = StringReplace($data, '\', '\\')
	$data = StringReplace($data, '"', '\"')

	; Put in callback
	Return $callback & '("' & $data & '");'
EndFunc