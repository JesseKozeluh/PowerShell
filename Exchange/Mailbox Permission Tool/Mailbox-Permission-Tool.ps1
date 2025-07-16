# Declare Exchange connection URI (set to your own URI)
$connectionURI = "http://mail.server.com/PowerShell/"

# Declare shared mailbox list (add mailboxes here)
$sharedMailboxes = @(
    "mailbox1@email.com",
    "mailbox2@email.com",
    "mailbox3@email.com"
)

# Load Windows Forms assembly
Add-Type -AssemblyName System.Windows.Forms

# Create script-scoped session variable
$script:session = $null

# Function to create the GUI
function Show-MailboxAccessForm {
    $form = New-Object System.Windows.Forms.Form
    $form.Text = "Mailbox Access Manager"
    $form.Size = New-Object System.Drawing.Size(400, 200)
    $form.StartPosition = "CenterScreen"

    $mailboxLabel = New-Object System.Windows.Forms.Label
    $mailboxLabel.Text = "Mailbox:"
    $mailboxLabel.Location = New-Object System.Drawing.Point(20, 5)
    $form.Controls.Add($mailboxLabel)

    $mailboxDropdown = New-Object System.Windows.Forms.ComboBox
    $mailboxDropdown.Location = New-Object System.Drawing.Point(20, 28)
    $mailboxDropdown.Size = New-Object System.Drawing.Size(340, 20)
    $mailboxDropdown.Items.AddRange($sharedMailboxes)
    $form.Controls.Add($mailboxDropdown)

    $samLabel = New-Object System.Windows.Forms.Label
    $samLabel.Text = "Account:"
    $samLabel.Location = New-Object System.Drawing.Point(20, 57)
    $form.Controls.Add($samLabel)

    $samTextBox = New-Object System.Windows.Forms.TextBox
    $samTextBox.Location = New-Object System.Drawing.Point(20, 80)
    $samTextBox.Size = New-Object System.Drawing.Size(340, 20)
    $form.Controls.Add($samTextBox)

    $connectButton = New-Object System.Windows.Forms.Button
    $connectButton.Text = "Connect"
    $connectButton.Location = New-Object System.Drawing.Point(20, 120)
    $connectButton.Add_Click({
        try {
            $script:session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri $connectionURI -Authentication Kerberos
            Import-PSSession $script:session -DisableNameChecking -AllowClobber
            [System.Windows.Forms.MessageBox]::Show("Connected to Exchange.")
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Connection failed:`n$_")
        }
    })
    $form.Controls.Add($connectButton)

    $disconnectButton = New-Object System.Windows.Forms.Button
    $disconnectButton.Text = "Disconnect"
    $disconnectButton.Location = New-Object System.Drawing.Point(155, 120)
    $disconnectButton.Add_Click({
        try {
            if ($script:session) {
                Remove-PSSession $script:session
                $script:session = $null
                [System.Windows.Forms.MessageBox]::Show("Disconnected from Exchange.")
            } else {
                [System.Windows.Forms.MessageBox]::Show("No active session found.")
            }
        } catch {
            [System.Windows.Forms.MessageBox]::Show("Disconnection failed:`n$_")
        }
    })
    $form.Controls.Add($disconnectButton)

    $submitButton = New-Object System.Windows.Forms.Button
    $submitButton.Text = "Grant Access"
    $submitButton.Location = New-Object System.Drawing.Point(285, 120)
    $submitButton.Add_Click({
        $selectedMailbox = $mailboxDropdown.SelectedItem
        $samAccountName = $samTextBox.Text

        if ($script:session -and $selectedMailbox -and ![string]::IsNullOrWhiteSpace($samAccountName)) {
            try {
                Add-MailboxPermission -Identity $selectedMailbox -User $samAccountName -AccessRights FullAccess -InheritanceType All
                Get-Mailbox $selectedMailbox | Add-ADPermission -User $samAccountName -ExtendedRights "Send As"
                [System.Windows.Forms.MessageBox]::Show("Access granted to $samAccountName for $selectedMailbox")
            } catch {
                [System.Windows.Forms.MessageBox]::Show("Error granting access:`n$_")
            }
        } else {
            [System.Windows.Forms.MessageBox]::Show("Please connect to Exchange, select a mailbox, and enter an account name.")
        }
    })
    $form.Controls.Add($submitButton)

    $form.Topmost = $true
    $form.ShowDialog()
}

# Run the form
Show-MailboxAccessForm
