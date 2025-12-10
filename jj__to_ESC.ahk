#Requires AutoHotkey v2.0

global lastJTime := 0

; -----------------------------------------
; jj → Esc（300ms以内・IMEがOFFのときだけ）
; -----------------------------------------
j:: {
    global lastJTime

    curr := A_TickCount

    ; 前回の j から300ms以内 && IMEがOFFなら Esc
    if (curr - lastJTime < 300 && !IME_IsOn()) {
        Send "{Esc}"
        lastJTime := 0
        return
    }

    ; 時刻を記録
    lastJTime := curr
}

; -----------------------------------------
; IME ON/OFF 判定（AutoHotkey v2 対応）
; -----------------------------------------
IME_IsOn(*) {
    hwnd := WinGetID("A")
    defaultIME := DllCall("imm32\ImmGetDefaultIMEWnd", "UInt", hwnd, "UInt")
    state := DllCall("SendMessage", "UInt", defaultIME, "UInt", 0x0283, "UInt", 0x0005, "UInt", 0)
    return state != 0 ; 1 = ON, 0 = OFF
}
