#Variable Section
$ver = "v1"
$Logfile = "C:\VMware_IT\Logs\DomainJoin-$ver.log" # Log file location
$VDIHostname = "$env:COMPUTERNAME"

Function LogWrite
{
	Param ([string]$logstring)
	$datentime = Get-Date -Format g
	$logstring = "$datentime" + ": " + "$logstring"
	Add-content $Logfile -value $logstring
}

# Domain Join OU & Account Details
$DOMAIN="SANTOSHLAB.COM"	# Domain Name
$ACCOUNT="vdi_join"			# Domain account
$PWD="P@ssw0rd123"			# Domain user Password
$secPass=ConvertTo-SecureString $PWD -AsPlainText -Force
$cred= New-object System.Management.Automation.PSCredential -ArgumentList “$ACCOUNT@$DOMAIN”, $secPass

# OU Path
$UATOU = "OU=VDI-UAT,OU=Workstations,DC=santoshlab,DC=com" 

# Joining the Device to PreDefined OU.
LogWrite "Computer name is $VDIHostname"
LogWrite "Joining the Computer to the OU $UATOU"
Add-Computer -DomainName $DOMAIN -OUPath $UATOU -credential $cred -Restart -Confirm:$false
