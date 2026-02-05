#Requires AutoHotkey v2.0+

global LOG_DEBUG := A_ScriptDir . "\debug.log"
global LOG_ERROR := A_ScriptDir . "\error.log"

InitLogs() {
    ;try FileDelete(LOG_DEBUG)
}

LogDebug(msg) {
    try {
        ;FileAppend(Format("[{1}] DEBUG: {2}`r`n", A_Now, msg), LOG_DEBUG)
    }
}