# For running this script you need the Powershell-Module from: https://github.com/thoemmi/7Zip4Powershell
# To install open a Powershell as administrator and run:
# Install-Module -Name 7Zip4Powershell
# 
# This script compresses the folders within the current directory into a separate [foldername].7z archives

function Compress-FoldersIntoSeperate7zArchives {
	gci -Directory .\ | % { Compress-7Zip -Path $_.FullName -Format SevenZip -ArchiveFileName "$($_.Name).7z" }
 }

Compress-FoldersIntoSeperate7zArchives
 