Function Start-UimMaintenanceMode
{
    <#
.SYNOPSIS
Starts maintenance mode for specified systems in CA UIM (Computer Associates Unified Infrastructure Management) by using nimalarm.exe.

.DESCRIPTION
Starts maintenance mode for specified systems in CA UIM (Computer Associates Unified Infrastructure Management) by using nimalarm.exe because we are not being granted access to the API.
The workaround being implemented by the UIM team has been described here: https://communities.ca.com/docs/DOC-231176423-set-a-device-in-maintenance-via-nimalarm

For more information about nimalarm see also:
https://communities.ca.com/thread/241782623-nimalarmexe-options
https://docops.ca.com/ca-unified-infrastructure-management/8-1/en/development-tools/the-nimalarm-utility

This means it must be run from a system that has the UIM agent/client installed and has its service running.

.PARAMETER Computername
Specify one or more computernames to put into UIM maintenance mode. This can be any type of system, it isn't limited to by example only Windows machines.

.PARAMETER Seconds
Specify the number of seconds you want to put the system(s) in UIM maintenance mode. By specifying 0, a system will be removed from UIM Maintenance Mode.

.PARAMETER Reason
Optionally enter the reason why a system is being put into UIM maintenance mode.

.EXAMPLE
Put the system W7817 into UIM Maintenance Mode for 1 hour:

Start-UimMaintenanceMode -ComputerName 'W7817' -Seconds 3600 -Reason 'Testing UIM Maintenance Mode script'

InitDate             : 2019-03-28
InitTime             : 14:32
Action               : Start Maintenance
Computer             : 7817
Seconds              : 3600
MaintEnddate         : 2019-03-28
MaintEndTime         : 15:32
ReturnCodeNimAlarm   : 0
LastExitCodeNimAlarm : 0
Reason               : Testing UIM Maintenance Mode script
InitBy               : bjornhouben
InitFrom             : 7817

Add multiple systems to UIM maintenance mode:

Start-UimMaintenanceMode -ComputerName '7817','7818','7819','7820' -Seconds 3600 -Reason 'Planned change for TASK123456' | Format-Table

.NOTES
To improve  :  
NAME        :  Start-UimMaintenanceMode
VERSION     :  1.0   
LAST UPDATED:  2019-03-27
AUTHOR      :  Bjorn Houben (bjorn@bjornhouben.com)

  ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************

.INPUTS
[string] for hostname
[int]  for seconds
[string] for reason

.OUTPUTS
[object]
#>
    [cmdletbinding()]

    Param(
        [Parameter(Position = 0, Mandatory = $TRUE,ValueFromPipeline = $true)]
        [ValidateNotNullorEmpty()]
        [string[]]$Computername,

        [Parameter(Position = 1, Mandatory = $TRUE)]
        [ValidateNotNullorEmpty()]
        [string]$Seconds, #I don't know what the maximum accepted value is. Otherwise I would add parameter validation.

        [Parameter(Position = 2, Mandatory = $FALSE)]
        [ValidateNotNullorEmpty()]
        [string]$Reason
    )    
    BEGIN
    {
    }
    PROCESS
    {
        Foreach($Computer in $Computername)
        {
            Set-UimMaintenanceMode -ComputerName $computer -Seconds $Seconds -Reason $Reason
        }
    }
    END
    {
        #Write to file?
        #Send mail?
        #Verify if it is actually in maintenance mode by using SQL query
    }
}