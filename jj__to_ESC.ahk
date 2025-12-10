#Requires AutoHotkey v2.0

global lastJTime := 0

; -----------------------------------------
; jj → Esc（300ms以内）
; それ以外は通常の j を出力
; -----------------------------------------
j::
{
    global lastJTime
    curr := A_TickCount

    ; 前回 j から 300ms 以内＝ jj と判定
    if (curr - lastJTime < 300) {
        Send "{Esc}"
        lastJTime := 0
        return
    }

    ; ここで「次のキー入力」を少しだけ待つ
    lastJTime := curr

    ; 300ms以内に再度 j が来なかったら、通常の j を送る
    KeyWait "j", "T0.3"   ; 300ms待つ
    if (A_Error) {
        ; タイムアウト → 2回目の j は来ていない
        Send "j"
        lastJTime := 0
    }

    return
}
