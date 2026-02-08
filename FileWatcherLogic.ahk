#Requires AutoHotkey v2.0+

global G_WatchedFile := ""
global G_LastModified := ""
global G_TimerRunning := false

WatchTick() {
    global G_WatchedFile, G_LastModified, MainGui
    
    if (G_WatchedFile = "")
        return
        
    if FileExist(G_WatchedFile) {
        try {
            currentModified := FileGetTime(G_WatchedFile, "M")
            if (currentModified != G_LastModified) {
                contents := FileRead(G_WatchedFile)
                MainGui["EditContent"].Value := contents
                G_LastModified := currentModified
                LogDebug("File updated and reloaded: " . G_WatchedFile)
            }
        } catch as e {
            LogDebug("Error reading file: " . e.Message)
        }
    } else {
        ; File deleted
        if (MainGui["EditContent"].Value != "") {
            MainGui["EditContent"].Value := ""
            G_LastModified := ""
            LogDebug("Watched file not found. Cleared text field.")
        }
    }
}

StartWatching() {
    global G_TimerRunning, MainGui
    if (!G_TimerRunning) {
        SetTimer(WatchTick, 1000)
        G_TimerRunning := true
        LogDebug("Watcher timer started.")
    }
    MainGui["BtnAction"].Text := "🛑 Stop Watching"
    MainGui["LblPath"].SetFont("Bold") ; Removed green color
    WatchTick()
}

ToggleWatchAction(*) {
    global G_TimerRunning, MainGui, G_WatchedFile
    
    if (G_TimerRunning) { ; We are currently watching, so stop
        SetTimer(WatchTick, 0)
        G_TimerRunning := false
        LogDebug("Watcher timer stopped.")
        
        MainGui["BtnAction"].Text := "▶️ Start Watching"
        MainGui["LblPath"].Value := "Stopped watching: " . G_WatchedFile
        MainGui["LblPath"].SetFont()
    } else { ; We are stopped, so start
        MainGui["LblPath"].Value := "Watching: " . G_WatchedFile
        StartWatching()
    }
}

HandleCommandLineArgs() {
    global G_WatchedFile, G_LastModified, MainGui
    if (A_Args.Length >= 1) {
        filePath := A_Args[1]
        if FileExist(filePath) {
            G_WatchedFile := filePath
            G_LastModified := ""
            
            MainGui["LblPath"].Value := "Watching: " . G_WatchedFile
            MainGui["BtnAction"].Enabled := true
            MainGui["BtnClear"].Enabled := true
            
            try MainGui["EditContent"].Value := FileRead(G_WatchedFile)
            
            LogDebug("Started from command line with file: " . G_WatchedFile)
            StartWatching() ; Auto-start watching
        }
    }
}
