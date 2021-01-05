# ====================================================================================================
# Author:   Markus Kofler (mkoflerAT)
# Website:  https://www.kofler-it.com
# Licence:  MIT
# Version:  1.1.0.0
# Date:     2021-01-05 17:20
# ====================================================================================================
function Get-BleachbitPortable {
    $uri = 'https://download.bleachbit.org/BleachBit-4.2.0-portable.zip'
    $out = [Environment]::GetFolderPath("Desktop") + "\BleachBitPortable.zip"
    (New-Object System.Net.WebClient).DownloadFile($uri, $out)
    $targetPath = [Environment]::GetFolderPath("Desktop")
    Expand-Archive -Path $out -DestinationPath $targetPath
    Remove-Item -Force $out
}

Get-BleachbitPortable
