# Connect to Exchange Online
Connect-ExchangeOnline

# Prompt for shared mailbox email
$sharedMailboxEmail = Read-Host "Enter the shared mailbox email address to check"

# Get mailbox
$mailbox = Get-Mailbox $sharedMailboxEmail

Write-Host "`nChecking permissions for mailbox: $sharedMailboxEmail`n"

# --- SEND AS PERMISSIONS ---
$sendAsPermissions = Get-RecipientPermission -Identity $sharedMailboxEmail | Where-Object {
    $_.AccessRights -contains "SendAs" -and $_.Trustee -notlike "NT AUTHORITY*"
}

$disabledSendAsUsers = @()
foreach ($perm in $sendAsPermissions) {
    $username = $perm.Trustee.ToString()
    $user = Get-Mailbox -Identity $username -ErrorAction SilentlyContinue
    if ($user -and $user.AccountDisabled -eq $true) {
        $disabledSendAsUsers += $perm
    }
}

# --- FULL ACCESS PERMISSIONS ---
$fullAccessPermissions = Get-MailboxPermission -Identity $sharedMailboxEmail | Where-Object {
    $_.AccessRights -contains "FullAccess" -and $_.IsInherited -eq $false -and $_.User.ToString() -notlike "NT AUTHORITY*"
}

$disabledFullAccessUsers = @()
foreach ($perm in $fullAccessPermissions) {
    $username = $perm.User.ToString()
    $user = Get-Mailbox -Identity $username -ErrorAction SilentlyContinue
    if ($user -and $user.AccountDisabled -eq $true) {
        $disabledFullAccessUsers += $perm
    }
}

# --- DISPLAY AND PROMPT FOR SEND AS ---
if ($disabledSendAsUsers.Count -eq 0) {
    Write-Host "`nNo disabled users found with SendAs permission."
} else {
    Write-Host "`nDisabled users with SendAs permission:"
    $disabledSendAsUsers | ForEach-Object { Write-Host $_.Trustee }

    $confirmationSendAs = Read-Host "`nDo you want to remove SendAs permission from these users? (Y/N)"
    if ($confirmationSendAs -eq "Y") {
        foreach ($perm in $disabledSendAsUsers) {
            Remove-RecipientPermission -Identity $sharedMailboxEmail -Trustee $perm.Trustee -AccessRights SendAs -Confirm:$false
            Write-Host "Removed SendAs permission from $($perm.Trustee)"
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

# Disconnect session
Disconnect-ExchangeOnline -Confirm:$false
