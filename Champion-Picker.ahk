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

clickOnIcon(iconName){
    ImageSearch, OutputVarX, OutputVarY, winStartX, winStartY, winEndX, winEndY, *10 %iconName%
    if (ErrorLevel = 0){
        MouseClick , , OutputVarX, OutputVarY
        return 1
    }
    else if (ErrorLevel = 1){
        return 0
    }
    else    
        MsgBox, Error2 clickOnIcon func
}

waitAndClickIconWhenVisible(iconName){
    isVisible := 0
    while (isVisible = 0){
        isVisible := clickOnIcon(iconName)
        Sleep, 10
    }
}






mouseShowCoordinates(x1, y1, x2, y2){
    MouseMove, x1, y1
    Sleep, 500
    MouseMove, x2, y2
    Sleep, 500
}