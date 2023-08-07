<#
    .SYNOPSIS
        Enables or disables the display of seconds in the system clock of the Windows taskbar for Windows 10.

    .DESCRIPTION
        #===============================================================#
        # Name:     Set-TaskbarClockSeconds                             #
        # Version:  1.0                                                 #
        # Created:  2023-08-08 00:00                                    #
        # Updated:  2023-08-08 00:00                                    #
        # ===============================================================
        # Author:   Markus Kofler                                       #
        # Github:   https://www.github.com/mkoflerAT/                   #
        # LinkedIn: https://www.linkedin.com/in/mkoflerat/              #
        # Website:  https://www.kofler-it.com/                          #
        # ===============================================================

    .PARAMETER Status
        Specifies whether to enable or disable the display of seconds in the taskbar clock. Valid values are "Enabled" or "Disabled".

    .EXAMPLE
        # This script is a helper-script, which means you have to import it.
        # This is achieved by dot-sourcing the script, which is similar to Import-Module.
        . .\Set-TaskbarClockSeconds.ps1

    .EXAMPLE
        Enable-SecondsInWin10Taskbar -Status Enabled
        Enables the display of seconds in the system clock of the Windows taskbar.

    .EXAMPLE
        Disable-SecondsInWin10Taskbar -Status Disabled
        Disables the display of seconds in the system clock of the Windows taskbar.

    .LINK
        https://www.linkedin.com/in/mkoflerat/
        https://raw.githubusercontent.com/mkoflerAT/powershell-scripts/main/src/Set-TaskbarClockSeconds.ps1

    .NOTES
        BSD 2-Clause License

        Copyright (c) 2023, Markus Kofler
        All rights reserved.

        Author:     Markus Kofler
        Github:     https://www.github.com/mkoflerAT
        LinkedIn:   https://www.linkedin.com/in/mkoflerat/
        Websites:   https://www.kofler-it.com

        Redistribution and use in source and binary forms, with or without
        modification, are permitted provided that the following conditions are met:

        1. Redistributions of source code must retain the above copyright notice, this
        list of conditions and the following disclaimer.

        2. Redistributions in binary form must reproduce the above copyright notice,
        this list of conditions and the following disclaimer in the documentation
        and/or other materials provided with the distribution.

        THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
        AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
        IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
        DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
        FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
        DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
        SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
        CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
        OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
        OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#>


function Set-TaskbarClockSeconds {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0)]
        [ValidateSet("Enabled", "Disabled")]
        [string]$Status
    )

    # check if the operating system is 'Windows 10'
    $osVersion = (Get-CimInstance Win32_OperatingSystem).Version

    if ($osVersion -notmatch '^10\.') {
        Write-Error "This script is intended for Windows 10 only. Aborting."
        return
    }

    $regPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced"
    $regName = "ShowSecondsInSystemClock"

    if ($Status -eq "Enabled") {
        $regValue = 1
        New-ItemProperty -Path $regPath -Name $regName -Value $regValue -Force
        Write-Host "Seconds in taskbar enabled."
    }
    elseif ($Status -eq "Disabled") {
        Remove-ItemProperty -Path $regPath -Name $regName -ErrorAction SilentlyContinue
        Write-Host "Seconds in taskbar disabled."
    }

    # stop all explorer processes to show/hide the seconds within the taskbar
    Get-Process explorer | Stop-Process
}
