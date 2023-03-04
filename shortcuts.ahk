#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

SetTitleMatchMode, RegEx

; Delete entire line
!Backspace::Send {ShiftDown}{Home}{ShiftUp}{Del}

; Caps Lock -> Ctrl
CapsLock::Ctrl
LCtrl::CapsLock

; Activates window according to user prompt
!space::
; ^space above means Ctrl + space.
InputBox, t, Find Window, , , 200, 90
; t is the user input
; u is the user input plus the "case insensitive" flag
u=i)%t%
WinActivate %u%
return

; Switch to Hyper
#q::
if WinExist("Hyper$")
     WinActivate
return

; Switch to Chrome window
#space::
SetTitleMatchMode, RegEx
if WinExist("Google Chrome", "", "Jupyter Notebook", "")
    WinActivate
else
    run "C:\Shortcuts\Chrome"
return

; Switch to Jupyter notebook
#j::
if WinExist("Jupyter Notebook")
    WinActivate
else if WinExist("hku/pub/")
    WinActivate
return

; Switch to Messenger window
#m::
SetTitleMatchMode, RegEx
if WinExist("Messenger$")
    WinActivate
else
    run "C:\Shortcuts\Messenger"
return

; Switch to Messenger call window
#c::
SetTitleMatchMode, RegEx
if WinExist("Messenger Call")
    WinActivate
return

; Switch to VSCode
#s::
SetTitleMatchMode, RegEx
if WinExist("Visual Studio Code")
    WinActivate
return

; Switch to Discord window
#d::
SetTitleMatchMode, RegEx
if WinExist("Discord")
    WinActivate
else
    run "C:\Shortcuts\Discord"
return

; Switch to Notion
#n::
if WinExist("ahk_exe Notion.exe")
    WinActivate
else
    run "C:\Shortcuts\Notion"
return

; Switch to Spotify
#y::
if WinExist("ahk_exe Spotify.exe")
    WinActivate
else
    run "C:\Shortcuts\Spotify"
return

; Switch to 1Password
#1::
if WinExist("1Password")
    WinActivate
else
    run "C:\Shortcuts\1Password"
return

; Switch to League
#p::
if WinExist("League of Legends")
    WinActivate
else
    run "C:\Shortcuts\League"
return

; Switch to Sibelius
#b::
if WinExist("Sibelius 7.5")
    WinActivate
return

; WINDOW MANAGER

; code originally copied from https://gist.github.com/tholden/37a0d118b67b019a4dd3
; use Windows Key + Alt + Up/Down to place a window into top/bottom half of the screen

SnapActiveWindow(winPlaceVertical) {
    WinGet activeWin, ID, A
    activeMon := GetMonitorIndexFromWindow(activeWin)

    WinGetTitle, Title, A
    offset := 10
    if Instr("Excel", Title)
        offset := 0

    SysGet, MonitorWorkArea, MonitorWorkArea, %activeMon%

    height := (MonitorWorkAreaBottom - MonitorWorkAreaTop) / 2 + offset/2
    posX  := MonitorWorkAreaLeft - offset
    width := MonitorWorkAreaRight - MonitorWorkAreaLeft + 2*offset

    if (winPlaceVertical == "bottom") {
        posY := MonitorWorkAreaBottom - height
    } else if (winPlaceVertical == "top") {
        posY := MonitorWorkAreaTop
    }

    if (winPlaceVertical == "full") {
        WinGet,WinState,MinMax,A
        if Winstate = 1
            WinRestore A
        else
            WinMaximize A
    } else {
        WinRestore A
        WinMove,A,,%posX%,%posY%,%width%,%height%
    }
}

/**
 * GetMonitorIndexFromWindow retrieves the HWND (unique ID) of a given window.
 * @param {Uint} windowHandle
 * @author shinywong
 * @link http://www.autohotkey.com/board/topic/69464-how-to-determine-a-window-is-in-which-monitor/?p=440355
 */
GetMonitorIndexFromWindow(windowHandle) {
    ; Starts with 1.
    monitorIndex := 1

    VarSetCapacity(monitorInfo, 40)
    NumPut(40, monitorInfo)

    if (monitorHandle := DllCall("MonitorFromWindow", "uint", windowHandle, "uint", 0x2))
        && DllCall("GetMonitorInfo", "uint", monitorHandle, "uint", &monitorInfo) {
        monitorLeft   := NumGet(monitorInfo,  4, "Int")
        monitorTop    := NumGet(monitorInfo,  8, "Int")
        monitorRight  := NumGet(monitorInfo, 12, "Int")
        monitorBottom := NumGet(monitorInfo, 16, "Int")
        workLeft      := NumGet(monitorInfo, 20, "Int")
        workTop       := NumGet(monitorInfo, 24, "Int")
        workRight     := NumGet(monitorInfo, 28, "Int")
        workBottom    := NumGet(monitorInfo, 32, "Int")
        isPrimary     := NumGet(monitorInfo, 36, "Int") & 1

        SysGet, monitorCount, MonitorCount

        Loop, %monitorCount% {
            SysGet, tempMon, Monitor, %A_Index%

            ; Compare location to determine the monitor index.
            if ((monitorLeft = tempMonLeft) and (monitorTop = tempMonTop)
                and (monitorRight = tempMonRight) and (monitorBottom = tempMonBottom)) {
                monitorIndex := A_Index
                break
            }
        }
    }

    return %monitorIndex%
}

; Directional Arrow Hotkeys
#Up::SnapActiveWindow("top")
#Down::SnapActiveWindow("bottom")
#f::SnapActiveWindow("full")
