; #FUNCTION# ====================================================================================================================
; Name ..........: _DesktopDimensions
; Description ...: Returns an array containing information about the primary and virtual monitors.
; Syntax ........: _DesktopDimensions()
; Return values .: Success - Returns a 6-element array containing the following information:
;                  $aArray[0] = Total number of monitors.
;                  $aArray[1] = Width of the primary monitor.
;                  $aArray[2] = Height of the primary monitor.
;                  $aArray[3] = Total width of the desktop including the width of multiple monitors. Note: If no secondary monitor this will be the same as $aArray[2].
;                  $aArray[4] = Total height of the desktop including the height of multiple monitors. Note: If no secondary monitor this will be the same as $aArray[3].
; Author ........: guinness
; Remarks .......: WinAPI.au3 must be included i.e. #include <WinAPI.au3>
; Related .......: @DesktopWidth, @DesktopHeight, _WinAPI_GetSystemMetrics
; Example .......: Yes
; ===============================================================================================================================
Func _DesktopDimensions()
    Local $aReturn = [_WinAPI_GetSystemMetrics($SM_CMONITORS), _ ; Number of monitors.
            _WinAPI_GetSystemMetrics($SM_CXSCREEN), _ ; Width or Primary monitor.
            _WinAPI_GetSystemMetrics($SM_CYSCREEN), _ ; Height or Primary monitor.
            (_WinAPI_GetSystemMetrics($SM_CXVIRTUALSCREEN)-_WinAPI_GetSystemMetrics($SM_CXSCREEN)), _ ; Width of the Virtual screen.
            _WinAPI_GetSystemMetrics($SM_CYVIRTUALSCREEN)] ; Height of the Virtual screen.
    Return $aReturn
EndFunc   ;==>_DesktopDimensions

#cs
Local $aScreenResolution = _DesktopDimensions()
MsgBox($MB_SYSTEMMODAL, '', 'Example of _DesktopDimensions:' & @CRLF & _
        'Number of monitors = ' & $aScreenResolution[0] & @CRLF & _
        'Primary Width = ' & $aScreenResolution[1] & @CRLF & _
        'Primary Height = ' & $aScreenResolution[2] & @CRLF & _
        'Secondary Width = ' & $aScreenResolution[3] & @CRLF & _
        'Secondary Height = ' & $aScreenResolution[4] & @CRLF)
#ce