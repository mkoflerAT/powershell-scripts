<#
    .SYNOPSIS
        Gets your machine ready for development. This script has been built
        somewhen around 2020 and has gone through multiple iterations and
        various improvements and changed over time quite a bit. Feel free
        to adapt/use this script and share it amongst your peers.

    .DESCRIPTION
        #===============================================================#
        # Name:     Install-DevelopmentEnvironment.ps1                  #
        # Version:  1.1                                                 #
        # Created:  originally somewhen in 2020                         #
        # Updated:  2023-08-07 18:30                                    #
        # ===============================================================
        # Author:   Markus Kofler                                       #
        # Github:   https://www.github.com/mkoflerAT/                   #
        # LinkedIn: https://www.linkedin.com/in/mkoflerat/              #
        # Website:  https://www.kofler-it.com/                          #
        # ===============================================================

    .EXAMPLE
        # You can run this script by running these line(s) within an administrative Powershell (not an ISE!!!):
        # Set-ExecutionPolicy Bypass -Scope Process -Force; iwr -useb 'https://tinyurl.com/Install-DevEnvironment' | iex

    .LINK
        https://www.linkedin.com/in/mkoflerat/
        https://raw.githubusercontent.com/mkoflerAT/powershell-scripts/main/src/Install-DevelopmentEnvironment.ps1

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

if ($host.Name -like '*ISE*') {
    Write-Warning "You need to run this script from a normal PowerShell - not an ISE!"
    exit
}

# prompt user for git user name and email
$gitUserName = Read-Host 'Enter your name (e.g. John Smith)'
$gitUserEmail = Read-Host 'Enter your email (e.g. john.smith@contoso.com)'

# set the PSGallery as a trusted installation location  
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted

# install all the modules required
# $env:PSModuleAutoLoadingPreference = 'All'
Set-PSRepository -Name PSGallery -InstallationPolicy Trusted
Install-PackageProvider -Name NuGet -Force -Scope AllUsers
Install-Module -Scope AllUsers -Force -Name AzureAD
Install-Module -Scope AllUsers -Force -Name MSOnline
Install-Module -Scope AllUsers -Force -Name ExchangeOnlineManagement
Install-Module -Scope AllUsers -Force -Name Microsoft.Graph
Install-Module -Scope AllUsers -Force -Name MicrosoftTeams

# start timer
$dateStart = Get-Date

# create a PowerShell profile if needed
if(!(Test-Path $PROFILE)) {
    New-Item -Type File -Force "$PROFILE"
    '# PowerShell-Profile' > $PROFILE
}

