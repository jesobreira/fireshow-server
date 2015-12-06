#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=static\icon.ico
#AutoIt3Wrapper_Outfile=bin\Fireshow.exe
#AutoIt3Wrapper_Res_Comment=http://jesobreira.github.io/fireshow
#AutoIt3Wrapper_Res_Description=Fireshow Server
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Run_AU3Check=n
#AutoIt3Wrapper_Res_File_Add=lang.ini, 10, LANGS
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <ComboConstants.au3>
#include <GUIConstantsEx.au3>
#include <GUIListBox.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <TrayConstants.au3>
#include <WinAPI.au3>
#include <WinAPISys.au3>
#include <WinAPIGdi.au3>
#include <WinAPIRes.au3>
#include <WinAPIInternals.au3>
#include <WindowsConstants.au3>
#include <Array.au3>
#include <ScreenCapture.au3>
#include <File.au3>
#include <GuiComboBoxEx.au3>
#include <Inet.au3>
#include <ProgressConstants.au3>
#include <SendMessage.au3>
#include <Debug.au3>

#include 'loading.au3'
gLoading()

#include 'libs\StringSize.au3'
#include 'libs\ExtMsgBox.au3'
#include 'libs\tcpserver.au3'
#include 'libs\multimonitor.au3'
#include 'libs\PasswordInput.au3'
#include 'libs\pptshow.au3'
#include 'libs\base64.au3'
#include 'libs\cmdline.au3'
#include 'libs\i18n.au3'
#include 'libs\resource.au3'

#include 'helper.au3'
#include 'com.au3'
#include 'server_core.au3'

Opt("GUIOnEventMode", 1)
_init_i18n()

#include 'form.au3'
#include 'gui_funcs.au3'
#include 'tray.au3'
#include 'debug.au3'

boot()

While 1
	loop()
	Sleep(100)
WEnd