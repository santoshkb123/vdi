#Variable Section
$scriptlogpath = "C:\VMware_IT\Logs" #local path for logs
$version = Get-Date -UFormat %m%y%y
$scriptfilename = "VDI_Stagging-$version.log" #local log file name
$DestinationFolder = "C:\VMware_IT\Installs" #local destination path
$DeviceOwnershipType = "CD" #device ownership type
$STGSERVER = "stg.awmdm.com" #enrollment server
$GROUPID = "VDI" #Organization group name where you want enrollment to happen
$USERNAME = "vdistaging" #staging ccount username
$PASSWORD = "Password@123" #staging account password
# Download Workspace ONE® Intelligent Hub latest build
$WS1IntelligentHub = "https://storage.googleapis.com/getwsone-com-prod/downloads/AirwatchAgent.msi"

Start-Transcript $scriptlogpath\$scriptfilename
Function WS1Downloader
{
Try
{
Start-BitsTransfer -Source $WS1IntelligentHub -Destination $DestinationFolder -ErrorAction Continue
}
Catch
{
Write-host $_.Exception
}
}
# Installation Commands
$ArgumentList = "/i C:\VMware_IT\Installs\AirwatchAgent.msi /qn /norestart ENROLL=Y IMAGE=N SERVER=$STGSERVER LGName=$GROUPID USERNAME=$USERNAME PASSWORD=$PASSWORD DEVICEOWNERSHIPTYPE=CD ASSIGNTOLOGGEDINUSER=Y"
Function WS1Installer
{
Try
{		
 $ExitCode = (Start-Process -Filepath msiexec -ArgumentList $ArgumentList -Wait -PassThru).ExitCode

    IF ($ExitCode -eq 0)
    {
        Write-host "WS1 Hub installed successfully..."
        Restart-Computer -Force -Confirm:$false -ErrorAction SilentlyContinue
    }
    Else
    {
        Write-Host "failed. There was a problem installing WS1 Agent. MsiExec returned exit code $ExitCode."
        Exit
    }
}
Catch
{
Write-host $_.Exception
}
}

# Verifying if the installer is present in the local drive
IF (Test-Path -Path "C:\VMware_IT\Installs\AirwatchAgent.msi")
{
WS1Installer
}
Else
{
WS1Downloader
WS1Installer
}
Stop-Transcript