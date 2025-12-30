; ime_off.ahk
; 目的: Altキーをタップ（短く押す）した場合に別のキー入力を受け取り、
; 長押しした場合は通常のAlt動作を維持するためのスクリプト。
; 主に日本語入力のON/OFFや修飾キーとしての利用を制御する用途を想定。

#NoEnv

; オプション: Altを長押し扱いで元のAltを送るかを切り替え
LongPressAltEnabled := False

; 送信モードと遅延の設定（安定してキーを送るための推奨設定）
SendMode Input
SetKeyDelay, -1

; 状態管理変数
; LAltState / RAltState: "Off" | "Tapping" | "Pressing"
;  - Off: 何も起こっていない状態
;  - Tapping: Altが押されて短時間で離されるかどうか判定中（タップ候補）
;  - Pressing: 長押し（修飾キーとして使用）と判定された状態
LAltState := "Off"
RAltState := "Off"

; タップ判定中に押された文字キーを一時保存するバッファ
QueuedKey := ""

; -----------------------------------------------------------------------------
; Tapping状態のときに、Alt+キーを押すとそのキーをQueuedKeyに追加する
; （例: Altをタップしてから `a` を押す → QueuedKey に "a" が蓄積される）
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

; -----------------------------------------------------------------------------
; 左Altの処理
; - 押下で一旦 F14 を送って発火（他のフック対策）
; - 短い時間（0.2秒）で離された場合はタップ扱いとして QueuedKey に従って
;   仮想Alt(vk1D) を組み合わせて送信する（Alt+キーの形にする）。
; - 0.2秒以内に離されなければ長押し扱い（Pressing）にし、QueuedKey を
;   単体で送る（修飾として使う場合の処理）。
; - `LongPressAltEnabled` を有効にすると、長押し後にさらに離したときに
;   本来の `LAlt` を送る動作になる。
~LAlt::
    If (LAltState = "Off") {
        Send {Blind}{F14}
        LAltState := "Tapping"
        KeyWait, LAlt, T0.2
        If ErrorLevel {
            ; タイムアウト -> 長押し判定
            LAltState := "Pressing"
            If (QueuedKey != "") 
                Send, {Blind}%QueuedKey%
            If LongPressAltEnabled {
                KeyWait, LAlt
                If (A_PriorKey = "LAlt") 
                    Send, {LAlt}
            }
        } Else {
            ; タップ判定 -> QueuedKey に応じた Alt+キー入力を送る
            ; vk1D は左Alt の仮想キーコード（低レベル送信）
            If (QueuedKey = "" || (A_PriorKey != "LAlt" && GetKeyState(A_PriorKey, "P")))
                Send, {Blind}{vk1D}%QueuedKey%
            Else
                Send, {Blind}{LAlt DownR}%QueuedKey%{LAlt up}
        }
        ; リセット
        QueuedKey := ""
        LAltState := "Off"
    }
    Return

; -----------------------------------------------------------------------------
; 右Altの処理（左Altと同様のロジック）
~RAlt::
    If (RAltState = "Off") {
        Send {Blind}{F14}
        RAltState := "Tapping"
        KeyWait, RAlt, T0.2
        If ErrorLevel {
            ; 長押し判定
            RAltState := "Pressing"
            If (QueuedKey != "")
                Send, {Blind}%QueuedKey%
            If LongPressAltEnabled {
                KeyWait, RAlt
                If (A_PriorKey = "RAlt") 
                    Send, {RAlt}
            }
        } Else {
            ; タップ判定 -> 右Alt用の仮想キーコード vk1C を使う
            If (QueuedKey = "" || (A_PriorKey != "LAlt" && GetKeyState(A_PriorKey, "P")))
                Send, {Blind}{vk1C}%QueuedKey%
            Else
                Send, {Blind}{RAlt DownR}%QueuedKey%{RAlt up}
        }
        QueuedKey := ""
        RAltState := "Off"
    }
    Return