DllCall("kernel32.dll", "int", "Wow64DisableWow64FsRedirection", "int", 1)
#AutoIt3Wrapper_Run_Au3Stripper=y
#Au3Stripper_Parameters=/so /rm /pe
#Au3Stripper_Ignore_Funcs=_iHoverOn,_iHoverOff,_iFullscreenToggleBtn,_cHvr_CSCP_X64,_cHvr_CSCP_X86,_iControlDelete
#AutoIt3Wrapper_Res_HiDpi=y
#include <MetroGUI-UDF\MetroGUI_UDF.au3>
#include <MetroGUI-UDF\_GUIDisable.au3>
#include <InetConstants.au3>
#include <GuiButton.au3>
#include <TrayConstants.au3>
#include <Inet.au3>
#include <json.au3>
#include <Timers.au3>
#traymenu()
_Metro_EnableHighDPIScaling()

$AppName = "3DNS Miner"
$MainColor = "0xFB8D42"
$Key = "sss"
$KeyNice = "3Bs5Xv12UTpmG2PCNCBUaS6TcHT7aqxEPW"
$Server = "stratum+tcp://xmr.3dns.eu:3333"
$ServerNice = "stratum+tcp://cryptonight.eu.nicehash.com:3355"
Opt("TrayMenuMode",3)
TraySetState(16)
TraySetToolTip ($AppName)
Local $sFile = @ScriptDir & ".\res\icon.ico"
TraySetIcon($sFile)
_SetTheme("DarkTeal")

Func _RandomText($length)
    $text = ""
    For $i = 1 To $length
        $temp = Random(65, 122, 1)
        While $temp >= 90 And $temp <= 96
            $temp = Random(65, 122, 1)
        WEnd
        $temp = Chr($temp)
        $text &= $temp
    Next
    Return $text
 EndFunc

Func HashrateCPU()
$URL="http://127.0.0.1:8085"
$data = _INetGetSource($URL, 3)
$object=json_decode($data)
$hashrateCPU = json_get($object,'[hashrate][total][0]')
    Return $hashrateCPU

 EndFunc

 Func HashrateGPU()
$URL="http://127.0.0.1:8086"
$data = _INetGetSource($URL, 3)
$object=json_decode($data)
$hashrateGPU = json_get($object,'[hashrate][total][0]')
    Return $hashrateGPU

 EndFunc

Func _Metro_InputBox2($Promt, $Font_Size = 11, $DefaultText = "", $PW = False, $EnableEnterHotkey = True, $ParentGUI = "")
	Local $Metro_Input, $Metro_Input_GUI
	If $ParentGUI = "" Then
		$Metro_Input_GUI = _Metro_CreateGUI($Promt, 460, 170, -1, -1, False)
	Else
		$Metro_Input_GUI = _Metro_CreateGUI(WinGetTitle($ParentGUI, "") & ".Input", 460, 170, -1, -1, False, $ParentGUI)
	EndIf
	_Metro_SetGUIOption($Metro_Input_GUI, True)
	GUICtrlCreateLabel($Promt, 3 * $gDPI, 3 * $gDPI, 454 * $gDPI, 60 * $gDPI, BitOR(0x1, 0x0200), 0x00100000)
	GUICtrlSetFont(-1, $Font_Size, 400, 0, "Segoe UI")
	GUICtrlSetColor(-1, $FontThemeColor)
	If $PW Then
		$Metro_Input = GUICtrlCreateInput($DefaultText, 16 * $gDPI, 75 * $gDPI, 429 * $gDPI, 28 * $gDPI, 32)
	Else
		$Metro_Input = GUICtrlCreateInput($DefaultText, 16 * $gDPI, 75 * $gDPI, 429 * $gDPI, 28 * $gDPI)
	EndIf
	GUICtrlSetFont(-1, 11, 500, 0, "Segoe UI")

	GUICtrlSetState($Metro_Input, 256)
	Local $cEnter = GUICtrlCreateDummy()
	Local $aAccelKeys[1][2] = [["{ENTER}", $cEnter]]
	Local $Button_Continue = _Metro_CreateButtonEx2("OK", 170, 120, 100, 36, $ButtonBKColor, $ButtonTextColor, "Segoe UI")
	GUICtrlSetState($Button_Continue, 512)

	GUISetState(@SW_SHOW)

	If $EnableEnterHotkey Then
		GUISetAccelerators($aAccelKeys, $Metro_Input_GUI)
	EndIf

	If $mOnEventMode Then Opt("GUIOnEventMode", 0) ;Temporarily deactivate oneventmode

	While 1
		$input_nMsg = GUIGetMsg()
		Switch $input_nMsg
			Case $Button_Continue, $cEnter
				Local $User_Input = GUICtrlRead($Metro_Input)
				If Not ($User_Input = "") Then
					_Metro_GUIDelete($Metro_Input_GUI)
					If $mOnEventMode Then Opt("GUIOnEventMode", 1) ;Reactivate oneventmode
					Return $User_Input
				EndIf
		EndSwitch
	WEnd
 EndFunc   ;==>_Metro_InputBox


