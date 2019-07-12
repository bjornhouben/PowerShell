function Set-UimMaintenanceMode
{
    <#
.SYNOPSIS
Sets maintenance mode for systems in CA UIM (Computer Associates Unified Infrastructure Management) by using nimalarm.exe.

.DESCRIPTION
Sets maintenance mode for systems in CA UIM (Computer Associates Unified Infrastructure Management) by using nimalarm.exe because we are not being granted access to the API.
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

Set-UimMaintenanceMode -ComputerName 'W7817' -Seconds 3600 -Reason 'Testing UIM Maintenance Mode script'

InitDate             : 2019-03-28
InitTime             : 14:32
Action               : Start Maintenance
Computer             : W7817
Seconds              : 3600
MaintEnddate         : 2019-03-28
MaintEndTime         : 15:32
ReturnCodeNimAlarm   : 0
LastExitCodeNimAlarm : 0
Reason               : Testing UIM Maintenance Mode script
InitBy               : bhr_bn0000155
InitFrom             : W7817

.EXAMPLE
Put the system W7817 into UIM Maintenance Mode for 1 hour and format the output as a table:

Set-UimMaintenanceMode -ComputerName 'W7817' -Seconds 3600 -Reason 'Testing UIM Maintenance Mode script' | Format-Table

InitDate   InitTime Action            Computer Seconds MaintEnddate MaintEndTime ReturnCodeNimAlarm LastExitCodeNimAlarm Reason                             
--------   -------- ------            -------- ------- ------------ ------------ ------------------ -------------------- ------                             
2019-03-28 17:16    Start Maintenance W7817    3600    2019-03-28   18:16                         0                    0 Testing UIM Maintenance Mode script

.EXAMPLE
Remove the system W7817 from UIM maintenance mode:

Set-UimMaintenanceMode -ComputerName 'W7817' -Seconds 0

InitDate             : 2019-03-28
InitTime             : 14:33
Action               : Stop Maintenance
Computer             : W7817
Seconds              : 0
MaintEnddate         : 2019-03-28
MaintEndTime         : 14:33
ReturnCodeNimAlarm   : 0
LastExitCodeNimAlarm : 0
Reason               : 
InitBy               : bhr_bn0000155
InitFrom             : W7817

.EXAMPLE
Add multiple systems to UIM maintenance mode and format the output as a table:

Set-UimMaintenanceMode -ComputerName 'W7817','WW7817','W7819','W7820' -Seconds 3600 -Reason 'Planned change for TASK123456' | Format-Table

.EXAMPLE
Remove multiple systems from UIM maintenance mode and format the output as a table:

Set-UimMaintenanceMode -ComputerName 'W7817','WW7817','W7819','W7820' -Seconds 0 | Format-Table

.NOTES
To improve  :  1) Check if the system is actually in UIM and if the system is actually being put into or removed from UIM maintenance mode. Currently it just creates the alarm and there are no checks in place to see if it was succesful.
               2) Maintenance endtime is approximately because it simply gets tthere is a delay between when we send a nimalarm with the request to put it in maintenance mode and when it is actually being put into maintenance mode.

