#Requires AutoHotkey v2.0

; jj と打ったら jj を消して Esc にする
:*:jj:: {
    Send "{Backspace 2}"  ; jj を削除
    Send "{Esc}"
}
