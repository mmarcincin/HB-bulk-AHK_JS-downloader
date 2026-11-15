;HB_Bulk_AHK_JS_Downloader 0.0.1

#NoEnv
#SingleInstance Force
SetTitleMatchMode, 2

LogFile := A_ScriptDir . "\download_errors.log"
LastProcessedTitle := ""

DownloadDir := A_ScriptDir . "\downloads"
if (!DownloadDir) {
	FileCreateDir, %DownloadDir%
}

SetTimer, CheckBrowserTitle, 100
return

CheckBrowserTitle:
    ; Find any browser window containing the AHK_REQ| prefix
    IfWinExist, AHK_REQ|
    {
        WinGetTitle, FullTitle, AHK_REQ|
        
        ; Prevent processing the exact same title twice
        if (FullTitle = LastProcessedTitle) {
            return
        }
        LastProcessedTitle := FullTitle
        
        ; Split title by | (browser suffix at the end falls into Parts and is ignored)
        Parts := StrSplit(FullTitle, "|")
        BundleName := Parts[2]
        SpecificName := Parts[3]
        
        ; 1. Wait for the Save As dialog belonging to the browser (max 10 seconds)
        WinWaitActive, ahk_class #32770, , 10
        if (ErrorLevel) {
            LogError(LogFile, BundleName, SpecificName, "Timeout: Save As dialog did not appear within 10 seconds.")
            return
        }
        
        ; 2. Force and verify focus on the filename text field (Edit1) FIRST
        FocusedOK := false
        Loop, 15 {
            ControlFocus, Edit1, ahk_class #32770
            ControlGetFocus, FocusedCtrl, ahk_class #32770
            if (FocusedCtrl = "Edit1") {
                FocusedOK := true
                break
            }
            Sleep, 30
        }
        
        if (!FocusedOK) {
            LogError(LogFile, BundleName, SpecificName, "Failed to focus the filename text field (Edit1).")
            return
        }

        ; 3. Now read the original filename safely since Edit1 has guaranteed focus
        ControlGetText, OriginalFileName, Edit1, ahk_class #32770
        if (!OriginalFileName) {
            OriginalFileName := "download.file" ; Fallback just in case
        }
        
        ; 4. Evaluate total path length against Windows 260-character limit
        InitialPath := DownloadDir . "\" . BundleName . "\" . SpecificName . "\" . OriginalFileName
        FinalFileName := OriginalFileName
        
        if (StrLen(InitialPath) > 260) {
            SplitPath, OriginalFileName, , , OutExtension, OutNameNoExt
            
            PosHyphen := InStr(OutNameNoExt, "-")
            PosUnderscore := InStr(OutNameNoExt, "_")
            
            ValidPos := 0
            if (PosHyphen > 0 and PosUnderscore > 0)
                ValidPos := (PosHyphen < PosUnderscore) ? PosHyphen : PosUnderscore
            else if (PosHyphen > 0)
                ValidPos := PosHyphen
            else if (PosUnderscore > 0)
                ValidPos := PosUnderscore

            if (ValidPos > 0) {
                ShortBase := SubStr(OutNameNoExt, 1, ValidPos - 1)
            } else {
                ShortBase := SubStr(OutNameNoExt, 1, 20)
            }
            
            FinalFileName := ShortBase . (OutExtension ? "." . OutExtension : "")
        }
        
        ; 5. Check if path is still too long; if so, reduce SpecificName to 40 characters
        CheckPath2 := DownloadDir . "\" . BundleName . "\" . SpecificName . "\" . FinalFileName
        if (StrLen(CheckPath2) > 260) {
            SpecificName := SubStr(SpecificName, 1, 40)
        }
        
        ; 6. Establish final target directory and create it
        TargetDir := DownloadDir . "\" . BundleName . "\" . SpecificName
        FileCreateDir, %TargetDir%
        if (ErrorLevel) {
            LogError(LogFile, BundleName, SpecificName, "Failed to create directory (invalid name or path too long).")
            return
        }
        
        FullSavePath := TargetDir . "\" . FinalFileName
        
        ; 7. Copy path to clipboard with safe retry check
        ClipSaved := ClipboardAll
        Clipboard := ""
        Clipboard := FullSavePath
        ClipWait, 1  
		   
        ; 8. Select all, paste path, and save with stable delays
        ControlFocus, Edit1, ahk_class #32770
        Sleep, 50
        Send, ^a
        Sleep, 50
        Send, ^v
        Sleep, 150
        Send, !s ; Use !u if your Windows UI is in Slovak
        
        ; Restore original clipboard contents
        Clipboard := ClipSaved
        ClipSaved := ""
        
        ; 9. Handle potential "File Exists" overwrite prompt or normal closure
        Sleep, 300
        IfWinExist, Confirm Save As ahk_class #32770
        {
            ControlSend, Button1, {Enter}, Confirm Save As ahk_class #32770 ; Automatically click Yes/Overwrite if file exists
        }
        
        Sleep, 400
    }
return

; Helper function to append errors to the log file
LogError(FilePath, Bundle, Specific, Reason) {
    FormatTime, CurrentTime, , yyyy-MM-dd HH:mm:ss
    LogEntry := "[" . CurrentTime . "] Bundle: " . Bundle . " | Specific: " . Specific . " | Error: " . Reason . "`r`n"
    FileAppend, %LogEntry%, %FilePath%, UTF-8
}

; ==========================================
; SCRIPT CONTROLS
; ==========================================
#NumpadAdd::Suspend
^+r::Reload

#NumpadDiv::
^+s::
ExitApp
return
