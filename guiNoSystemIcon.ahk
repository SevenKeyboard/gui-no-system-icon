#Requires AutoHotkey v2.0.0+
;==============================================================
; guiNoSystemIcon — Removes the window icon and system menu from a GUI's non-client area
;
; GitHub: https://github.com/SevenKeyboard/gui-no-system-icon
; Author: SevenKeyboard Ltd. (2026)
; License: The Unlicense
;
; Documentation / References:
;   SetWindowThemeAttribute function (uxtheme.h)
;     https://learn.microsoft.com/en-us/windows/win32/api/uxtheme/nf-uxtheme-setwindowthemeattribute
;   WTA_OPTIONS structure (uxtheme.h)
;     https://learn.microsoft.com/en-us/windows/win32/api/uxtheme/ns-uxtheme-wta_options
;   WTNCA Values
;     https://learn.microsoft.com/en-us/windows/win32/controls/wtnca
;   Help with SetWindowThemeAttribute Function in Vista
;     https://www.autohotkey.com/board/topic/34827-help-with-setwindowthemeattribute-function-in-vista/
;   How to remove icon in GUI?
;     https://www.autohotkey.com/board/topic/73846-how-to-remove-icon-in-gui/
;==============================================================
class VersionManager_guiNoSystemIcon
{
    static _ := this._init()
    static _init()    {
        global
        GUINOSYSTEMICON_VERSION := "1.0.0"
    }
}
guiNoSystemIcon(hWnd_or_guiObj, &hr:="")    {
    static WTA_NONCLIENT:=1
        ,WTNCA_NODRAWCAPTION:=0x00000001, WTNCA_NODRAWICON:=0x00000002, WTNCA_NOSYSMENU:=0x00000004, WTNCA_NOMIRRORHELP:=0x00000008
        ,S_OK:=0x00000000
    hr:=""
    switch
    {
        case (hWnd_or_guiObj is gui):               hWnd:=hWnd_or_guiObj.Hwnd
        default:
            if (hWnd_or_guiObj~="D)^(?:[[:digit:]]+|(0[Xx][[:xdigit:]]+))$"
            && dllCall("User32.dll\IsWindow", "Ptr",hWnd_or_guiObj))
                hWnd:=hWnd_or_guiObj
    }
    if (!hWnd)
        return false
    eAttribute:=WTA_NONCLIENT
    pvAttribute:=buffer(cbAttribute:=8,0), dwFlags:= dwMask:= 0
    dwFlags|=WTNCA_NODRAWICON|WTNCA_NOSYSMENU       ,numPut("UInt",dwFlags,pvAttribute,0)
    dwMask|=WTNCA_NODRAWICON|WTNCA_NOSYSMENU        ,numPut("UInt",dwMask,pvAttribute,4)
    try  {
        hr:=dllCall("UxTheme.dll\SetWindowThemeAttribute"
            ,"Ptr",hwnd, "Int",eAttribute, "Ptr",pvAttribute.Ptr, "UInt",cbAttribute
            ,"Int")
    }  catch  {
        return false
    }  else  {
        return (hr==S_OK)
    }
}