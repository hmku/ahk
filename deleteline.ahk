; credit goes to GollyJer: https://stackoverflow.com/questions/46412932/how-do-i-delete-the-current-line-using-autohotkey
^Backspace:: DeleteCurrentLine() ; triggered by Alt+Backspace

DeleteCurrentLine() {
   SendInput {End}
   SendInput +{Home}
   If get_SelectedText() = "" {
      ; On an empty line.
      SendInput {Delete}
   } Else {
      SendInput ^+{Left}
      SendInput {Delete}
   }
}

get_SelectedText() {

    ; See if selection can be captured without using the clipboard.
    WinActive("A")
    ControlGetFocus ctrl
    ControlGet selectedText, Selected,, %ctrl%

    ;If not, use the clipboard as a fallback.
    If (selectedText = "") {
        originalClipboard := ClipboardAll ; Store current clipboard.
        Clipboard := ""
        SendInput ^c
        ClipWait .2
        selectedText := ClipBoard
        ClipBoard := originalClipboard
    }

    Return selectedText
}
