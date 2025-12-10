#Requires AutoHotkey v2.0

global lastJTime := 0

; -----------------------------------------
; jj → Esc（300ms以内）
; -----------------------------------------
j:: {
    global lastJTime

    curr := A_TickCount

    ; 前回の j から300ms以内なら Esc
    if (curr - lastJTime < 300) {
        Send "{Esc}"
        lastJTime := 0
        return
    }

    ; 時刻を記録
    lastJTime := curr
}
