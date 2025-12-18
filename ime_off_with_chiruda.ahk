#Requires AutoHotkey v2.0
LAlt & `::{
    Send "{vkF3}"
    Sleep 10
    if IME_GET()
        Send "{vkF3}"
}

IME_GET() {
    hwnd := WinExist("A")
    imeWnd := DllCall("imm32\ImmGetDefaultIMEWnd", "ptr", hwnd, "ptr")
    return DllCall("user32\SendMessageW", "ptr", imeWnd, "uint", 0x283, "ptr", 0x5, "ptr", 0, "ptr")
}
