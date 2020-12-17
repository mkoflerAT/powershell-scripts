# ================================================================================
# Author:   Markus Kofler (mkoflerAT)
# Website:  https://www.kofler-it.com
# Licence:  MIT
# Version:  1.0.0.0
# Date:     2020-11-11 03:00
# ================================================================================
# Requirements: None
# ================================================================================
# --------------------------------------------------------------------------------
# INSTALL functions for development - configure to your own needs
# --------------------------------------------------------------------------------
function Set-PreferredWindowsSettings()
{
    Push-Location
    Set-Location HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced

    # Show file-extensions
    # http://superuser.com/questions/666891/script-to-set-hide-file-extensions
    # 0 = Show extensions
    # 1 = Hide extensions
    Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name HideFileExt -Value 0

    # Don't combine windows on taskbar
    # https://superuser.com/questions/718766/setting-the-taskbar-buttons-to-combine-when-full-via-powershell
    Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced -Name TaskbarGlomLevel -Value 2

    # Show all systray-icons
    # https://superuser.com/questions/318088/make-specific-tray-icon-always-show-for-all-profiles-in-windows-7
    # 0 = AutoHide is off
    # 1 = AutoHide is on
    Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer -Name EnableAutoTray -Value 0

    # Show ribbon in explorer
    # https://www.tenforums.com/tutorials/42982-hide-show-file-explorer-ribbon-windows-10-a.html
    Set-ItemProperty -Path HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Ribbon -Name MinimizedStateTabletModeOff -Value 0

    Pop-Location

    # This will restart the Explorer service to make this work.
    Stop-Process -processName: Explorer -force
}

Set-PreferredWindowsSettings
