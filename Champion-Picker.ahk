#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


winStartX := 0, winStartY := 0, winEndX := 0, winEndY := 0
defaultDelay := 50
champName := "", chatText := ""
autoAccept := 1, autoLockIn := 1

.::
    MsgBox, %autoAccept% -autoAccept`n%autoLockIn% -autoLockIn
    InputBox, champName, Champion name, , , 200, 100
    InputBox, chatText, Chat text, , , 200, 100

    setWindowPos("League of Legends")

    if (autoAccept){
        waitAndClickIconWhenVisible("acceptIcon.png")
        Sleep, defaultDelay
    }

    searchForChampion()

    waitAndClickIconWhenVisible("champIcon.png")
    Sleep, defaultDelay

    if (autoLockIn){
        waitAndClickIconWhenVisible("lockInActiveIcon.png")
        Sleep, defaultDelay
    }

    spamMessageInChat()
return

[::
    global autoAccept := 0
return

]::
    global autoLockIn := 0
return

Esc::
    MsgBox, Exiting script...
    ExitApp
return

searchForChampion(){
    global champName
    waitAndClickIconWhenVisible("searchBarIcon.png")
    Sleep, defaultDelay
    Send, %champName%
}

spamMessageInChat(){
    global chatText
    waitAndClickIconWhenVisible("chatBarIcon.png")
    Sleep, defaultDelay
    Loop 10{
        SendInput, %chatText% 
        Sleep, 10
        SendInput, {Enter}
        Sleep, 50
    }
}

setWindowPos(winName){
    WinGetPos, X, Y, widht, height, %winName%
    global winEndX := widht
    global winEndY := height
}

clickOnIcon(iconName){
    global winStartX, winStartY, winEndX, winEndY
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