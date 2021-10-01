#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.

winStartX := 0, winStartY := 0, winEndX := 2000, winEndY := 2000
defaultDelay := 50
champName := "", chatText := "", banChampName := ""
autoAccept := 1, autoLockIn := 1, isAutoBanOn := 1, usePresetCoordinates := 0
presetsXmlFileName := "coordinates.xml"
presetSearchBarY := 0, presetSearchBarX := 0, presetChampIconX := 0, presetChampIconY := 0

`::
    ; MsgBox, %autoAccept% -autoAccept`n%autoLockIn% -autoLockIn`n
    ; InputBox, champName, Champion name, , , 200, 100
    InputBox, banChampName, Ban Champion name, , , 200, 100

    ; accept()

    banChamp(banChampName)

    waitForPickTurn()

    ; searchForChampion()

    ; selectChampion()

    ; lockIn()
return

\::
    ; presetIconsCoordinates()

    MsgBox, %autoAccept% -autoAccept`n%autoLockIn% -autoLockIn`n
    ;%usePresetCoordinates% -usePresetCoordinates
    InputBox, champName, Champion name, , , 200, 100
    InputBox, chatText, Chat text, , , 200, 100

    ; setWindowPos("League of Legends")

    accept()

    searchForChampion(selectChampName, false)

    selectChampion(selectChampName)

    lockIn()

    spamMessageInChat()
return



[::
    global autoAccept := 0
return

]::
    global autoLockIn := 0
return

'::
   global isAutoBanOn := 0
return

Esc::
    MsgBox, Exiting script...
    ExitApp
return

accept(){
    if (autoAccept){
        waitAndClickIconWhenVisible("acceptIcon.png")
        Sleep, defaultDelay
    }
}

lockIn(){
    if (autoLockIn){
        waitAndClickIconWhenVisible("lockInActiveIcon.png")
        Sleep, defaultDelay
    }
}

clickBan(){
    global isAutoBanOn
    if (isAutoBanOn){
        waitAndClickIconWhenVisible("banButton.png")
        Sleep, defaultDelay
    }
}

presetIconsCoordinates(){
    global presetsXmlFileName
    FileRead, xml, %presetsXmlFileName%

    doc := ComObjCreate("MSXML2.DOMDocument.6.0")
    doc.async := false
    doc.loadXML(xml)
    
    DocNode := doc.selectSingleNode("//Coordinates/SearchBarIcon")
    global presetSearchBarX := DocNode.getAttribute("x")
    global presetSearchBarY := DocNode.getAttribute("y")

    DocNode := doc.selectSingleNode("//Coordinates/ChampIcon")
    global presetChampIconX := DocNode.getAttribute("x")
    global presetChampIconY := DocNode.getAttribute("y")
}

searchForChampion(champName, isBanScreen){
    global usePresetCoordinates, presetSearchBarX, presetSearchBarY

    if (usePresetCoordinates){
        ;needs to wait until it can click it
        MouseClick, ,presetSearchBarX, presetSearchBarY
    }
    else{
        if(isBanScreen){
            waitAndClickIconWhenVisible("searchBarIcon-banScreen.png")
        }
        else{
            waitAndClickIconWhenVisible("searchBarIcon.png")
        }
    }

    Sleep, defaultDelay
    Send, %champName%
}

selectChampion(champName){
    global usePresetCoordinates, presetChampIconX, presetChampIconY

    iconName = %champName%.png

    if (usePresetCoordinates){
        ;needs to wait until it can click it
        MouseClick, ,presetChampIconX, presetChampIconY
    }
    else{    
        waitAndClickIconWhenVisible(iconName)
    }

    Sleep, defaultDelay
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

banChamp(champName){
    waitAndClickIconWhenVisible("banChampionBanner.png")
    searchForChampion(champName, true)
    selectChampion(champName)
    clickBan()
}

waitForPickTurn(){
    waitAndClickIconWhenVisible("chooseYourChampionBanner.png")
}


mouseShowCoordinates(x1, y1, x2, y2){
    MouseMove, x1, y1
    Sleep, 500
    MouseMove, x2, y2
    Sleep, 500
}