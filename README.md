

# Plex Now-Playing Corsair LED

This script will change the color on your numpad keys in order to display the current active steams on your plex server.

*Thanks to [Darth Affe](http://forum.corsair.com/v3/showthread.php?t=149863) for the .NET wrapper/SDK.* 

![Keyboard example](https://i.imgur.com/aUaifW8.png)


Before you run the Powershell script, you need to update the configuration variables in the script (.ps1 file) and make sure the Powershell execution policy is not restricted.

## Update Powershell Execution Policy
Open Powershell and run the following command:

    Set-ExecutionPolicy -scope LocalMachine -ExecutionPolicy RemoteSigned
Optimal to do this both for 64/32-bit Powershell.

![enter image description here](https://i.imgur.com/dFkj2qS.png)


## Update configuration variables

Open *Plex_Keyboard_LED.ps1* with Powershell ISE or a text editor and update the variables.

    $Plex_token = ""
    $Plex_local_server_IP = ""
    $Check_interval_secounds = 10
    $LED_color = [System.Drawing.Color]::Orange

### Plex Authentication token / X-Plex-Token
You can find the Plex authentication token with by following this plex support article:
[Finding an authentication token / X-Plex-Token](https://support.plex.tv/articles/204059436-finding-an-authentication-token-x-plex-token/) 

    $Plex_token = "Add_token_here"

### Plex local server IP
Can be found in the URL. Example: http://192.168.1.200:32400/web/index.html

    $Plex_local_server_IP = "192.168.1.200"

## Create a scheduled Task

1. Open Task Scheduler
2. Click "Create task..."
3. Go to the "Trigger" tab and add a new trigger. Select "Begin the task: At log on".
4. Go to the "Actions" tab and add the following:

    Action: Start a program  
    Program/script: Powershell.exe  
    Add arguments: -windowstyle hidden .\Plex_Keyboard_LED.ps1  
    Start in: < The location where you store the files >  

![enter image description here](https://i.imgur.com/reOXUuE.png)
