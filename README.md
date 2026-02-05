# File Watcher

A real-time file monitoring application built with AutoHotkey v2.0+. This tool allows you to watch any file for changes and instantly view its content in a dedicated GUI window.

## Features

- **Real-time file monitoring**: Automatically detects when a watched file is modified and updates the display
- **GUI interface**: Clean, user-friendly interface with file content display
- **Context menu integration**: Option to register a context menu entry for quick access
- **Command-line support**: Can be launched with a file path as an argument
- **Auto-refresh**: Monitors files every second for changes
- **Visual indicators**: Clear status indicators for watching/stopped states

## Requirements

- AutoHotkey v2.0+ (https://www.autohotkey.com/)

## Installation

1. Download the `FileWatcher.ahk` script and all associated `.ahk` files (`FileWatcherLogic.ahk`, `ContextMenu.ahk`, `Logger.ahk`)
2. Double-click `FileWatcher.ahk` to run the application

## Usage

### Basic Operation

1. Click the **"👁️ Open File"** button to select a file to monitor
2. The application will automatically start watching the file and display its content
3. Use the **"🛑 Stop Watching"** / **"▶️ Start Watching"** button to pause/resume monitoring
4. The file content will update automatically when changes are detected

### Context Menu Integration

- Click **"✍️ Register Context Menu"** to add "Open with File Watcher" to your Windows context menu
- This allows you to right-click any file and open it directly in the File Watcher
- Use **"🗑️ Unregister Context Menu"** to remove the context menu entry

### Command Line Usage

You can launch the application with a file path directly:

```
FileWatcher.ahk "C:\path\to\your\file.txt"
```

## Interface

- **File Path Display**: Shows the currently watched file and status
- **Content Display**: Real-time view of the file content in a monospaced font
- **Status Indicators**: Visual cues showing whether the file is being actively monitored

## Technical Details

- **Monitoring Interval**: Every 1000ms (1 second)
- **File Detection**: Uses file modification timestamp comparison

## Troubleshooting

- If the context menu option doesn't appear, try running the script as administrator
- Large files may take longer to refresh; consider monitoring smaller configuration files
- Make sure the file you're trying to watch is not exclusively locked by another process

## License

This project is open source and available under the MIT License.