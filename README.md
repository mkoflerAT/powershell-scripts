# powershell-scripts

## Add scripts for creating SSH-Keys for Github/Bitbucket

It's common practice to use remote GIT-repositories with SSH instead of HTTPS.  
You can create those key-files manually or you can use these scripts I've written:

  * [Add-SSHKeyForBitbucket.ps1](git/Add-SSHKeyForBitbucket.ps1)
  * [Add-SSHKeyForGithub.ps1](git/Add-SSHKeyForGithub.ps1)

For creating the key-files the tool `ssh-keygen.exe` is required. It's part of [GIT](https://git-scm.com/) and  
ca be installed via [chocolatey](https://chocolatey.org/) by running the following command as administrator:

    choco install git

If you don't have chocolatey already installed, it's a good idea to do so. See: https://chocolatey.org/install  
If you have `ssh-keygen.exe` not in `'C:\Program Files\Git\usr\bin\'` please fix the path in the script(s).

References:

  * https://help.github.com/en/github/authenticating-to-github/connecting-to-github-with-ssh
  * https://stackoverflow.com/questions/5596982/using-powershell-to-write-a-file-in-utf-8-without-the-bom
  * https://community.idera.com/database-tools/powershell/powertips/b/tips/posts/dealing-with-file-encoding-and-bom

## Add script to clear the history in Powershell

Added a very nice script to clear the history properly.  
Even if you press up and down in Powershell is cleared.

