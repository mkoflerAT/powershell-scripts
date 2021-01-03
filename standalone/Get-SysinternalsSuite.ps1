# ====================================================================================================
# Author:   Markus Kofler (mkoflerAT)
# Website:  https://www.kofler-it.com
# Licence:  MIT
# Version:  1.0.0.0
# Date:     2020-11-11 03:00
# ====================================================================================================
function Get-SysinternalsSuite {
    $uri = 'https://download.sysinternals.com/files/SysinternalsSuite.zip'
    $out = [Environment]::GetFolderPath("Desktop") + "\SysinternalsSuite.zip"
    (New-Object System.Net.WebClient).DownloadFile($uri, $out)
    $targetPath = [Environment]::GetFolderPath("Desktop") + "\SysinternalsSuite"
    Expand-Archive -Path $out -DestinationPath $targetPath
    Remove-Item -Force $out
}

Get-SysinternalsSuite
