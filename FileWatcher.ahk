#Requires AutoHotkey v2.0+
#SingleInstance Force
#Warn

#Include Logger.ahk
#Include FileWatcherLogic.ahk
#Include ContextMenu.ahk

; ---------- Initialization ----------
InitLogs()
TraySetIcon("shell32.dll", 23) ; Magnifying glass icon

; ---------- GUI Setup ----------
global MainGui := Gui("+Resize +MinSize400x300", "File Watcher")
MainGui.MarginX := 15
MainGui.MarginY := 15
MainGui.OnEvent("Size", Gui_Size)
MainGui.OnEvent("Close", (*) => ExitApp())

; Buttons Row
BtnWatch := MainGui.Add("Button", "vBtnWatch", "👁️ Open File")
BtnWatch.OnEvent("Click", SelectFile)

global BtnAction := MainGui.Add("Button", "x+10 vBtnAction Disabled", "▶️ Start Watching")
BtnAction.OnEvent("Click", ToggleWatchAction)

; Context Menu Button (Far Right)
ctxLabel := IsContextMenuRegistered() ? "🗑️ Unregister Context Menu" : "✍️ Register Context Menu"
BtnCtx := MainGui.Add("Button", "yp w210 vBtnCtx", ctxLabel) ; Increased width for icon and text
BtnCtx.OnEvent("Click", OnContextMenuClick)

; File Path Label
LblPath := MainGui.Add("Text", "xm y+10 w100 vLblPath", "No file selected.")

; File Content Edit
MainGui.SetFont("s12", "Consolas") ; Set a larger, monospaced font
EditContent := MainGui.Add("Edit", "xm y+10 w100 h100 Multi ReadOnly vEditContent +BackgroundFFFFFF")
MainGui.SetFont() ; Reset font

; DPI Awareness and Window Sizing (75% of screen)
MonitorGetWorkArea(, &WL, &WT, &WR, &WB)
MonitorWidth := WR - WL
MonitorHeight := WB - WT
ScaleFactor := A_ScreenDPI / 96
Width := Round((MonitorWidth * 0.75) / ScaleFactor)
Height := Round((MonitorHeight * 0.75) / ScaleFactor)

MainGui.Show(Format("w{1} h{2} Center", Width, Height))
LogDebug("Application started and GUI initialized.")

; Handle command line if file passed
HandleCommandLineArgs()

; ---------- GUI Specific Functions ----------

Gui_Size(thisGui, minMax, width, height) {
    if (minMax = -1) ; Minimized
        return
    
    margin := thisGui.MarginX
    ctrlWidth := width - (2 * margin)
    
    ; Position Register button far right, aligned with Watch button
    thisGui["BtnWatch"].GetPos(, &by)
    thisGui["BtnCtx"].GetPos(,, &bw)
    thisGui["BtnCtx"].Move(width - margin - bw, by)
    
    ; Move Label
    thisGui["LblPath"].Move(,, ctrlWidth)
    
    ; Get positions for calculation: GetPos(&x, &y, &w, &h)
    thisGui["LblPath"].GetPos(, &ly, , &lh)
    
    editY := ly + lh + 10
    editH := height - editY - margin
    
    ; Move Edit box
    thisGui["EditContent"].Move(margin, editY, ctrlWidth, editH)
}

SelectFile(*) {
    global G_WatchedFile, G_LastModified
    
    selectedFile := FileSelect(3,, "Select a file to watch", "All Files (*.*)")
    if (selectedFile = "") {
        LogDebug("File selection cancelled.")
        return
    }
    
    G_WatchedFile := selectedFile
    G_LastModified := "" ; Reset to force reload
    
    MainGui["LblPath"].Value := "Watching: " . G_WatchedFile
    MainGui["BtnAction"].Enabled := true
    
    ; Load initial content
    try {
        MainGui["EditContent"].Value := FileRead(G_WatchedFile)
    } catch {
        MainGui["EditContent"].Value := ""
    }
    
    LogDebug("Selected file: " . G_WatchedFile)
    StartWatching() ; Auto-start watching
}

OnContextMenuClick(thisBtn, *) {
    ToggleContextMenu()
    registered := IsContextMenuRegistered()
    thisBtn.Text := registered ? "🗑️ Unregister Context Menu" : "✍️ Register Context Menu"
    
    ; Adjust position based on new text length
    MainGui.GetClientPos(,, &gw)
    thisBtn.GetPos(, &by, &bw)
    thisBtn.Move(gw - MainGui.MarginX - bw, by)
}
