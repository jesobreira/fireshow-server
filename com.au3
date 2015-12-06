Global $oMyError = ObjEvent("AutoIt.Error","MyErrFunc")

#cs
	Test if powerpoint is available
#ce
Func test_ppt()
	$objPPT = _PPTStartup()
	If @error Then
		Return False
	Else
		Return True
	EndIf
EndFunc

Func MyErrFunc()
  If @Compiled Then Return ; workaround (bug)
  $HexNumber=hex($oMyError.number,8)
  If Not @Compiled Then
	Msgbox(0,"Error","We intercepted a COM Error !"       & @CRLF  & @CRLF & _
             "err.description is: "    & @TAB & $oMyError.description    & @CRLF & _
             "err.windescription:"     & @TAB & $oMyError.windescription & @CRLF & _
             "err.number is: "         & @TAB & $HexNumber              & @CRLF & _
             "err.lastdllerror is: "   & @TAB & $oMyError.lastdllerror   & @CRLF & _
             "err.scriptline is: "     & @TAB & $oMyError.scriptline     & @CRLF & _
             "err.source is: "         & @TAB & $oMyError.source         & @CRLF & _
             "err.helpfile is: "       & @TAB & $oMyError.helpfile       & @CRLF & _
             "err.helpcontext is: "    & @TAB & $oMyError.helpcontext _
            )
	Else
		MsgBox(48,"Powerpoint error", $oMyError.description)
	EndIf
	SetError(1)
Endfunc