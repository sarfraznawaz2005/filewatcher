#Requires AutoHotkey v2.0+

global CONTEXT_MENU_KEY := "Software\Classes\*\shell\FileWatcher"
global CONTEXT_MENU_NAME := "Watch with File Watcher"

IsContextMenuRegistered() {
    try {
        ; Check if the command key exists specifically
        RegRead("HKEY_CURRENT_USER\" . CONTEXT_MENU_KEY . "\command")
        return true
    } catch {
        return false
    }
}

ToggleContextMenu() {
    if IsContextMenuRegistered() {
        UnregisterContextMenu()
        return false
    } else {
        RegisterContextMenu()
        return true
    }
}

RegisterContextMenu() {
    exePath := '"' . A_AhkPath . '"'
    scriptPath := '"' . A_ScriptFullPath . '"'
    ; Command must be: "PathToAhk.exe" "PathToScript.ahk" "%1"
    command := exePath . ' ' . scriptPath . ' "%1"'
    iconPath := "shell32.dll,22"
    
    try {
        ; Create the key and set the display name (Default value)
        RegWrite(CONTEXT_MENU_NAME, "REG_SZ", "HKEY_CURRENT_USER\" . CONTEXT_MENU_KEY)
        ; Set the Icon value
        RegWrite(iconPath, "REG_SZ", "HKEY_CURRENT_USER\" . CONTEXT_MENU_KEY, "Icon")
        ; Create the command subkey
        RegWrite(command, "REG_SZ", "HKEY_CURRENT_USER\" . CONTEXT_MENU_KEY . "\command")
        LogDebug("Context menu registered with icon: " . command)
    } catch as e {
        LogDebug("Error registering context menu: " . e.Message)
    }
}

UnregisterContextMenu() {
    try {
        ; Must delete subkeys first in AHK v2 RegDeleteKey
        try RegDeleteKey("HKEY_CURRENT_USER\" . CONTEXT_MENU_KEY . "\command")
        RegDeleteKey("HKEY_CURRENT_USER\" . CONTEXT_MENU_KEY)
        LogDebug("Context menu unregistered successfully.")
    } catch as e {
        LogDebug("Error unregistering context menu: " . e.Message)
    }
}
