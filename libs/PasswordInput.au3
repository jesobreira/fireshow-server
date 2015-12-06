#AutoIt3Wrapper_AU3Check_Parameters=-d -w1 -w2 -w3 -w4 -w5 -w6
#include-once
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>

; #INDEX# =======================================================================================================================
; Title .........: GUI Password version 1.4
; AutoIt Version : 3.3 +
; Language ......: English
; Description ...: Tiny UDF to make Input controls with the $ES_PASSWORD style easy to manipulate.
; Author(s) .....: smartee, ProgAndy
; Dll(s) ........: user32.dll
; ===============================================================================================================================

; #VARIABLES# ===================================================================================================================
Global $__DEF_PASS_CHAR = -1
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
;_GUICtrlCreatePassword
;_GUICtrlPasswordCheckbox
;_GUICtrlPasswordDisplay
;================================================================================================================================

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlCreatePassword
; Description ...: Creates a Input control with the $ES_PASSWORD style.
; Syntax.........: _GUICtrlCreatePassword($sText, $iLeft, $iTop, $iWidth, $iHeight [, $iStyle = -1 [, $iExStyle = -1]])
; Parameters ....: $sText    - The text of the control.
;                  $iLeft    - The left side of the control. If -1 is used then left will be computed according to GUICoordMode.
;                  $iTop     - The top of the control. If -1 is used then top will be computed according to GUICoordMode.
;                  $iWidth   - The width of the control (default is the previously used width).
;                  $iHeight  - The height of the control (default is the previously used height).
;                  $iStyle   - [optional] Defines the style of the control. See GUI Control Styles Appendix.
;                  $iExStyle - [optional] Defines the extended style of the control. See Extended Style Table.
; Return values .: Success - Returns the identifier (controlID) of the new control.
;                  Failure - Returns 0.
; Author ........: smartee
; Modified.......:
; Remarks .......:
; Related .......: _GUICtrlPasswordCheckbox, _GUICtrlPasswordDisplay
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _GUICtrlCreatePassword($sText, $iLeft, $iTop, $iWidth, $iHeight, $iStyle = -1, $iExStyle = -1)
    If $iStyle = -1 Then $iStyle = BitOR($ES_PASSWORD, $ES_AUTOHSCROLL)
    Local $Password1 = GUICtrlCreateInput($sText, $iLeft, $iTop, $iWidth, $iHeight, $iStyle, $iExStyle)
    If $__DEF_PASS_CHAR = -1 Then $__DEF_PASS_CHAR = GUICtrlSendMsg($Password1, $EM_GETPASSWORDCHAR, 0, 0)
    Return $Password1
EndFunc   ;==>_GUICtrlCreatePassword

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlPasswordCheckbox
; Description ...: Links the password display function to the state of a checkbox.
; Syntax.........: _GUICtrlPasswordCheckbox($iPasswordID, $iCheckboxID)
; Parameters ....: $iPasswordID - The control identifier (controlID) of the input control as returned by
;                  +_GUICtrlCreatePassword or GUICtrlCreateInput.
;                  $iCheckboxID - The control identifier (controlID) of the checkbox control as returned by
;                  +GUICtrlCreateCheckbox.
; Return values .: Success      - True
;                  Failure      - False
; Author ........: smartee
; Modified.......:
; Remarks .......:
; Related .......: _GUICtrlCreatePassword, _GUICtrlPasswordDisplay
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _GUICtrlPasswordCheckbox($iPasswordID, $iCheckboxID)
    If (GUICtrlRead($iCheckboxID) = $GUI_CHECKED) Then Return _GUICtrlPasswordDisplay($iPasswordID)
    Return _GUICtrlPasswordDisplay($iPasswordID, 0)
EndFunc   ;==>_GUICtrlPasswordCheckbox

; #FUNCTION# ====================================================================================================================
; Name...........: _GUICtrlPasswordDisplay
; Description ...: Sets the visibility of the characters in any password styled input control.
; Syntax.........: _GUICtrlPasswordDisplay($iPasswordID [, $iShowFlag = -1])
; Parameters ....: $iPasswordID - The control identifier (controlID) of the input control as returned by
;                  +_GUICtrlCreatePassword or GUICtrlCreateInput.
;                  $iShowFlag - [optional] A flag to determine whether or not to show the actual contents of the input control
;                  |1 = reveal letters eg. "password", this is the default.
;                  |0 = mask letters eg. "********".
; Return values .: Success      - True
;                  Failure      - False
; Author ........: smartee
; Modified.......: ProgAndy
; Remarks .......:
; Related .......: _GUICtrlCreatePassword, _GUICtrlPasswordCheckbox
; Link ..........;
; Example .......; Yes
; ===============================================================================================================================
Func _GUICtrlPasswordDisplay($iPasswordID, $iShowFlag = -1)
    If $__DEF_PASS_CHAR = -1 Then $__DEF_PASS_CHAR = GUICtrlSendMsg($iPasswordID, $EM_GETPASSWORDCHAR, 0, 0)
    If $iShowFlag = -1 Then $iShowFlag = 1
    If $iShowFlag Then
        GUICtrlSendMsg($iPasswordID, $EM_SETPASSWORDCHAR, 0, 0)
    Else
        GUICtrlSendMsg($iPasswordID, $EM_SETPASSWORDCHAR, $__DEF_PASS_CHAR, 0)
    EndIf
    Local $aRes = DllCall("user32.dll", "int", "RedrawWindow", "hwnd", GUICtrlGetHandle($iPasswordID), "ptr", 0, "ptr", 0, "dword", 5)
    If @error Or $aRes[0] = 0 Then Return SetError(1, 0, False)
    Return True
EndFunc   ;==>_GUICtrlPasswordDisplay