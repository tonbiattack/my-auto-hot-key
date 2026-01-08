; =============================================================================
; IMEオフスクリプト
; Altキーの単押しでIMEをオフにするスクリプト
; =============================================================================

#NoEnv

; ============================================================
; オプション設定
; ============================================================
; Altキーを長押しした際の動作を有効にするかどうか
LongPressAltEnabled := False

; キー送信モードとディレイの設定
SendMode Input
SetKeyDelay, -1

; ============================================================
; 状態変数の初期化
; ============================================================
LAltState := "Off" ; 左Altキーの状態: Off | Tapping | Pressing
RAltState := "Off" ; 右Altキーの状態: Off | Tapping | Pressing
QueuedKey := ""    ; Alt押下中に入力されたキーを一時的に保存

; ============================================================
; Alt+文字キーの処理(キューに追加)
; Altキーがタップ状態の時のみ有効
; ============================================================
#If (LAltState = "Tapping") || (RAltState = "Tapping")
    !a::QueuedKey := QueuedKey . "a"
    !b::QueuedKey := QueuedKey . "b"
    !c::QueuedKey := QueuedKey . "c"
    !d::QueuedKey := QueuedKey . "d"
    !e::QueuedKey := QueuedKey . "e"
    !f::QueuedKey := QueuedKey . "f"
    !g::QueuedKey := QueuedKey . "g"
    !h::QueuedKey := QueuedKey . "h"
    !i::QueuedKey := QueuedKey . "i"
    !j::QueuedKey := QueuedKey . "j"
    !k::QueuedKey := QueuedKey . "k"
    !l::QueuedKey := QueuedKey . "l"
    !m::QueuedKey := QueuedKey . "m"
    !n::QueuedKey := QueuedKey . "n"
    !o::QueuedKey := QueuedKey . "o"
    !p::QueuedKey := QueuedKey . "p"
    !q::QueuedKey := QueuedKey . "q"
    !r::QueuedKey := QueuedKey . "r"
    !s::QueuedKey := QueuedKey . "s"
    !t::QueuedKey := QueuedKey . "t"
    !u::QueuedKey := QueuedKey . "u"
    !v::QueuedKey := QueuedKey . "v"
    !w::QueuedKey := QueuedKey . "w"
    !x::QueuedKey := QueuedKey . "x"
    !y::QueuedKey := QueuedKey . "y"
    !z::QueuedKey := QueuedKey . "z"
#If

; ============================================================
; 左Altキーの処理
; ============================================================
~LAlt:
    If (LAltState = "Off") {
        ; F14キーを送信してIMEをオフにする
        Send {Blind}{F14}
        LAltState := "Tapping"
        ; 0.2秒待機(長押しかタップかを判定)
        KeyWait, LAlt, T0.2
        If ErrorLevel {
            ; タイムアウト = 長押しと判定
            LAltState := "Pressing"
            If (QueuedKey != "") 
                Send, {Blind}%QueuedKey%
            If LongPressAltEnabled {
                KeyWait, LAlt
                If (A_PriorKey = "LAlt") 
                    Send, {LAlt}
            }
        } Else {
            ; タップと判定
            If (QueuedKey = "" || (A_PriorKey != "LAlt" && GetKeyState(A_PriorKey, "P")))
                Send, {Blind}{vk1D}%QueuedKey%  ; 無変換キー(vk1D)を送信
            Else
                Send, {Blind}{LAlt DownR}%QueuedKey%{LAlt up}  ; Alt+キーとして送信
        }
        ; 状態をリセット
        QueuedKey := ""
        LAltState := "Off"
    }
    Return

; ============================================================
; 右Altキーの処理
; ============================================================
~RAlt:
    If (RAltState = "Off") {
        ; F14キーを送信してIMEをオフにする
        Send {Blind}{F14}
        RAltState := "Tapping"
        ; 0.2秒待機(長押しかタップかを判定)
        KeyWait, RAlt, T0.2
            ; タイムアウト = 長押しと判定
            RAltState := "Pressing"
            If (QueuedKey != "")
                Send, {Blind}%QueuedKey%
            If LongPressAltEnabled {
                KeyWait, RAlt
                If (A_PriorKey = "RAlt") 
                    Send, {RAlt}
            }
        } Else {
            ; タップと判定
            If (QueuedKey = "" || (A_PriorKey != "LAlt" && GetKeyState(A_PriorKey, "P")))
                Send, {Blind}{vk1C}%QueuedKey%  ; 変換キー(vk1C)を送信
            Else
                Send, {Blind}{RAlt DownR}%QueuedKey%{RAlt up}  ; Alt+キーとして送信
        }
        ; 状態をリセット
        QueuedKey := ""
        RAltState := "Off"
    }
    Return