NAME        :  Set-UimMaintenanceMode
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
        $Output = @()

        $ServiceName = 'NimbusWatcherService'
        $NimAlarmSeverityLevel = 1
        $NimAlarmDebugLevel = 3 #used to determine return code
        
        $LogFilePath = '\\fileshare.domain.local\repository\PowerShellLogging\Set-UimMaintenanceMode\Set-UimMaintenanceMode_log.csv'
        $LogFileReachable = Test-Path -Path $LogFilePath -ErrorAction SilentlyContinue


        IF ($Seconds -eq 0)
        {
            $Action = 'Stop Maintenance'
        }
        Else
        {
            $Action = 'Start Maintenance'
        }

        $ServiceInfo = Get-WmiObject -Class Win32_Service -Filter "name='$ServiceName'"
        IF ($NULL -ne $ServiceInfo)
        {
            $ServiceState = $ServiceInfo.state
            $ServiceRunning = $ServiceState -eq 'Running'
            $ServicePathName = $ServiceInfo.PathName
            $NimAlarmFullPath = ($ServicePathName -replace 'nimbus.exe', 'nimalarm.exe') -replace '"', ''
            $NimAlarmPresent = Test-Path -Path $NimAlarmFullPath
        }
        
        IF (($NULL -ne $ServiceInfo) -and ($ServiceRunning -eq $TRUE) -and ($NimAlarmPresent -eq $TRUE))
        {
            $PrereqCheckOk = $True
        }
        Else
        {
            $PrereqCheckOk = $False            
        }
    }
    PROCESS
    {
        IF ($PrereqCheckOk -eq $False)
        {
            Write-Output "PreChecks failed. Check if the $ServiceName service is present and running."
        }
        ELSE
        {
            Foreach ($item in $ComputerName)
            {
                Write-Verbose -Message "Trying to run command: $Command"
                Try #For now I don't see a way to do error handling properly from within PowerShell
                {
                    $DateInitiated = Get-Date -Format "yyyy-MM-dd"
                    $TimeInitiated = Get-Date -Format "HH:mm"
                    $EndDate = Get-Date -date (Get-Date).AddSeconds($seconds) -Format "yyyy-MM-dd"
                    $EndTime = Get-Date -date (Get-Date).AddSeconds($seconds) -Format "HH:mm"
                    $CMD = $NimAlarmFullPath
                    $NimAlarmMessage = "`"maint_on $item $Seconds`""
                    $AllArgs = @('-l', $NimAlarmSeverityLevel, '-d', $NimAlarmDebugLevel, $NimAlarmMessage)
                    $Result = & $CMD $AllArgs
                    $ResultLine = $Result | Where-Object { $_ -match 'Nimalarm returned' }
                    $ReturnCode = [INT]($resultline -split ': ')[-1].replace('nimAlarm returned ', '') #For ADP exit code other than 0 is fail.

                    <#If service is running, the debug ouput from the result should be similar to the one below if debug level 3 is used.
                    Mar 27 18:39:29:291 nimalarm: SREQUEST: probe_checkin ->127.0.0.1/48000
                    Mar 27 18:39:29:292 nimalarm: RREPLY: status=OK(0) <-127.0.0.1/48000  h=37 d=532
                    Mar 27 18:39:29:292 nimalarm: SREQUEST: _close ->127.0.0.1/48000
                    Mar 27 18:39:29:293 nimalarm: sslClientSetup - mode=0 cipher=DEFAULT
                    Mar 27 18:39:29:294 nimalarm: RREPLY: status=OK(0) <-127.0.0.1/48001  h=37 d=28
                    Mar 27 18:39:29:294 nimalarm: SREQUEST: _close ->127.0.0.1/48001
                    Mar 27 18:39:29:294 nimalarm: nimAlarm returned 0
                    #>

                    <#If service is not running, Debug output should be similar to the one below if debug level 3 is used.
                    Jun 15 13:48:41:843 nimalarm: sockConnect - connect to 127.0.0.1 48000 failed 10061
                    Jun 15 13:48:41:843 nimalarm: nimRequest: SessionConnect failed: 127.0.0.1 48000
                    Jun 15 13:48:41:846 nimalarm: nimCharsetAutoConvert() -- can't determine source encoding
                    Jun 15 13:48:41:846 nimalarm: nimSessionNew - _probeCheckin failed - communication error
                    Jun 15 13:48:42:847 nimalarm: sockConnect - connect to 127.0.0.1 48001 failed 10061
                    Jun 15 13:48:42:847 nimalarm: nimSession - failed to connect session to 127.0.0.1:48001, error code 10061
                    Jun 15 13:48:42:847 nimalarm: nimAlarm returned 2
                    #>


                    $Object = [PSCUSTOMOBJECT][ORDERED]@{

                        'InitDate'             = $DateInitiated
                        'InitTime'             = $TimeInitiated
                        'Action'               = $Action
                        'Computer'             = $Item
                        'Seconds'              = $Seconds
                        'MaintEnddate'         = $EndDate
                        'MaintEndTime'         = $EndTime
                        'ReturnCodeNimAlarm'   = $ReturnCode
                        'LastExitCodeNimAlarm' = $LastExitCode
                        'Reason'               = $Reason
                        'InitBy'               = $ENV:Username
                        'InitFrom'             = $ENV:Computername
                        'LogFileReachable'     = $LogFileReachable
                    }
                    $Output += $Object
                }
                CATCH
                {
                }
                FINALLY
                {
                }
            }
        } 
    }
    END
    {
        $Output #Return output to pipeline
        IF ($LogFileReachable)
        {
            $Output | Export-Csv -Path $LogFilePath -Append -NoTypeInformation -Delimiter ','
        }
    }
}