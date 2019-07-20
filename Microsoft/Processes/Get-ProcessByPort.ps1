function Get-NetworkStatistics #Created by Shay Levy - http://blogs.microsoft.co.il/scriptfanatic/2011/02/10/how-to-find-running-processes-and-their-port-number/
{ 
    $properties = ‘Protocol’,’LocalAddress’,’LocalPort’ 
    $properties += ‘RemoteAddress’,’RemotePort’,’State’,’ProcessName’,’PID’ 

    netstat -ano | Select-String -Pattern ‘\s+(TCP|UDP)’ | ForEach-Object { 

        $item = $_.line.split(” “,[System.StringSplitOptions]::RemoveEmptyEntries) 

        if($item[1] -notmatch ‘^\[::’) 
        {            
            if (($la = $item[1] -as [ipaddress]).AddressFamily -eq ‘InterNetworkV6’) 
            { 
               $localAddress = $la.IPAddressToString 
               $localPort = $item[1].split(‘\]:’)[-1] 
            } 
            else 
            { 
                $localAddress = $item[1].split(‘:’)[0] 
                $localPort = $item[1].split(‘:’)[-1] 
            }  

            if (($ra = $item[2] -as [ipaddress]).AddressFamily -eq ‘InterNetworkV6’) 
            { 
               $remoteAddress = $ra.IPAddressToString 
               $remotePort = $item[2].split(‘\]:’)[-1] 
            } 
            else 
            { 
               $remoteAddress = $item[2].split(‘:’)[0] 
               $remotePort = $item[2].split(‘:’)[-1] 
            }  

            New-Object PSObject -Property @{ 
                PID = $item[-1] 
                ProcessName = (Get-Process -Id $item[-1] -ErrorAction SilentlyContinue).Name 
                Protocol = $item[0] 
                LocalAddress = $localAddress 
                LocalPort = $localPort 
                RemoteAddress =$remoteAddress 
                RemotePort = $remotePort 
                State = if($item[0] -eq ‘tcp’) {$item[3]} else {$null} 
            } | Select-Object -Property $properties 
        } 
    } 
} 

