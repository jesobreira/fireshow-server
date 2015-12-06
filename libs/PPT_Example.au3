; this is just an example

#include "pptshow.au3"

$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")

$objPPT = _PPTStartup()
If @error Then
	MsgBox(0,"","No PowerPoint available")
	Exit
EndIf

;$pptcount = $objPPT.Presentations.Count
$pptcount = $objPPT.SlideShowWindows.Count
;MsgBox(0, '', $pptcount)

If $pptcount Then
	$slides = $objPPT.Presentations(1).Slides.Count
	;MsgBox(0, '', $slides)
	; Next,Previous,First,Last,Exit,GotoSlide(123)
	$objPPT.SlideShowWindows(1).View.Next

	;$strNotes = $objPPT.ActivePresentation.Slides(2).NotesPage.Shapes.Placeholders(2).TextFrame.TextRange.Text
	;MsgBox(0, '', $strNotes)

	;$currentslide = $objPPT.SlideShowWindows(1).View.Slide.SlideIndex
EndIf

;$objPPT.ActivePresentation.SlideShowWindow(0).View.Next

;$objPPT.ActivePresentation.SlideShowWindow(0).View.GotoSlide

Func MyErrFunc()
  $HexNumber=hex($oMyError.number,8)
  Msgbox(0,"COM Test","We intercepted a COM Error !"       & @CRLF  & @CRLF & _
             "err.description is: "    & @TAB & $oMyError.description    & @CRLF & _
             "err.windescription:"     & @TAB & $oMyError.windescription & @CRLF & _
             "err.number is: "         & @TAB & $HexNumber              & @CRLF & _
             "err.lastdllerror is: "   & @TAB & $oMyError.lastdllerror   & @CRLF & _
             "err.scriptline is: "     & @TAB & $oMyError.scriptline     & @CRLF & _
             "err.source is: "         & @TAB & $oMyError.source         & @CRLF & _
             "err.helpfile is: "       & @TAB & $oMyError.helpfile       & @CRLF & _
             "err.helpcontext is: "    & @TAB & $oMyError.helpcontext _
            )
  SetError(1)
Endfunc