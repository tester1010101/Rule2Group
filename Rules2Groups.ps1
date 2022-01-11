function Test-Administrator{  
    $user = [Security.Principal.WindowsIdentity]::GetCurrent();
    (New-Object Security.Principal.WindowsPrincipal $user).IsInRole([Security.Principal.WindowsBuiltinRole]::Administrator)  
}
[bool]$ADMINTEST = Test-Administrator
if ($ADMINTEST -eq $false)
{
    Write-Host "SCRIPT MUST BE RUN AS ADMIN, `nTry again with PowerShell (Run as Administrator) then 'cd' to the script & run it with '.\'`n'If needed, run this command:' Set-ExecutionPolicy Unrestricted" -ForegroundColor Red
    pause
    exit
}

function Loop {
Write-Host "Rule Exact Name?" 
$RULE = Read-Host
Write-Host "Group Exact Name?" 
$GROUP = Read-Host
Get-NetFirewallRule -DisplayName "$RULE" | % { $_.Group = "$GROUP" ; Set-NetFirewallRule -InputObject $_ }
}

function Wonder {
Write-Host "Add a rule? [Y/N]" -ForegroundColor Yellow
$ANSWER = Read-Host
if ($ANSWER -match "Y") { 
	Loop
    Wonder
}
elseif ($ANSWER -match "N") { 
	Write-Host "Exiting, restart the script if needed."
    sleep 3
    exit
}
else {
    Write-Host "Wrong Selection, try again (type Y or N)"
    sleep 3
    Wonder
    }
}
Wonder