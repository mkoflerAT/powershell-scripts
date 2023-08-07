<#
    .SYNOPSIS
        Sets the target release version for Win10 to '22H2'. This script was created,
        because I was sick of getting my Win10 updated to Win11 without wanting to.
        This registry value should prevent Windows from being upgraded automatically
        to Win11. Feel free to adapt/use this script and share it amongst your peers.
        The websites tenforums.com provides addon material and shows additional ways
        to achieve the same result by doing it manually or by using .reg-files.

    .DESCRIPTION
        #===============================================================#
        # Name:     Set-Win10AsPreferredTargetVersion                   #
        # Version:  1.0                                                 #
        # Created:  2023-08-08 00:00                                    #
        # Updated:  2023-08-08 00:00                                    #
        # ===============================================================
        # Author:   Markus Kofler                                       #
        # Github:   https://www.github.com/mkoflerAT/                   #
        # LinkedIn: https://www.linkedin.com/in/mkoflerat/              #
        # Website:  https://www.kofler-it.com/                          #
        # ===============================================================

    .EXAMPLE
        # Run this script within an administrative Powershell from the folder it resides in:
        .\Set-Win10AsPreferredTargetVersion.ps1

    .LINK
        https://www.linkedin.com/in/mkoflerat/
        https://raw.githubusercontent.com/mkoflerAT/powershell-scripts/main/src/Set-Win10AsPreferredTargetVersion.ps1

    .LINK
        https://www.tenforums.com/tutorials/159624-how-specify-target-feature-update-version-windows-10-a.html

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

# check if running as administrator
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Warning "You need to run this script as (local) administrator!"
    exit
}
# define the registry values
$regPath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
$regValues = @{
    "TargetReleaseVersion" = 1
    "ProductVersion" = "Windows 10"
    "TargetReleaseVersionInfo" = "22H2"
}

# create the registry key if it doesn't exist
if (-not (Test-Path $regPath)) {New-Item -Path $regPath -Force}

# set the registry values
$regValues.GetEnumerator() | ForEach-Object {Set-ItemProperty -Path $regPath -Name $_.Key -Value $_.Value}
Write-Host "Registry values created:"
$regValues.GetEnumerator() | ForEach-Object {Write-Host "$($_.Key) = $($_.Value)"}

# force a group policy update
gpupdate /force
