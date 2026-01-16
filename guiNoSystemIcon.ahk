#Requires AutoHotkey v1.1.35+
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
    static _ := VersionManager_guiNoSystemIcon._init()
    _init()    {
        global
        GUINOSYSTEMICON_VERSION := "1.0.0"
    }
}
guiNoSystemIcon(guiName:="", byRef hr:="")    {
    static WTA_NONCLIENT:=1
        ,WTNCA_NODRAWCAPTION:=0x00000001, WTNCA_NODRAWICON:=0x00000002, WTNCA_NOSYSMENU:=0x00000004, WTNCA_NOMIRRORHELP:=0x00000008
        ,S_OK:=0x00000000
    hr:=""
    gui % (guiName!==""?guiName:A_DefaultGui) ":+LastFoundExist"
    if !(hwnd:=winExist())
        return false
    eAttribute:=WTA_NONCLIENT
    varSetCapacity(pvAttribute,cbAttribute:=8,0), dwFlags:= dwMask:= 0
    dwFlags|=WTNCA_NODRAWICON|WTNCA_NOSYSMENU       ,numPut(dwFlags,pvAttribute,0,"UInt")
    dwMask|=WTNCA_NODRAWICON|WTNCA_NOSYSMENU        ,numPut(dwMask,pvAttribute,4,"UInt")	
    hr:=dllCall("UxTheme.dll\SetWindowThemeAttribute"
        ,"Ptr",hwnd, "Int",eAttribute, "Ptr",&pvAttribute, "UInt",cbAttribute
        ,"Int")
    return (!errorLevel?hr==S_OK:false)
}