<#
    .SYNOPSIS
        Generates a secure password that can be typed the same way on a German and English keyboard.
        The first version of this script has been written in January 2022 and has evolved over time.
        Feel free to use and share as long as you keep the header and the BSD 2-Clause License.
        If you have questions, feel free to reach out to me at LinkedIn or otherwise.

        To show this help-block run:
        Get-Help .\Get-KeyboardLayoutIndependentPassword.ps1 -Full

    .DESCRIPTION
        #===============================================================#
        # Name:     Get-KeyboardLayoutIndependentPassword.ps1           #
        # Version:  2.0                                                 #
        # Date:     2024-01-01                                          #
        # ===============================================================
        # Author:   Markus Kofler                                       #
        # Github:   https://www.github.com/mkoflerAT/                   #
        # LinkedIn: https://www.linkedin.com/in/mkoflerat/              #
        # Website:  https://www.kofler-it.com/                          #
        # Website:  https://markuskofler.com/                           #
        # ===============================================================

        Typing characters on an German/English keyboard:

        German  special:  	°!"§$%&/()=?`
        English special:	~!@#$%^&*()_+
        German  numberblock:	/*-+
        English numberblock:	/*-+
        German   öä#	ÖÄ'	ü+	Ü*	,.-	;:_	<>
        English  ;'\	:"|	[]	{}	,./	<>?	\|

        special chars that are identical on DE/EN keyboards are:        !$%
        when numblock is used, these chars can be used additionally:    /*-+

    .EXAMPLE
        Get-KeyboardLayoutIndependentPassword

    .EXAMPLE
        Get-KeyboardLayoutIndependentPassword -CharsetSpecialChars "!$"

    .EXAMPLE
        Get-KeyboardLayoutIndependentPassword -CharsetSmallCaps "abcdefghkmpqrstuvwx" -CharsetUpperCaps "XWLP" -CharsetSpecialChars "!$"

    .EXAMPLE
        Get-KeyboardLayoutIndependentPassword -PasswordLength 16 -DebugCharsetLengths -MinCharsSmallCaps 6 -MinCharsUpperCaps 4 -MinCharsNumbers 2 -MinCharsSpecials 2 }

    .EXAMPLE
        1..10 | % { Get-KeyboardLayoutIndependentPassword -PasswordLength 16 }

    .EXAMPLE
        1..30 | % { $myPass = Get-KeyboardLayoutIndependentPassword -PasswordLength 18 -DebugCharsetLengths }

    .LINK
        https://www.linkedin.com/in/mkoflerat/

    .NOTES
        BSD 2-Clause License

        Copyright (c) 2024, Markus Kofler
        All rights reserved.

        Author:     Markus Kofler
        Github:     https://www.github.com/mkoflerAT
        LinkedIn:   https://www.linkedin.com/in/mkoflerat/
        Website:    https://www.kofler-it.com
        Website:    https://markuskofler.com

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

#region "Generate a password that is typeable both on a German and English Keyboard"

function Get-RandomCharacters($length, $characters) {
    $random = 1..$length | ForEach-Object { Get-Random -Maximum $characters.length }
    $private:ofs = ""
    return [String]$characters[$random]
}

function Get-ScrambledString([string]$inputString) {
    $characterArray = $inputString.ToCharArray()
    $scrambledStringArray = $characterArray | Get-Random -Count $characterArray.Length
    $outputString = -join $scrambledStringArray
    return $outputString 
}

function Get-KeyboardLayoutIndependentPassword {
    param (
        [Parameter(Mandatory = $false)][int] $PasswordLength = 16,
        [Parameter(Mandatory = $false)][string] $CharsetSmallCaps = 'abcdefghijkmnpqrstuvwx',
        [Parameter(Mandatory = $false)][string] $CharsetUpperCaps = 'ABCDEFGHJKLMNPQRSTUVWX',
        [Parameter(Mandatory = $false)][string] $CharsetNumbers = '1234567890',
        [Parameter(Mandatory = $false)][string] $CharsetSpecialChars = '!$%',
        [Parameter(Mandatory = $false)][ValidateRange(1,[int]::MaxValue)][int] $MinCharsSmallCaps = 1,
        [Parameter(Mandatory = $false)][ValidateRange(1,[int]::MaxValue)][int] $MinCharsUpperCaps = 1,
        [Parameter(Mandatory = $false)][ValidateRange(1,[int]::MaxValue)][int] $MinCharsNumbers = 1,
        [Parameter(Mandatory = $false)][ValidateRange(1,[int]::MaxValue)][int] $MinCharsSpecials = 1,
        [Parameter(Mandatory = $false)][switch] $DebugCharsetLengths
    )

    Set-Variable -Name MinimumRequiredPasswordLength -Value 12 -Option ReadOnly

    if($PasswordLength -lt $MinimumRequiredPasswordLength) {
        Write-Warning "A password should have at minimum 12 chars - set minimum length to 12."
        $PasswordLength = $MinimumRequiredPasswordLength
    }

    if(($MinCharsSmallCaps + $MinCharsUpperCaps + $MinCharsNumbers + $MinCharsSpecials) -gt $PasswordLength) {
        Write-Warning "Total length of minimum-required charset-lengths exceed required password length - set minimum-length for all charsets to 1."
        $MinCharsSmallCaps = 1
        $MinCharsUpperCaps = 1
        $MinCharsNumbers = 1
        $MinCharsSpecials = 1
    }

    $lengthSmallCaps = Get-Random -Minimum $MinCharsSmallCaps -Maximum ($PasswordLength - $MinCharsUpperCaps - $MinCharsNumbers - $MinCharsSpecials + 1)
    $lengthUpperCaps = Get-Random -Minimum $MinCharsUpperCaps -Maximum ($PasswordLength - $lengthSmallCaps - $MinCharsNumbers - $MinCharsSpecials + 1)
    $lengthNumbers = Get-Random -Minimum $MinCharsNumbers   -Maximum ($PasswordLength - $lengthSmallCaps - $lengthUpperCaps - $MinCharsSpecials + 1)
    $lengthSpecials = $PasswordLength - $lengthSmallCaps - $lengthUpperCaps - $lengthNumbers
        
    $password = Get-RandomCharacters -length $lengthSmallCaps  -characters $CharsetSmallCaps
    $password += Get-RandomCharacters -length $lengthUpperCaps -characters $CharsetUpperCaps
    $password += Get-RandomCharacters -length $lengthNumbers   -characters $CharsetNumbers
    $password += Get-RandomCharacters -length $lengthSpecials  -characters $CharsetSpecialChars
    $password = Get-ScrambledString $password
        
    if ($DebugCharsetLengths) {
        Write-Host "Total: [$($password.Length)] Values: [$lengthSmallCaps]|[$lengthUpperCaps]|[$lengthNumbers]|[$lengthSpecials] - $password"
    }
    
    return $password
}

#endregion
