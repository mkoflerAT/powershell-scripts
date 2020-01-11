# powershell-scripts

A collection of some powershell-scripts and -functions.

## Table of contents

  * [Add scripts for creating SSH-Keys for Github/Bitbucket](#add-scripts-for-creating-ssh-keys)
  * [Add script to clear the history in Powershell](#add-script-to-clear-the-history-of-powershell)
  * [Add script for compressing folders into separate 7z-archives](#add-script-for-compressing-folders-into-separate-7z-archives)
  * [Update Add-SSHKey-scripts to add line with username to config](#update-ssh-config-file-with-username)

<hr>

<a id="add-scripts-for-creating-ssh-keys"></a>
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

<hr>

<a id="add-script-to-clear-the-history-of-powershell"></a>
## Add script to clear the history in Powershell

Added a very nice script to clear the history properly.  
Even if you press up and down in Powershell is cleared.

<hr>

<a id="add-script-for-compressing-folders-into-separate-7z-archives"></a>
## Add script for compressing folders into separate 7z-archives

Add a script for compressing the content of each folder into a separate 7z-archive.  
Be aware that you NEED the powershell-module from https://github.com/thoemmi/7Zip4Powershell  
which has to be installed by running a powershell as administrator by running:

    Install-Module -Name 7Zip4Powershell

More information on the powwershell-module is available on [Github](https://github.com/thoemmi/7Zip4Powershell).

<hr>

<a id="update-ssh-config-file-with-username"></a>
## Update Add-SSHKey-scripts to add line with username to config

Added an additional line to the config file for the ssh-keys. This is necessary if you have a username on the  
repository-host that is different from the one you're using on your client-system (Windows). For Bitbucket and  
Github it's per default `git`. Here is an example-config:

    Host server.yourdomain.com
      User admin
      HostName server.yourdomain.com
      IdentityFile ~/.ssh/ssh-key-digitalocean

    Host bitbucket.org
      User git
      HostName bitbucket.org
      IdentityFile ~/.ssh/ssh-key-bitbucket

    Host github.com
      User git
      HostName github.com
      IdentityFile ~/.ssh/ssh-key-github

If you ssh into one of those servers (e.g.: from Powershell) it will automatically pick up the correct  
username from the config-file which has to reside in `~/.ssh/` into the same folder as the ssh-keys.