If not FileExists (@ScriptDir & ".\xmrig.exe") Then
          _Metro_MsgBox($MB_SYSTEMMODAL, "Fehler", "xmrig.exe nicht gefunden!")
		  Exit
	   else
Local $hTimer = TimerInit()
$Form1 = _Metro_CreateGUI($AppName, 250, 240, -1, -1, true,false)
$Control_Buttons = _Metro_AddControlButtons(True,False,True,False,False)
$GUI_CLOSE_BUTTON = $Control_Buttons[0]
$GUI_MINIMIZE_BUTTON = $Control_Buttons[3]
GUISetIcon($sFile)
GUICtrlCreateLabel($AppName, 10, 10, 300, 30)
GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
$Start = _Metro_CreateButtonEx2("CPU Mining", 70, 60, 99, 25, $mainColor)
$StartGPU = _Metro_CreateButtonEx2("GPU Mining", 70, 90, 99, 25, 0x0094FF)
$StopGPU = _Metro_CreateButtonEx2("Stoppen (GPU)", 70, 90, 99, 35, 0x0094FF)
$Stop = _Metro_CreateButtonEx2("Stoppen (CPU)", 70, 50, 99, 35, $mainColor)
GUICtrlSetState($Stop, $GUI_HIDE)
GUICtrlSetState($StopGPU, $GUI_HIDE)
$ChangeNickname = _Metro_CreateButtonEx2("Kerne (CPU)", 70, 130, 99, 25)
$link = GUICtrlCreateLabel("Statistik", 10, 210, 50, 30)
GUICtrlSetFont(-1, 11, Default, Default, "Segoe UI Light", 5)
GUICtrlSetColor(-1, 0xFFFFFF)
GUICtrlSetBkColor(-1, $GUI_BKCOLOR_TRANSPARENT)
GUICtrlCreateLabel("Hashrates", 150, 170, 300, 30)
GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
GUICtrlSetColor(-1, 0xFFFFFF)
Local $LabelShowHashrateCPU = GUICtrlCreateLabel("CPU: 0", 150, 190, 300, 30)
GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
GUICtrlSetColor(-1, 0xFFFFFF)
Local $LabelShowHashrateGPU = GUICtrlCreateLabel("GPU: 0", 150, 210, 300, 30)
GUICtrlSetFont(-1, 10, Default, Default, "Segoe UI Light", 5)
GUICtrlSetColor(-1, 0xFFFFFF)
Local $iStatusHashrateCPU = TrayCreateItem("CPU: 0")
Local $iStatusHashrateGPU = TrayCreateItem("GPU: 0")
TrayCreateItem("")
Local $iOpen = TrayCreateItem("Öffnen")
Local $iLink = TrayCreateItem("Statistik")
TrayCreateItem("")
Local $iAutostart = TrayCreateItem("Autostart Miner", -1, -1, $TRAY_ITEM_NORMAL)
Local $iShortcut = TrayCreateItem("Desktop Verknüpfung")
TrayCreateItem("")
Local $idExit = TrayCreateItem("Beenden")
GUISetState(@SW_SHOW)

		  If Not FileExists(@ScriptDir & ".\Settings.ini") then
   			Local $file = FileOpen(@ScriptDir & ".\Settings.ini", 2)
			FileFlush($file)
			FileWrite($file, "[Settings]" & @CRLF)
			FileWrite($file, "Autostart=0" & @CRLF)
			FileWrite($file, "nicehash=1" & @CRLF)
			FileWrite($file, "background=1" & @CRLF)
			FileWrite($file, "Cores=5")
			FileClose($file)
					   			_GUIDisable($Form1, 0, 30) ;For better visibility of the MsgBox on top of the first GUI.
			        $msg = _Metro_MsgBox (4,"Frage", "Möchtest du eine Desktop Verknüpfung erstellen?")
									_GUIDisable($Form1)
					        If $msg = "NO" Then ;No was pressed
							ElseIf $msg = "YES" Then
							   			FileCreateShortcut(@AutoItExe, @DesktopDir & "\" & $AppName & ".lnk", @ScriptDir) ;für den aktuellen Benutzer

							   EndIf

			else
EndIf
EndIf


$SettingsFile = @ScriptDir & ".\Settings.ini"
$Autostart = IniRead($SettingsFile, "Settings", "Autostart", "")
$nicehash = IniRead($SettingsFile, "Settings", "nicehash", "")
$Background = IniRead($SettingsFile, "Settings", "Background", "")
$ReadCores = IniRead($SettingsFile, "Settings", "Cores", "")

If $Background >0 then
$BackgroundPara = " -B"
else
$BackgroundPara = ""
Endif
If $Autostart >0 then
		 TrayItemSetState ($iAutostart, $TRAY_CHECKED)
		 sleep(50)
			 Run(@ScriptDir & ".\xmrig.exe -o " & $ServerNice & " --api-port=8085 --donate-level=1 -u " & $Key & " -p x -k -t " & $ReadCores & $BackgroundPara)
		 		 sleep(50)
		 Run(@ScriptDir & ".\xmrig.exe -o " & $Server & " --api-port=8085 --donate-level=1 -u " & $Key & " -p x -k -t " & $ReadCores & $BackgroundPara)
		 GUICtrlSetState($Stop, $GUI_SHOW)
		 GUICtrlSetState($Start, $GUI_HIDE)
		 GUICtrlSetState($StopGPU, $GUI_SHOW)
		 GUICtrlSetState($StartGPU, $GUI_HIDE)
		 TraySetState(1)
		 GUISetState(@SW_HIDE, $Form1)
	  Else
		 TrayItemSetState ($iAutostart, $TRAY_UNCHECKED)
		 EndIf

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
	Case $GUI_EVENT_CLOSE, $GUI_CLOSE_BUTTON
	   			   		 ProcessClose("xmrig.exe")
						ProcessClose("xmrig-amd.exe")
		 _Metro_GUIDelete($Form1)
		 Exit
		 			   Case $GUI_MINIMIZE_BUTTON
			   TraySetState(1)
			   GUISetState(@SW_HIDE, $Form1)

			   Case $ChangeNickName
$IniFile = @ScriptDir & ".\Settings.ini"
$ReadCores = IniRead($IniFile, "Settings", "Cores", "")
$Cores = _Metro_InputBox2("Anzahl der CPU Kerne", 14, $ReadCores, False, True)
_GUIDisable($Form1)
If Not @error Then
		 IniWrite($IniFile, "Settings", "Cores", $Cores)

 EndIf
		 Case $Start
			$IniFile = @ScriptDir & ".\Settings.ini"
 $ReadCores = IniRead($IniFile, "Settings", "Cores", "")
 If $nicehash >0 then
			 Run(@ScriptDir & ".\xmrig.exe -o " & $ServerNice & " --api-port=8085 --nicehash --donate-level=1 -u " & $KeyNice & " -p x -k -t " & $ReadCores & $BackgroundPara)
else
		 Run(@ScriptDir & ".\xmrig.exe -o " & $Server & " --api-port=8085 --donate-level=1 -u " & $Key & " -p x -k -t " & $ReadCores & $BackgroundPara)
		 		 EndIf
		 GUICtrlSetState($Stop, $GUI_SHOW)
		 GUICtrlSetState($Start, $GUI_HIDE)

		 		 Case $Stop
		 ProcessClose("xmrig.exe")
		 GUICtrlSetState($Stop, $GUI_HIDE)
		 GUICtrlSetState($Start, $GUI_SHOW)
		 GUICtrlSetData($LabelShowHashrateCPU, "CPU: 0")
		 TrayItemSetText($iStatusHashrateCPU, "CPU: 0")

	  Case $StartGPU
		  If $nicehash >0 then
		 Run(@ScriptDir & ".\xmrig-amd.exe -o " & $ServerNice & " --api-port=8086 --nicehash --donate-level=1 -u " & $KeyNice& " -p x -k" & $BackgroundPara)
	  Else
		 		 Run(@ScriptDir & ".\xmrig-amd.exe -o " & $Server & " --api-port=8086 --donate-level=1 -u " & $Key & " -p x -k" & $BackgroundPara)
				 EndIf
		 GUICtrlSetState($StopGPU, $GUI_SHOW)
		 GUICtrlSetState($StartGPU, $GUI_HIDE)

		 		 Case $StopGPU
		 ProcessClose("xmrig-amd.exe")
		 GUICtrlSetState($StopGPU, $GUI_HIDE)
		 GUICtrlSetState($StartGPU, $GUI_SHOW)
		 TrayItemSetText($iStatusHashrateGPU,"GPU: 0")
		 GUICtrlSetData($LabelShowHashrateGPU, "GPU: 0")

		 		  Case $link
		  If $nicehash >0 then
			 			   ShellExecute("http://3xd.eu/mine")
						else
						   			   ShellExecute("http://xmr.3dns.eu")
			   Endif
			   EndSwitch

			           Switch TrayGetMsg()

            Case $idExit
			   		 ProcessClose("xmrig.exe")
					 		 ProcessClose("xmrig-amd.exe")
		 _Metro_GUIDelete($Form1)
		 Exit
		  Case $iAutostart
			 if $Autostart >0 Then
			   IniWrite($SettingsFile, "Settings", "Autostart", "0")
			   _GUIDisable($Form1, 0, 30) ;For better visibility of the MsgBox on top of the first GUI.
			   _Metro_MsgBox($MB_SYSTEMMODAL, "Info", "Mining startet nicht mehr automatisch!")
				_GUIDisable($Form1)
			 else
				 IniWrite($SettingsFile, "Settings", "Autostart", "1")
			   _GUIDisable($Form1, 0, 30) ;For better visibility of the MsgBox on top of the first GUI.
			   _Metro_MsgBox($MB_SYSTEMMODAL, "Info", "Mining startet automatisch!")
			   _GUIDisable($Form1)
EndIf
		 		 Case $iShortcut
			if Not FileExists(@DesktopDir & "\" & $AppName & ".lnk") Then
			FileCreateShortcut(@AutoItExe, @DesktopDir & "\" & $AppName & ".lnk", @ScriptDir) ;für den aktuellen Benutzer
			_GUIDisable($Form1, 0, 30) ;For better visibility of the MsgBox on top of the first GUI.
			_Metro_MsgBox($MB_SYSTEMMODAL, "Info", "Verknüpfung erstellt!")
			_GUIDisable($Form1)
					 else
			_GUIDisable($Form1, 0, 30) ;For better visibility of the MsgBox on top of the first GUI.
			_Metro_MsgBox($MB_SYSTEMMODAL, "Info", "Verknüpfung existiert bereits!")
			_GUIDisable($Form1)
		 EndIf
	  Case $iLink
		  If $nicehash >0 then
			 			   ShellExecute("http://3xd.eu/mine")
						else
						   ShellExecute("http://xmr.3dns.eu")
			   Endif

   Case $iOpen
ConsoleWrite("up" & @CRLF)
$ok = GUISetState(@SW_SHOW)
ConsoleWrite($ok & @CRLF)
	  EndSwitch
	     		 If TimerDiff($hTimer) > 5*1000 Then
		 Local $Timer = TimerInit()
		 If ProcessExists("xmrig.exe") Then
		 $aArray = HashrateCPU()
		 $cData = 'CPU: ' & $aArray
		 TrayItemSetText($iStatusHashrateCPU, $cData)
		 GUICtrlSetData($LabelShowHashrateCPU,$cData)
	  Else
		 TrayItemSetText($iStatusHashrateGPU, "CPU: 0")
		 GUICtrlSetData($LabelShowHashrateGPU,"CPU: 0")
		 	  EndIf
		 If ProcessExists("xmrig-amd.exe") Then
							 $bArray = HashrateGPU()
							 $gData = 'GPU: ' & $bArray
							 TrayItemSetText($iStatusHashrateGPU, $gData)
							 GUICtrlSetData($LabelShowHashrateGPU,$gData)
	  Else
		 TrayItemSetText($iStatusHashrateGPU,"GPU: 0")
		 GUICtrlSetData($LabelShowHashrateGPU, "GPU: 0")
	  	  EndIf
			Local $hTimer = TimerInit()
    EndIf
WEnd