# Clean Shared Mailbox Permissions v1.0
# Jesse Kozeluh - 16-7-25

# Declare Exchange connection URI (replace with your URI)
$connectionURI = "http://mail.server.com/PowerShell/"

# Connect to Exchange Management Shell
$session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $connectionURI -Authentication Kerberos
Import-PSSession $session -DisableNameChecking -AllowClobber

# Prompt for shared mailbox email
$sharedMailboxEmail = Read-Host "Enter the shared mailbox email address to check"

# Get mailbox details
$mailbox = Get-Mailbox $sharedMailboxEmail
$sharedMailboxDN = $mailbox.DistinguishedName

Write-Host "`nChecking permissions for mailbox: $sharedMailboxEmail`n"

# --- SEND AS PERMISSIONS ---
$sendAsPermissions = Get-ADPermission -Identity $sharedMailboxDN | Where-Object {
    $_.ExtendedRights -contains "Send-As" -and $_.IsInherited -eq $false
}

$disabledSendAsUsers = @()
foreach ($perm in $sendAsPermissions) {
    $userStr = $perm.User.ToString()
    if ($userStr -match "^(.*)\\(.*)$") {
        $username = $matches[2]
        $adUser = Get-ADUser -Filter "SamAccountName -eq '$username'" -Properties Enabled -ErrorAction SilentlyContinue
        if ($adUser -and !$adUser.Enabled) {
            $disabledSendAsUsers += $perm
        }
    }
}

# --- FULL ACCESS PERMISSIONS ---
$fullAccessPermissions = Get-MailboxPermission -Identity $sharedMailboxEmail | Where-Object {
    $_.AccessRights -contains "FullAccess" -and $_.IsInherited -eq $false -and $_.User.ToString() -notlike "NT AUTHORITY*"
}

$disabledFullAccessUsers = @()
foreach ($perm in $fullAccessPermissions) {
    $userStr = $perm.User.ToString()
    if ($userStr -match "^(.*)\\(.*)$") {
        $username = $matches[2]
        $adUser = Get-ADUser -Filter "SamAccountName -eq '$username'" -Properties Enabled -ErrorAction SilentlyContinue
        if ($adUser -and !$adUser.Enabled) {
            $disabledFullAccessUsers += $perm
        }
    }
}

# --- DISPLAY AND PROMPT FOR SEND AS ---
if ($disabledSendAsUsers.Count -eq 0) {
    Write-Host "`nNo disabled users found with SendAs permission."
} else {
    Write-Host "`nDisabled users with SendAs permission:"
    $disabledSendAsUsers | ForEach-Object { Write-Host $_.User }

    $confirmationSendAs = Read-Host "`nDo you want to remove SendAs permission from these users? (Y/N)"
    if ($confirmationSendAs -eq "Y") {
        foreach ($perm in $disabledSendAsUsers) {
            Remove-ADPermission -Identity $sharedMailboxDN -User $perm.User -ExtendedRights "Send As" -Confirm:$false
            Write-Host "Removed SendAs permission from $($perm.User)"
        }
    } else {
        Write-Host "SendAs permissions not changed."
    }
}

# --- DISPLAY AND PROMPT FOR FULL ACCESS ---
if ($disabledFullAccessUsers.Count -eq 0) {
    Write-Host "`nNo disabled users found with Full Access permission."
} else {
    Write-Host "`nDisabled users with Full Access permission:"
    $disabledFullAccessUsers | ForEach-Object { Write-Host $_.User }

    $confirmationFullAccess = Read-Host "`nDo you want to remove Full Access permission from these users? (Y/N)"
    if ($confirmationFullAccess -eq "Y") {
        foreach ($perm in $disabledFullAccessUsers) {
            Remove-MailboxPermission -Identity $sharedMailboxEmail -User $perm.User -AccessRights FullAccess -Confirm:$false
            Write-Host "Removed Full Access permission from $($perm.User)"
        }
    } else {
        Write-Host "Full Access permissions not changed."
    }
}
Get-PSSession | Remove-PSSession
