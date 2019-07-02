Function Get-UimMaintenanceMode
{
<#
.SYNOPSIS
Gets maintenance mode information for systems in CA UIM (Computer Associates Unified Infrastructure Management).

.DESCRIPTION
Gets maintenance mode information for systems in CA UIM (Computer Associates Unified Infrastructure Management) by querying SQL

.PARAMETER ServerInstance
The name of the CA UIM SQL server to query. Specifies a character string or SQL Server Management Objects (SMO) object that specifies the name of an instance of the Database Engine. For default instances, only specify the computer name: MyComputer. For named instances, use the format ComputerName\InstanceName.

.PARAMETER Credential
The PSCredential object whose Username and Password fields will be used to connect to the SQL instance.

.PARAMETER Database
Specifies the name of a database. This cmdlet connects to this database in the instance that is specified in the ServerInstance parameter.

If the Database parameter is not specified, the database that is used depends on whether the current path specifies both the SQLSERVER:\SQL folder and a database name. If the path specifies both the SQL folder and a database name, this cmdlet connects to the database that is specified in the path. If the path is not based on the SQL folder, or the path does not contain a database name, this cmdlet connects to the default database for the current login ID. If you specify the IgnoreProviderContext parameter switch, this cmdlet does not consider any database specified in the current path, and connects to the database defined as the default for the current login ID.

.PARAMETER Username
Specifies the login ID for making a SQL Server Authentication connection to an instance of the Database Engine.

The password must be specified through the Password parameter.

.PARAMETER Password
Specifies the password for the SQL Server Authentication login ID that was specified in the Username parameter. Passwords are case-sensitive. When possible, use Windows Authentication. Do not use a blank password, when possible use a strong password.

If you specify the Password parameter followed by your password, the password is visible to anyone who can see your monitor.

If you code Password followed by your password in a .ps1 script, anyone reading the script file will see your password.

Assign the appropriate NTFS permissions to the file to prevent other users from being able to read the file.

.PARAMETER IncludeHistory
By specifying the -IncludeHistory switch the output will also show historical maintenance mode schedules. It seems like the UIM team purges this info on a regular basis so it shows only a short history. If you don't specify it, it will only show systems that are currently in maintenance mode.

.EXAMPLE
Show only systems that are currently in UIM maintenance mode using the username and password default values:

Get-Date

Wednesday, March 27, 2019 1:36:58 PM

Get-UimMaintenanceMode

name                                  schedule_name                         start_time                            end_time                             
----                                  -------------                         ----------                            --------                             
0069                                OnDemand_0069                       3/18/2019 10:24:59 AM                 3/28/2019 10:24:59 AM                
1105                                OnDemand_1105                       3/26/2019 5:55:01 PM                  4/5/2019 6:55:01 PM                  
4178                                OnDemand_4178                       3/19/2019 10:49:05 AM                 3/29/2019 10:49:05 AM                
4985                                OnDemand_4985                       3/19/2019 11:32:27 AM                 3/29/2019 11:32:27 AM                
4990                                OnDemand_4990                       3/19/2019 11:27:50 AM                 3/29/2019 11:27:50 AM                
7759                               OnDemand_7759                        2/27/2019 12:10:00 PM                 7/27/2019 1:10:00 PM                 

.EXAMPLE
Show systems currently in UIM maintenance mode and systems that have been in UIM maintenance mode recently using the username and password default values:

Get-Date

Wednesday, March 27, 2019 1:36:58 PM

Get-UimMaintenanceMode -IncludeHistory

name                                  schedule_name                         start_time                            end_time                             
----                                  -------------                         ----------                            --------                             
9a01                                OnDemand_9a01                       3/27/2019 12:28:00 AM                 3/27/2019 1:28:00 AM                 
9a02                                OnDemand_9a02                       3/27/2019 12:28:00 AM                 3/27/2019 1:28:00 AM                 
0069                                OnDemand_0069                       3/18/2019 10:24:59 AM                 3/28/2019 10:24:59 AM                
0142                                OnDemand_0142                       3/27/2019 10:04:43 AM                 3/27/2019 11:04:43 AM                
0143                                OnDemand_0143                       3/27/2019 10:04:05 AM                 3/27/2019 11:04:05 AM                
0144                                OnDemand_0144                       3/27/2019 10:04:29 AM                 3/27/2019 11:04:29 AM                
0145                                OnDemand_0145                       3/27/2019 10:04:01 AM                 3/27/2019 11:04:01 AM                
0146                                OnDemand_0146                       3/27/2019 10:03:57 AM                 3/27/2019 11:03:57 AM                
0147                                OnDemand_0147                       3/27/2019 10:04:08 AM                 3/27/2019 11:04:08 AM                
0148                                OnDemand_0148                       3/27/2019 10:04:32 AM                 3/27/2019 11:04:32 AM                
0519                                OnDemand_0519                       3/27/2019 10:04:36 AM                 3/27/2019 11:04:36 AM                
1105                                OnDemand_1105                       3/26/2019 5:55:01 PM                  4/5/2019 6:55:01 PM                  
1107                                OnDemand_1107                       3/26/2019 7:42:11 PM                  3/27/2019 11:52:32 AM                
1107                                OnDemand_1107                       3/27/2019 10:04:24 AM                 3/27/2019 11:04:24 AM                
1115                                OnDemand_1115                       3/27/2019 10:04:17 AM                 3/27/2019 11:04:17 AM                
1137                                OnDemand_1137                       3/27/2019 10:03:51 AM                 3/27/2019 10:34:32 AM                
1159                                OnDemand_1159                       3/27/2019 10:04:12 AM                 3/27/2019 11:04:12 AM                
4144                                OnDemand_4144                       3/27/2019 10:04:21 AM                 3/27/2019 11:04:21 AM                
4178                                OnDemand_4178                       3/19/2019 10:49:05 AM                 3/29/2019 10:49:05 AM                
4681                                OnDemand_4681                       3/27/2019 10:04:47 AM                 3/27/2019 11:04:47 AM                
4683                                OnDemand_4683                       3/27/2019 10:04:39 AM                 3/27/2019 11:04:39 AM                
4985                                OnDemand_4985                       3/19/2019 11:32:27 AM                 3/29/2019 11:32:27 AM                
4990                                OnDemand_4990                       3/19/2019 11:27:50 AM                 3/29/2019 11:27:50 AM                
7759                                OnDemand_7759                       2/27/2019 12:10:00 PM                 7/27/2019 1:10:00 PM                 

.EXAMPLE
Show only systems that are currently in UIM maintenance mode using specifically provided credentials:

Get-UimMaintenanceMode -Credential (Get-Credential)

.EXAMPLE
Show only systems that are currently in UIM maintenance mode using the credentials of the currently logged on user:

Get-UimMaintenanceMode -UseLoggedOnUser

.NOTES
ASSUMPTIONS :  1) Invoke-Sqlcmd is present. To use the credential parameter you need to have a specific version of Invoke-SqlCmd. For more info see https://stackoverflow.com/questions/51622424/powershell-invoke-sqlcmd-with-get-credential-doesnt-work
               2) Network connection (including FW) is in place
