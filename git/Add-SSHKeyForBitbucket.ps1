# ==========================================================================
# Author:   Markus Kofler (mkoflerAT)
# Website:  https://www.kofler-it.com
# Licence:  MIT
# Version:  1.00
# Date:     2020-01-04 03:00
# ==========================================================================
# To run this script, you need 'ssh-keygen.exe'. I recommend to install
# chocolatey (see: https://chocolatey.org/install) and then run as admin:
# choco install sysinternals
# ==========================================================================
function Add-SSHKeyForBitbucket{
    $GitHostName="bitbucket"
    $GitHostDomain="bitbucket.org"
    $GitHostKeyUrl='https://bitbucket.org/account/ --> SSH-Keys'
    $today = (Get-Date).ToString("yyyy-MM-dd")
    $sshKeyName = "$today-rsa-key-$env:USERNAME-$GitHostName"
    $sshKeyFile = "$env:HOME\.ssh\$sshKeyName"
    $configFile = "$env:HOME\.ssh\config"
    Push-Location 'C:\Program Files\Git\usr\bin\'
    .\ssh-keygen.exe -t rsa -C "$sshKeyName" -f "$sshKeyFile"
    "Host $GitHostDomain" | Out-File -Encoding utf8 -Append $configFile
    "  HostName $GitHostDomain" | Out-File -Encoding utf8 -Append $configFile
    "  IdentityFile ~/.ssh/$sshKeyName" | Out-File -Encoding utf8 -Append $configFile
    Pop-Location
    [System.IO.File]::WriteAllLines($configFile, (Get-Content $configFile -Raw), [System.Text.UTF8Encoding]($False))
    Get-Content "$sshKeyFile.pub" | clip
    "Add content of $sshKeyFile.pub to SSH-Keys at $GitHostKeyUrl. Key has been copied to your clipboard"
}

Add-SSHKeyForBitbucket

# Notes
# Removal of the BOM-encoding is necessary, otherwise if you try to clone a repository git can't read the config

# Remove-BOM-Encoding:
# https://stackoverflow.com/questions/5596982/using-powershell-to-write-a-file-in-utf-8-without-the-bom
# https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/dealing-with-file-encoding-and-bom