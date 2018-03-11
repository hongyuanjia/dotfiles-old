; 打开gVim并最大化
#v::
DetectHiddenWindows, on
IfWinNotExist ahk_class Vim
	Run, c:\Program Files\Vim\Vim80\gvim.exe,,max
Else
IfWinNotActive ahk_class Vim
	WinActivate
Else
	WinMinimize
Return

; 打开Spacemacs并最大化
#s::
DetectHiddenWindows, on
IfWinNotExist ahk_class Emacs
	Run, c:\Program Files\Emacs\runemacs.lnk,,max
Else
IfWinNotActive ahk_class Emacs
	WinActivate
Else
	WinMinimize
Return

; 打开TC并最大化
#t::
DetectHiddenWindows, on
IfWinNotExist ahk_class TTOTAL_CMD
	Run, C:\Users\hongy\TotalCMD\Totalcmd.exe,,max
Else
IfWinNotActive ahk_class TTOTAL_CMD
	WinActivate
Else
	WinMinimize
Return

; 打开Everything并最大化
#f::
DetectHiddenWindows, on
IfWinNotExist ahk_class EVERYTHING
	Run, c:\Program Files\Everything\Everything.exe,,max
Else
IfWinNotActive ahk_class EVERYTHING
	WinActivate
Else
	WinMinimize
Return

; 切换到Rgui
#+r::
DetectHiddenWindows, on
IfWinNotActive ahk_exe Rgui.exe
	WinActivate
Else
	WinMinimize
return

; 打开Visual Studio Code并最大化
#c::
if WinExist("ahk_exe code.exe")
	{
		if WinActive("ahk_exe code.exe")
		{
			WinMinimize
		}
		else
		{	
			WinActivate
		}
	}	
else
	Run, c:\VSCode\Code.exe,,max
return

; 打开Zotero并最大化
#z::
SetTitleMatchMode, 2
IfWinNotExist, Zotero ahk_class MozillaWindowClass
	Run, C:\Program Files (x86)\Zotero Standalone\zotero.exe,,max
IfWinNotActive, Zotero ahk_class MozillaWindowClass
	WinActivate
Else
	WinMinimize
SetTitleMatchMode, 1
Return

; 打开LyX并最大化
#+l::
IfWinNotExist ahk_exe lyx.exe
	Run, C:\LyX 2.2\bin\lyx.exe,,max
Else
IfWinNotActive ahk_exe lyx.exe
	WinActivate
Else
	WinMinimize
Return

;-------------------------------------------------------------------------------------------------------------
; Word中自评估报告相关快捷操作（完成自评估后删除）
; #z::
; SetKeyDelay, 40
; Send,{ALT}fhij
; Return

;~ +!`::
;~ SetKeyDelay, 40
;~ Send,{ALT}
;~ Send,op
;~ Send,{ALTDown}i{ALTUp}
;~ Send,{TAB 2}
;~ Send,{UP 5}{ENTER 2}
;~ Return

;~ +!1::
;~ SetKeyDelay, 40
;~ Send,{ALT}
;~ Send,op
;~ Send,{ALTDown}i{ALTUp}
;~ Send,{TAB 2}
;~ Send,{Down 2}{ENTER 2}
;~ Return

;~ +!2::
;~ SetKeyDelay, 40
;~ Send,{ALT}
;~ Send,op
;~ Send,{ALTDown}i{ALTUp}
;~ Send,{TAB 2}
;~ Send,{Down 3}{ENTER 2}
;~ Return

;~ +!3::
;~ SetKeyDelay, 40
;~ Send,{ALT}
;~ Send,op
;~ Send,{ALTDown}i{ALTUp}
;~ Send,{TAB 2}
;~ Send,{Down 4}{ENTER 2}
;~ Return
