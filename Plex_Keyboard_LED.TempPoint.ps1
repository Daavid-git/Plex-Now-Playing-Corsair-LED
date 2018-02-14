<#	
	.NOTES
	===========================================================================
	 Created with: 	SAPIEN Technologies, Inc., PowerShell Studio 2017 v5.4.142
	 Created on:   	2017-07-25 12:29
	 Created by:   	Daavid
	 Organization: 	
	 Filename:     	Plex now-playing corsair LED
	===========================================================================
	.DESCRIPTION
		A description of the file.
#>
$active = $true
$keyboard_found = $false

$Plex_token = ""
$Plex_local_server_IP = ""
$Check_interval_secounds = 10
$LED_color = [System.Drawing.Color]::Orange

Import-Module .\CUE.NET\CUE.NET.dll

while ($keyboard_found -eq $false)
{
	try
	{
		[CUE.NET.CueSDK]::Initialize()
		[CUE.NET.Devices.Keyboard.CorsairKeyboard]$keyboard = [CUE.NET.CueSDK]::KeyboardSDK
		
		if ($keyboard -ne "")
		{
			$keyboard_found = $true
			Write-Host "Keyboard: $($keyboard.DeviceInfo.model)"
		}
	}
	catch
	{
		Write-Host "Unable to initialize/get keyboard" -ForegroundColor Red
		Start-Sleep -Seconds 10
	}
}

$last_check = -1
while ($active)
{
	try
	{
		$req = Invoke-WebRequest -Uri "http://$($Plex_local_server_IP):32400/status/sessions?X-Plex-Token=$Plex_token" -Method GET -ErrorAction Stop
		[xml]$data = $req.content
		$numbers_of_streams = $data.MediaContainer.size
		$users = $data.MediaContainer.Video.User.title
		$title = $data.MediaContainer.Video.grandparentTitle
	}
	catch
	{
		Write-Host "Unable to get plex data" -ForegroundColor Red
	}
	
	
	if ($numbers_of_streams -ne $last_check) #check if stream count has changed
	{
		[CUE.NET.CueSDK]::Reinitialize() #Reset keyboard LEDs
		$Keypad = "Keypad$($numbers_of_streams)"
		$keyboard[[CUE.NET.Devices.Keyboard.Enums.CorsairKeyboardLedId]::$Keypad].Color = $LED_color
		$keyboard.Update()
		if ($users.count -ne 0)
		{
			Write-Host "Users: $users"
		}
	}
	else
	{
		#Do nothing
	}
	
	$last_check = $numbers_of_streams
	Start-Sleep -Seconds $Check_interval_secounds
}