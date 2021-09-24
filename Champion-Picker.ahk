#NoEnv  ; Recommended for performance and compatibility with future AutoHotkey releases.
; #Warn  ; Enable warnings to assist with detecting common errors.
SendMode Input  ; Recommended for new scripts due to its superior speed and reliability.
SetWorkingDir %A_ScriptDir%  ; Ensures a consistent starting directory.


winStartX := 0, winStartY := 0, winEndX := 0, winEndY := 0
defaultDelay := 50
champName := "", chatText := ""
autoAccept := 1, autoLockIn := 1, usePresetCoordinates := 1
presetsXmlFileName := "coordinates.xml"
presetSearchBarY := 0, presetSearchBarX := 0, presetChampIconX := 0, presetChampIconY := 0

\::
    presetIconsCoordinates()

    MsgBox, %autoAccept% -autoAccept`n%autoLockIn% -autoLockIn`n%usePresetCoordinates% -usePresetCoordinates
    InputBox, champName, Champion name, , , 200, 100
    InputBox, chatText, Chat text, , , 200, 100

    setWindowPos("League of Legends")

    if (autoAccept){
        waitAndClickIconWhenVisible("acceptIcon.png")
        Sleep, defaultDelay
    }

    searchForChampion()

    selectChamption()

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

'::
    global usePresetCoordinates := 0
return

Esc::
    MsgBox, Exiting script...
    ExitApp
return

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

searchForChampion(){
    global champName, usePresetCoordinates, presetSearchBarX, presetSearchBarY

    if (usePresetCoordinates){
        MouseClick, ,presetSearchBarX, presetSearchBarY
    }
    else{
        waitAndClickIconWhenVisible("searchBarIcon.png")
    }

    Sleep, defaultDelay
    Send, %champName%
}

selectChamption(){
    global champName, usePresetCoordinates, presetChampIconX, presetChampIconY

    if (usePresetCoordinates){
        MouseClick, ,presetChampIconX, presetChampIconY
    }
    else{    
        waitAndClickIconWhenVisible("champIcon.png")
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






mouseShowCoordinates(x1, y1, x2, y2){
    MouseMove, x1, y1
    Sleep, 500
    MouseMove, x2, y2
    Sleep, 500
}