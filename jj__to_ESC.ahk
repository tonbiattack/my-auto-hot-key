#Requires AutoHotkey v2.0

global lastJTime := 0

j::
{
    global lastJTime
    curr := A_TickCount

    ; jj 判定（300ms以内）
    if (curr - lastJTime < 300) {
        Send "{Esc}"
        lastJTime := 0
        return
    }

    lastJTime := curr

    ; KeyWait の戻り値：
    ;   true  = タイムアウト（→普通の j を送る）
    ;   false = キーが離された（→次の j に備える）
    timedOut := KeyWait("j", "T0.3")

    if (timedOut) {
        Send "j"
        lastJTime := 0
    }

    return
}