# install or upgrade chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force
[System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco feature enable -n=allowGlobalConfirmation
choco upgrade chocolatey

# install basic programs everyone should have
$basicTools = @('7zip', 'brave', 'bleachbit', 'greenshot', 'keepass', 'keepassxc', 'putty', 'winscp')
choco install $basicTools

# install tools needed for development
$developmentTools = @('git', 'poshgit', 'vscode', 'dotnet-6.0-sdk', 'dotnet-sdk', 'nvm', 'jq', 'gpg4win')
choco install $developmentTools

# reload PATH-variable to make commands [code] [dotnet] [git] available
$envPathMachine = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
$evnPathUser = [System.Environment]::GetEnvironmentVariable("Path", "User")
$env:Path = $envPathMachine + ";" + $evnPathUser

# install .NET Core Tools for EntityFramework and opt out from telemetry
dotnet tool install --global dotnet-ef
dotnet tool install --global dotnet-aspnet-codegenerator
setx DOTNET_CLI_TELEMETRY_OPTOUT 1
dotnet ef --version

# configure git settings
git --version
git config --global user.name $gitUserName
git config --global user.email $gitUserEmail
git config --global core.autocrlf true
git config --global core.editor "code --wait --new-window"
git config --global init.defaultbranch main

# install extensions for vscode
code --install-extension ms-dotnettools.csharp           # https://marketplace.visualstudio.com/items?itemName=ms-dotnettools.csharp
code --install-extension ms-vscode.powershell            # https://marketplace.visualstudio.com/items?itemName=ms-vscode.PowerShell
code --install-extension mhutchie.git-graph              # https://marketplace.visualstudio.com/items?itemName=mhutchie.git-graph
code --install-extension donjayamanne.githistory         # https://marketplace.visualstudio.com/items?itemName=donjayamanne.githistory
code --install-extension huizhou.githd                   # https://marketplace.visualstudio.com/items?itemName=huizhou.githd
code --install-extension yzane.markdown-pdf              # https://marketplace.visualstudio.com/items?itemName=yzane.markdown-pdf
code --install-extension yzhang.markdown-all-in-one      # https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one
code --install-extension ionutvmi.reg                    # https://marketplace.visualstudio.com/items?itemName=ionutvmi.reg
code --install-extension coolbear.systemd-unit-file      # https://marketplace.visualstudio.com/items?itemName=coolbear.systemd-unit-file
code --install-extension vscode-icons-team.vscode-icons  # https://marketplace.visualstudio.com/items?itemName=vscode-icons-team.vscode-icons

# Add custom functions to profile
$customFunctions = @'
# ------------------------------------------------------------------------------------------------------------------------------------------------------
# Load coding-helper-functions
# ------------------------------------------------------------------------------------------------------------------------------------------------------
function db  { Invoke-Command -ScriptBlock { dotnet build } }
function gil { Invoke-Command -ScriptBlock { git log --oneline } }
function gis { Invoke-Command -ScriptBlock { git status } }
function gpr { Invoke-Command -ScriptBlock { git push --all origin } }
# ------------------------------------------------------------------------------------------------------------------------------------------------------
# Set a desired date for the last commit
# ------------------------------------------------------------------------------------------------------------------------------------------------------
function Set-CommitterDateForLastCommit {
    Param ([Parameter(Mandatory=$true)][string] $CommitDate)
    # $commitDateString = "2010-01-01T14:30:00"
    $commitDateString = $CommitDate.Replace(" ", "T")
    $env:GIT_COMMITTER_DATE = $commitDateString
    git commit --amend --date $commitDateString
    $env:GIT_COMMITTER_DATE = ""
}
# ------------------------------------------------------------------------------------------------------------------------------------------------------
# Clear recent items from explorer
# ------------------------------------------------------------------------------------------------------------------------------------------------------
function Clear-RecentFiles {
    Remove-Item $env:APPDATA\Microsoft\Windows\Recent\* -Recurse -Force
    Remove-Item HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\RunMRU\*
    Remove-Item HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths\*
    Remove-Item HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\TypedPaths\*
    taskkill /f /im explorer.exe
    Start-Process explorer.exe
}
# ------------------------------------------------------------------------------------------------------------------------------------------------------
# Clear powershell-history (incl. arrow-up/arrow-down)
# Set-PSReadLineOption -HistorySaveStyle SaveNothing
# ------------------------------------------------------------------------------------------------------------------------------------------------------
function Clear-HistoryExtended {
   Clear-History
   [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
   [System.Windows.Forms.SendKeys]::Sendwait('%{F7 2}')
   Remove-Item (Get-PSReadlineOption).HistorySavePath
   Get-Process powershell | Stop-Process
}
'@

Add-Content $PROFILE -Value $customFunctions

$customFunctionsLoader = @'
# -----------------------------------------------------------------------------------------------------------------
# Load custom functions [BEGIN]
# -----------------------------------------------------------------------------------------------------------------
'-'*100 | Write-Host
$functionsPath = "$HOME\Documents\WindowsPowershell\functions\*.ps1"
if (Test-Path $functionsPath) { gci $functionsPath | % { Write-Host "Load functions: $($_.Name)"; . $_.FullName } }
else { "No functions in $functionsPath - skip loading." | Write-Host }
'-'*100 | Write-Host; Write-Host
# -----------------------------------------------------------------------------------------------------------------
# Load custom functions [END]
# -----------------------------------------------------------------------------------------------------------------
'@

# ------------------------------------------------------------------------------------------------------------------
# Add code-block to load custom functions into PowerShell-Profile
# ------------------------------------------------------------------------------------------------------------------
if((Get-Content("$PROFILE")).Contains('# Load custom functions [BEGIN]')) {
    "$PROFILE already contains a loading-fragment for custom functions - so it won't be added again"
}
else {
   Add-Content $PROFILE -Value $customFunctionsLoader 
}

# End timer and display installation time
$dateEnd = Get-Date
$duration = $dateEnd - $dateStart
Write-Host "Installation completed in $($duration.TotalMinutes) minute(s)."
