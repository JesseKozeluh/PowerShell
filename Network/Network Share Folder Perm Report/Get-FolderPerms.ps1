# Network Share Folder Permission Report v1.0
# Jesse Kozeluh - 16/07/25

# Set network paths to check
$folderpath = @(
    "\\FILESERVER\Share1",
    "\\FILESERVER\Share2",
    "\\FILESERVER\Share3"
)

Add-Type -AssemblyName System.Windows.Forms

# Prompt user with SaveFileDialog for output path
$saveFileDialog = New-Object System.Windows.Forms.SaveFileDialog
$saveFileDialog.InitialDirectory = [Environment]::GetFolderPath("Desktop")
$saveFileDialog.Filter = "Excel Files (*.xlsx)|*.xlsx"
$saveFileDialog.Title = "Select file save location"
$saveFileDialog.FileName = "NetworkSharePermReport_$(Get-Date -Format 'yyyy-MM-dd').xlsx"

$dialogResult = $saveFileDialog.ShowDialog()
if ($dialogResult -ne [System.Windows.Forms.DialogResult]::OK) {
    Write-Host "Operation cancelled by user."
    return
}
$output = $saveFileDialog.FileName

# Define permission reporting function
function Get-Permissions ($folder, $sheetName) {
    try {
        (Get-Acl $folder).Access | Select-Object `
            @{Label="Timestamp"; Expression={Get-Date -Format "yyyy-MM-dd HH:mm"}}, `
            @{Label="FilePath"; Expression={ $folder }}, `
            @{Label="Identity"; Expression={ $_.IdentityReference }}, `
            @{Label="Right"; Expression={ $_.FileSystemRights }}, `
            @{Label="Inherited"; Expression={ $_.IsInherited }} |
            Export-Excel -Path $output -WorksheetName $sheetName -Append
    } catch {
        Write-Warning "Failed to get ACL for ${folder}: $_"
    }
}

# Iterate through folders
foreach ($item in $folderpath) {
    $LastFolder = ($item -split '\\')[-1] -replace '[\\/:*?"<>|]', '_'

    # Include top-level folder permissions
    Get-Permissions -folder $item -sheetName $LastFolder

    # Include child folder permissions
    Get-ChildItem -Path $item -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        Get-Permissions -folder $_.FullName -sheetName $LastFolder
    }
}

# Completion message
Write-Host "`nReport successfully generated at: $output"
