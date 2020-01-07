# A better function to clear the whole powershell-history including forms-history
# https://stackoverflow.com/questions/13257775/powershells-clear-history-doesnt-clear-history

function Clear-HistoryExtended {
    Clear-History
    [System.Reflection.Assembly]::LoadWithPartialName("System.Windows.Forms")
    [System.Windows.Forms.SendKeys]::Sendwait('%{F7 2}')
    Remove-Item (Get-PSReadlineOption).HistorySavePath
    # Set-PSReadLineOption -HistorySaveStyle SaveNothing;
    Get-Process powershell | Stop-Process
 }

 Clear-HistoryExtended