Function Get-ProcessByPort
{
<#
.SYNOPSIS
This function checks if specified ports on a local computer are listening and what processes are using it.

.DESCRIPTION
This function checks if specified ports on a local computer are listening and what processes are using it. If the process using it is svchost it will try to get more information about what exactly is using the port

It works by first using Get-NetworkStatistics (function by Shay Levy : http://blogs.microsoft.co.il/scriptfanatic/2011/02/10/how-to-find-running-processes-and-their-port-number/) to get the listening ports and process ID's and then filtering out only the specified ports. Then using Get-Process the process details will be gathered. If the process is svchost, Get-WmiObject -Class win32_service will be used to gather more details about which service within svchost is actually using a port.

.PARAMETER PortsToCheck
Specify one or more ports to check. Separate each port by a comma. By example 1505,2144,3306,3389

.PARAMETER OutputAsObject
Set this parameter to $TRUE if you want/need the output to be an object. If set to $FALSE or when not specified, the output will be to console.

.EXAMPLE
Get-ProcessByPort -PortsToCheck 1505,2144,3306,3389

====================================================================
Script started at 2019-07-20 11:21 on system WINDOWS-0KHJ6UM

Specified ports for scan:

1505
2144
3306
3389

Ports found in netstat as listening ports:


Ports NOT found in netstat as listening ports:

1505
2144
3306
3389

Output of relevant results from netstat:

Output of relevant process info:

Script completed at 2019-07-20 11:21 on system WINDOWS-0KHJ6UM
====================================================================

This command Checks if the ports 1505,2144,3306 and 3389 are listening on the local system and if so, it shows which process/program is behind it.

.EXAMPLE
Get-ProcessByPort -PortsToCheck (Get-Content -Path 'C:\Temp\PortsToCheck.txt')

====================================================================
Script started at 2019-07-20 11:21 on system WINDOWS-0KHJ6UM

Specified ports for scan:

1505
2144
3306
3389

Ports found in netstat as listening ports:


Ports NOT found in netstat as listening ports:

1505
2144
3306
3389

Output of relevant results from netstat:

Output of relevant process info:

Script completed at 2019-07-20 11:21 on system WINDOWS-0KHJ6UM
====================================================================

Put the ports to check in .txt file with each port on a separate line and check if the ports are listening on the local system. If so, it shows which process/program is behind it.
.EXAMPLE
PS C:\WINDOWS\system32> $Result = Get-ProcessByPort -PortsToCheck 1505,2144,3306,3389,445 -OutputAsObject $true

PS C:\WINDOWS\system32> $Result | Format-Table

Computername    StartDateTime    EndDateTime      PortsToCheck                PortsFound PortsNotFound            RelevantResults                                                                           
------------    -------------    -----------      ------------                ---------- -------------            ---------------                                                                           
WINDOWS-0KHJ6UM 2019-07-20 11:50 2019-07-20 11:50 {1505, 2144, 3306, 3389...} 445        {1505, 2144, 3306, 3389} @{Protocol=TCP; LocalAddress=0.0.0.0; LocalPort=445; RemoteAddress=0.0.0.0; RemotePort=...



PS C:\WINDOWS\system32> $Result.RelevantResults | Format-Table

Protocol LocalAddress LocalPort RemoteAddress RemotePort State     ProcessName PID
-------- ------------ --------- ------------- ---------- -----     ----------- ---
TCP      0.0.0.0      445       0.0.0.0       0          LISTENING System      4  


These commands check if the ports 1505,2144,3306 and 3389 are listening on the local system and if so, it shows which process/program is behind it.
The difference with the other examples is that the output is an object, and not console output.
.NOTES
NAME        :  Get-ProcessByPort
VERSION     :  1.0   
LAST UPDATED:  2019/07/20
AUTHOR      :  Bjorn Houben (Twitter @BjornHouben)
To improve  :  Add option to run it against multiple remote computers. For now, PowerShell remoting can be used instead to achieve this.

  ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************

.INPUTS
[string[]] for ports to check
[Booleaan] for OutputAsObject

.OUTPUTS
[object] or console output

#>

    [cmdletbinding()]

    Param(
    [Parameter(Position = 0)]
    [ValidateNotNullorEmpty()]
    [string[]]$PortsToCheck,
    
    [Parameter(Position = 1)]
    [ValidateNotNullorEmpty()]
    [Boolean]$OutputAsObject
    )

    BEGIN
    {
        #The script needs to be run as administrator otherwise not all information will be gathered.
        If (-NOT ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] “Administrator”))
        {
            $HasAdminRights = $False
        }
        Else
        {
            $HasAdminRights = $True
        }

        IF($HasAdminRights)
        {
            Try
            {
                $GetNetworkStatisticsPresentResult = Get-command Get-Networkstatistics -ErrorAction Stop
                $GetNetworkStatisticsPresent = $TRUE
            }
            CATCH
            {
                $GetNetworkStatisticsPresent = $FALSE
            }
        }
        IF($GetNetworkStatisticsPresent -eq $TRUE)
        {
            $StartDateTime = Get-Date -format "yyyy-MM-dd HH:mm"
            $ComputerName = $env:Computername
            $Results = Get-NetworkStatistics
            $RelevantResults = $Results | Where-Object{($_.state -eq 'LISTENING') -and ($_.LocalPort -in $PortsToCheck)} #Only check for listening ports
            $PortsNotFound = $PortsToCheck | Where-Object{$_ -notin $RelevantResults.localport}
            $PortsFound = $PortsToCheck | Where-Object{$_ -in $RelevantResults.localport}

            $SvcHostServicesInfo = @()
            $ProcessesInfo = @()
        }

        IF($HasAdminRights -eq $False)
        {
            Write-Error -Message 'This script needs to be run with administrator privileges, but is now being run without administrator privileges. Please run the script again with administrator privileges.'
        }
        IF($GetNetworkStatisticsPresent -eq $False)
        {
            Write-Error -Message 'Get-NetworkStatistics function was not found.'
        }
    }
    PROCESS
    {

        IF($HasAdminRights -eq $TRUE)
        {
            Foreach($Item in $RelevantResults)
            {
                $LocalPort = $Item.LocalPort
                $ProcessId = $Item.PID
                TRY
                {
                    $ProcessInfo = Get-Process -Id $ProcessId -ErrorAction Stop
                }
                CATCH
                {
                    $ProcessInfo = "Error"
                }
                $ProcessName = $ProcessInfo.ProcessName
                $ProcessObject = [PSCUSTOMOBJECT][ORDERED]@{
                    'LocalPort' = $LocalPort
                    'ProcessID' = $ProcessId
                    'ProcessName' = $ProcessName
                    'Description' = $ProcessInfo.Description
                    'Path' = $ProcessInfo.Path
                    'StartInfoUsername' = $ProcessInfo.StartInfo.UserName
                    'StartInfoWorkingDirectory' = $ProcessInfo.StartInfo.WorkingDirectory
                    'StartTime' = $ProcessInfo.StartTime
                }
                $ProcessesInfo += $ProcessObject
                IF($ProcessName -eq 'svchost')
                {
                    $SvcHostServices = Get-WmiObject -Class win32_service -Filter "ProcessID='$ProcessId'"
                    Foreach($SvcHostService in $SvcHostServices)
                    {
                        $SvcHostObject = [PSCUSTOMOBJECT][ORDERED]@{
                            'LocalPort' = $LocalPort
                            'ProcessID' = $ProcessId
                            'ProcessName' = $ProcessName
                            'SvcProcessId' = $SvcHostService.ProcessId
                            'SvcDisplayName' = $SvcHostServices.DisplayName
                            'SvcPathName' = $SvcHostService.PathName
                            'SvcDescription' = $SvcHostService.Description
                        }
                        $SvcHostServicesInfo += $SvcHostObject
                    }
                }
            }
        }
    }
    END
    {
        IF($HasAdminRights)
        {
            $EndDateTime = Get-Date -format "yyyy-MM-dd HH:mm"
            $Result=[PSCUSTOMOBJECT][ORDERED]@{ #Construct output object and actually output it
                'Computername' = $ComputerName
                'StartDateTime' = $StartDateTime
                'EndDateTime' = $EndDateTime
                'PortsToCheck' = $PortsToCheck
                'PortsFound' = $PortsFound
                'PortsNotFound' = $PortsNotFound
                'RelevantResults' = $RelevantResults
                'ProcessesInfo' = $ProcessesInfo
                'SvcHostServicesInfo' = $SvcHostServicesInfo
            }
            IF(($OutputAsObject -eq $False) -and ($GetNetworkStatisticsPresent -eq $TRUE)) #When console output is preferred
            {
                $FormatEnumerationLimit = -1

                Write-Host "Script started at $($Result.StartDateTime) on system $env:Computername" -BackgroundColor 'Yellow' -ForegroundColor 'Black'
                Write-Host ""

                Write-Host "Specified ports for scan:" -BackgroundColor 'Black' -ForegroundColor 'Yellow'
                Write-Host ""
                $Result.PortsToCheck
                Write-Host ""

                Write-Host "Ports found in netstat as listening ports:" -BackgroundColor 'Black' -ForegroundColor 'Yellow'
                Write-Host ""
                $Result.PortsFound
                Write-Host ""

                Write-Host "Ports NOT found in netstat as listening ports:" -BackgroundColor 'Black' -ForegroundColor 'Yellow'
                Write-Host ""
                $Result.PortsNotFound
                Write-Host ""

                Write-Host "Output of relevant results from netstat:" -BackgroundColor 'Black' -ForegroundColor 'Yellow'
                $Result.RelevantResults | Select-Object LocalPort,@{Name='ProcessID';Expression={$_.PID}}, ProcessName, Protocol, RemoteAddress, RemotePort, State | Format-Table -AutoSize -wrap
                Write-Host ""

                Write-Host "Output of relevant process info:" -BackgroundColor 'Black' -ForegroundColor 'Yellow'
                $Result.ProcessesInfo | Where-Object{$NULL -ne $_.ProcessId} | Format-Table -AutoSize -wrap
                Write-Host ""

                IF($Result.ProcessesInfo.ProcessId -contains 4)
                {
                    Write-Host "Tip: For ports used by System (process ID 4) that you can't relate to a program/process, check Internet Information Services (IIS)." -BackgroundColor 'Black' -ForegroundColor 'Yellow'
                    Write-Host ""
                }

                IF($Null -ne $($Result.SvcHostServicesInfo))
                {
                    Write-Host "Output information about services hosted by svchost:" -BackgroundColor 'Black' -ForegroundColor 'Yellow'
                    $Result.SvcHostServicesInfo | Select-Object -Unique | Format-Table -AutoSize -Wrap
                    Write-Host ""
                }
                Write-Host "Script completed at $($Result.EndDateTime) on system $($Result.Computername)" -BackgroundColor 'Yellow' -ForegroundColor 'Black'
                Write-Host ""
            }
            ELSEIF(($OutputAsObject -eq $TRUE) -and ($GetNetworkStatisticsPresent -eq $TRUE))
            {
                $Result
            }
        }
    }
}

#region run the function

#Specify the ports to check manually
$PortsToCheck = 1505,2144,3306,3389,445

#Or put the ports to check in .txt file with each port on a separate line
#$PortsToCheck = Get-Content -Path 'C:\Temp\PortsToCheck.txt' | Select-Object -Unique | Sort-Object

Get-ProcessByPort -PortsToCheck $PortsToCheck

#endregion run the function and store the results

#Modify examples to match OutputAsObject (or not)
#Examples to output as object or as console output
#Add parameter in help
#Modify parameter required options, etc, validation, etc.
#Add to KPN module
#If process name is system, check IIS?