NAME        :  Get-UimMaintenanceMode
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

.OUTPUTS
[object]
#>
    [cmdletbinding(DefaultParameterSetName='UserPassword')]

    Param(
    [Parameter(Position = 0)]
    [ValidateNotNullorEmpty()]
    [string]$ServerInstance = 'listeneruimdb.tooling.local',

    [Parameter(Position = 1)]
    [ValidateNotNullorEmpty()]
    [string]$Database = 'CA_UIM',

    [Parameter(Position = 2,ParameterSetName='UserPassword')]
    [ValidateNotNullorEmpty()]
    [string]$Username = 'sa_uimmaintenanceinfo', #This SQL user is created specifically for this purpose locally on the listeneruimdb.tooling.local and it only has select permissions on the needed tables. 

    [Parameter(Position = 3,ParameterSetName='UserPassword')]
    [ValidateNotNullorEmpty()]
    [string]$Password = '123456790', #The password for the user is in clear text. This SQL user howeveris created specifically for this purpose locally on the listeneruimdb.tooling.local and it only has select permissions on the needed tables.

    [Parameter(position = 4,ParameterSetName='Credential')]
    [System.Management.Automation.PSCredential]$Credential,

    [Parameter(position = 5,ParameterSetName='UseLoggedOnUser')]
    [SWITCH]$UseLoggedOnUser,

    [Parameter(position = 6)]
    [switch]$IncludeHistory
    )
    BEGIN
    {
        $Query = "SELECT distinct cmcs.name, ms.schedule_name, mw.start_time, mw.end_time, cmcs.os_type from MAINTENANCE_WINDOW mw
        INNER JOIN CM_DEVICE cmd on mw.dev_id = cmd.dev_id
        INNER JOIN CM_COMPUTER_SYSTEM cmcs on cmcs.cs_id = cmd.cs_id
        INNER JOIN MAINTENANCE_SCHEDULE ms on mw.schedule_id = ms.schedule_id
        ---Object mw.end_time > GETDATE()"
    }
    PROCESS
    {
        TRY
        {
            IF($PSCmdlet.ParameterSetName -eq 'UserPassword')
            {
                $Result = Invoke-Sqlcmd -Query $Query -Database $Database -ServerInstance $ServerInstance -hostname $env:COMPUTERNAME -Username $Username -Password $Password -erroraction stop #initially I wanted to omit the username and password, but the cmdlet is run using a logged on user in the one domain and the SQL server is in another domain that has no trust with the first one.
            }
            ELSEIF($PSCmdlet.ParameterSetName -eq 'Credential') #This requires a specific version of Invoke-SqlCmd. For more info see https://stackoverflow.com/questions/51622424/powershell-invoke-sqlcmd-with-get-credential-doesnt-work
            {
                $Result = Invoke-Sqlcmd -Query $Query -Database $Database -ServerInstance $ServerInstance -hostname $env:COMPUTERNAME -credential $Credential -erroraction stop

            }
            ELSEIF($PSCmdlet.ParameterSetName -eq 'UseLoggedOnUser')
            {
                $Result = Invoke-Sqlcmd -Query $Query -Database $Database -ServerInstance $ServerInstance -hostname $env:COMPUTERNAME -erroraction stop
            }
           
            IF($IncludeHistory)
            {
                $Result
            }
            ELSE
            {
                $Result | Where-Object{$_.end_time -gt (get-date)}
            }
        }
        CATCH
        {
            $Error[0]
        }
        FINALLY
        {
        }
    }
    END
    {
    }
}