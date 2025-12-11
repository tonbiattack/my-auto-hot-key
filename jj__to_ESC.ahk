#Requires AutoHotkey v2.0

global lastJTime := 0

j:: {
    global lastJTime
    curr := A_TickCount

    ; 前回の j から300ms以内なら Esc
    if (curr - lastJTime < 300) {
        Send "{Esc}"
        lastJTime := 0
        return
    }

    ; 1回目の j は普通に j を入力して、時刻を記録
    Send "j"
    lastJTime := curr
}
