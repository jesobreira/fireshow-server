Func randompwd($digits = Random(6, 8))
	Dim $pwd,$aSpace[3]
	For $i = 1 To $digits
		$aSpace[0] = Chr(Random(65, 90, 1)) ;A-Z
		$aSpace[1] = Chr(Random(97, 122, 1)) ;a-z
		$aSpace[2] = Chr(Random(48, 57, 1)) ;0-9
		$pwd &= $aSpace[Random(0, 2, 1)]
	Next
	Return $pwd
EndFunc

Func _init_i18n()
	 $fname = @TempDir & "\Fireshow_lang.ini"
	 _ResourceSaveToFile($fname, "LANGS")
	_i18n_SetGlobalFile($fname)
EndFunc