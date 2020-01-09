# This script removes all network-profiles from the registry. Each time Windows is plugged into a
# new network it will name it "Network", "Netwwork 2", ... This script gets rid of all previously
# found LANs so the next (and first) LAN that's found will named "Network".
# You have to run this script as administrator.

function Remove-NetworkProfiles {
    Remove-Item 'HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\NetworkList\Profiles\*'
}

Remove-NetworkProfiles