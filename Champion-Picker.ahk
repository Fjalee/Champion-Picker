#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


winStartX := 0, winStartY := 0, winEndX := 0, winEndY := 0

.::
    setWindowPos("League of Legends")
return

setWindowPos(winName){
    WinGetPos, X, Y, widht, height, %winName%
    global winEndX := widht
    global winEndY := height
}