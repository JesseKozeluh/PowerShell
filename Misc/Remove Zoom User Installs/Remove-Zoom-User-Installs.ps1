# Removes all user installs of Zoom on a machine
# Jesse Kozeluh - 16-7-25

## Get users
$users = Get-ChildItem -Path "C:\Users"

# Loop through users and delete the Zoom appdata folders
$users | ForEach-Object {
Remove-Item -Path "C:\Users\$($_.Name)\AppData\Roaming\Zoom" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Users\$($_.Name)\AppData\Local\Zoom" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "C:\Users\$($_.Name)\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Zoom" -Recurse -Force -ErrorAction SilentlyContinue
}

## Removing currently logged on user registry keys 
function Get-CurrentUser() {
	try { 
		$currentUser = (Get-Process -IncludeUserName -Name explorer | Select-Object -First 1 | Select-Object -ExpandProperty UserName).Split("\")[1] 
	} 
	catch { 
		Write-Output "Failed to get current user." 
	}
	if (-NOT[string]::IsNullOrEmpty($currentUser)) {
		Write-Output $currentUser
	}
}
function Get-UserSID([string]$fCurrentUser) {
	try {
		$user = New-Object System.Security.Principal.NTAccount($fcurrentUser) 
		$sid = $user.Translate([System.Security.Principal.SecurityIdentifier]) 
	}
	catch { 
		Write-Output "Failed to get current user SID."   
	}
	if (-NOT[string]::IsNullOrEmpty($sid)) {
		Write-Output $sid.Value
	}
}

## Removing Registry entries for Currenlty logged on user
$currentUser = Get-CurrentUser
$currentUserSID = Get-UserSID $currentUser
Remove-Item -Path "Registry::HKEY_USERS\$($currentUserSID)\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZoomUMX" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "Registry::HKEY_USERS\$($currentUserSID)\Software\ZoomUMX" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "Registry::HKEY_USERS\$($currentUserSID)\Software\Classes\.zoommtg" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "Registry::HKEY_USERS\$($currentUserSID)\Software\Classes\ZoomLauncher" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "Registry::HKEY_USERS\$($currentUserSID)\Software\Classes\zoommtg" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "Registry::HKEY_USERS\$($currentUserSID)\Software\Classes\ZoomPbxzoomphonecall" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "Registry::HKEY_USERS\$($currentUserSID)\Software\Classes\ZoomPhoneCall" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "Registry::HKEY_USERS\$($currentUserSID)\Software\Classes\ZoomRecording" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item -Path "Registry::HKEY_USERS\$($currentUserSID)\Software\Classes\MIME\Database\Content Type\application/x-zoommtg-launcher" -Recurse -Force -ErrorAction SilentlyContinue

## Removing Classes user registry keys  HKCU\Software\Classes\... they are stored in different.Dat file in the appdata directory
$users = (Get-ChildItem -path c:\users).name
foreach($user in $users)
 {
 Write-Output $User
 reg load "HKLM\TempHive" "C:\Users\$user\Appdata\Local\Microsoft\Windows\UsrClass.dat"
 Remove-Item -Path "Registry::HKLM\TempHive\.zoommtg" -Recurse -Force -ErrorAction SilentlyContinue
 Remove-Item -Path "Registry::HKLM\TempHive\ZoomLauncher" -Recurse -Force -ErrorAction SilentlyContinue
 Remove-Item -Path "Registry::HKLM\TempHive\zoommtg" -Recurse -Force -ErrorAction SilentlyContinue
 Remove-Item -Path "Registry::HKLM\TempHive\ZoomPbx.zoomphonecall" -Recurse -Force -ErrorAction SilentlyContinue
 Remove-Item -Path "Registry::HKLM\TempHive\ZoomPhoneCall" -Recurse -Force -ErrorAction SilentlyContinue
 Remove-Item -Path "Registry::HKLM\TempHive\ZoomRecording" -Recurse -Force -ErrorAction SilentlyContinue
 Remove-Item -Path "Registry::HKLM\TempHive\MIME\Database\Content Type\application/x-zoommtg-launcher" -Recurse -Force -ErrorAction SilentlyContinue
 ## gc command below - releases memory that is tied to registry entries before trying to unload the key
 [gc]::collect()
 reg unload "HKLM\TempHive"
 }

## Remove Not logged in users Registry keys that are stored in Ntuser.dat - (Not Classes key from above)
$users = (Get-ChildItem -path c:\users).name
foreach($user in $users)
 {
 Write-Output $User
 reg load "HKLM\TempUserHive" "C:\Users\$user\NTUSER.DAT"
 ##Start-Sleep -Seconds 30
 Remove-Item -Path "Registry::HKLM\TempUserHive\Software\Microsoft\Windows\CurrentVersion\Uninstall\ZoomUMX" -Recurse -Force -ErrorAction SilentlyContinue
 Remove-Item -Path "Registry::HKLM\TempUserHive\Software\ZoomUMX" -Recurse -Force -ErrorAction SilentlyContinue
 ##Start-Sleep -Seconds 30 
 [gc]::collect()
 reg unload "HKLM\TempUserHive"
 }
