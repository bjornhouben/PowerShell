Function Get-BHCmDeviceCollectionDirectMembershipRule
{
<#
.SYNOPSIS
Gets direct membership rule for one or more system center configuration manager (sccm) device collections.

.DESCRIPTION
Gets direct membership rule for one or more system center configuration manager (sccm) device collections.

.PARAMETER CollectionName
Specify one or more collectionnames for which you want to get the direct membership rules.

.PARAMETER Sitecode
Specify the SCCM site code to be used.

.PARAMETER ProviderMachineName
Specify the SCCM ProviderMachineName to be used. To manage Configuration Manager, you use a Configuration Manager console that connects to an instance of the SMS Provider. By default, an SMS Provider installs on the site server when you install a central administration site or primary site.
.EXAMPLE
$Result = New-Object System.Collections.Generic.List[System.Object]
1..31 | Foreach-Object{
    IF($_ -lt 10)
    {
        $DayNumber = "0$_"
    }
    ELSE
    {
        $DayNumber = $_
    }
    $Result.add((Get-BHCmDeviceCollectionDirectMembershipRule -CollectionName "Patching - $DayNumber Monthly"))
}
$Result | Where-Object {$_.ErrorOccurred -eq $False} | Sort-Object Collection, RuleName | Format-Table

Collection            ErrorOccurred RuleName                                                              
Patching - 01 Monthly         False SWNC7R044                                                             
Patching - 02 Monthly         False SWNC7R045                                                             
Patching - 03 Monthly         False SWNC7R046                                                                                                                                                                         
Patching - 29 Monthly         False SWNC7R1183                                                            
Patching - 30 Monthly         False SWNC7R1184                                                            
Patching - 31 Monthly         False SWNC7R1185                                                            

This command gets the direct membership rules of the device collections named 'Patching - 01 Monthly' to 'Patching - 31 Monthly'.
.EXAMPLE
Get-BHCmDeviceCollectionDirectMembershipRule -CollectionName 'Patching - 13 Monthly','Patching - 14 Monthly','NonExistingCllection' | Sort-Object Collection,RuleName | Select-Object Collection, ErrorOccurred, RuleName | Format-Table

Collection            ErrorOccurred RuleName                                                              
----------            ------------- --------                                                              
NonExistingCOllection          True Error: Collection with name 'NonExistingCollection' could not be found
Patching - 13 Monthly         False SWNC7R044                                                             
Patching - 13 Monthly         False SWNC7R045                                                             
Patching - 13 Monthly         False SWNC7R046                                                                                                                                                                         
Patching - 14 Monthly         False SWNC7R1183                                                            
Patching - 14 Monthly         False SWNC7R1184                                                            
Patching - 14 Monthly         False SWNC7R1185                                                            

This command gets the direct membership rules of the device collections named 'Patching - 13 Monthly','Patching - 14 Monthly' and 'NonExistingCllection'.
.EXAMPLE
Get-BHCmDeviceCollectionDirectMembershipRule -CollectionName 'Patching - 13 Monthly','Patching - 14 Monthly','NonExistingCllection' | Where-Object{$_.ErrorOccurred -eq $TRUE} | Sort-Object Collection,RuleName | Select-Object Collection, ErrorOccurred, RuleName

Get-BHCmDeviceCollectionDirectMembershipRule : Collection with name 'NonExistingCllection' could not be found
At line:1 char:1
+ Get-BHCmDeviceCollectionDirectMembershipRule -CollectionName 'Patchi ...
+ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    + CategoryInfo          : NotSpecified: (:) [Write-Error], WriteErrorException
    + FullyQualifiedErrorId : Microsoft.PowerShell.Commands.WriteErrorException,Get-BHCmDeviceCollectionDirectMembershipRule
 

Collection           ErrorOccurred RuleName                                                             
----------           ------------- --------                                                             
NonExistingCllection          True Error: Collection with name 'NonExistingCllection' could not be found

This command gets the direct membership rules of the device collections named 'Patching - 13 Monthly','Patching - 14 Monthly' and 'NonExistingCllection' and outputs only the ones where an error occurred.
.EXAMPLE
Get-BHCmDeviceCollectionDirectMembershipRule -CollectionName "Patching - 16 Monthly" | Where-Object{$_.ErrorOccurred -eq $False} | Select-Object -ExpandProperty RuleName | Sort-Object | Foreach-Object{Start-UimMaintenanceMode -Computername $_ -Seconds 600 -Reason 'testing uim snooze for patching'}

InitDate             : 2019-07-12
InitTime             : 15:02
Action               : Start Maintenance
Computer             : SW22R0081
Seconds              : 600
MaintEnddate         : 2019-07-12
MaintEndTime         : 15:12
ReturnCodeNimAlarm   : 0
LastExitCodeNimAlarm : 0
Reason               : testing uim snooze for patching
InitBy               : bjornhouben
InitFrom             : W7759
LogFileReachable     : False

This command gets the direct membership rules from the device collection named "Patching - 16 Monthly" and puts them in UIM maintenance mode for 10 minutes.
.EXAMPLE
$Daynumber = (Get-Date).day
IF($Daynumber -lt 10){$DayNumber = "0$DayNumber"}
$Result = Get-BHCmDeviceCollectionDirectMembershipRule -CollectionName "Patching - $DayNumber Monthly" | Where-Object{$_.ErrorOccurred -eq $False} | Select-Object -ExpandProperty RuleName | Sort-Object | Foreach-Object{Start-UimMaintenanceMode -Computername $_ -Seconds 600 -Reason 'testing uim snooze for patching'}
$Result | Format-Table

This command gets the current day number and then gets the corresponding SCCM patching device collection and places the systems with direct memberships in UIM maintenance mode for 10 minutes.
This is by example useful if you have fixed hours of daily maintenance. This way you can easily schedule UIM snoozing using a scheduled task.
.NOTES
To improve  :  
NAME        :  Get-BHCmDeviceCollectionDirectMembershipRule
VERSION     :  1.0   
LAST UPDATED:  2019-07-12
AUTHOR      :  Bjorn Houben (bjorn.houben@kpn.com)

  ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************

.INPUTS
[string] for CollectionName
[string] for SiteCode
[string] for ProviderMachineName

.OUTPUTS
[object]
#>
    [cmdletbinding()]
    Param(
        [Parameter(
            Mandatory=$False)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({$_.length -eq 3})]
        [STRING]$SiteCode='KDC',

        [Parameter(
            Mandatory=$False)]
        [ValidateNotNullOrEmpty()]
        [STRING]$ProviderMachineName='W7784.kpnnl.local',
        [Parameter(
            Mandatory=$True,
            ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [STRING[]]$CollectionName
    )
    BEGIN
    {
        $Result = New-Object System.Collections.Generic.List[System.Object] #This method is quicker than creating an empty array using $Output = @() and then adding to it using += , for more info see: https://powershell.org/2013/09/powershell-performance-the-operator-and-when-to-avoid-it/
        $InitialLocation = Get-Location

        #region SCCM configuration

        # Customizations
        $initParams = @{}
        #$initParams.Add("Verbose", $true) # Uncomment this line to enable verbose logging
        $initParams.Add("ErrorAction", "Stop") # Uncomment this line to stop the script on any errors

        # Import the ConfigurationManager.psd1 module 
        if ($null -eq (Get-Module ConfigurationManager)) 
        {
            Import-Module "$($ENV:SMS_ADMIN_UI_PATH)\..\ConfigurationManager.psd1" @initParams 
        }

        # Connect to the site's drive if it is not already present
        if ($null -eq (Get-PSDrive -Name $SiteCode -PSProvider CMSite -ErrorAction SilentlyContinue)) 
        {
            New-PSDrive -Name $SiteCode -PSProvider CMSite -Root $ProviderMachineName @initParams
        }

        # Set the current location to be the site code.
        Set-Location "$($SiteCode):\" @initParams

        #endregion SCCM configuration

    }
    PROCESS
    {
        Foreach($Name in $CollectionName)
        {
            IF ($NULL -eq (Get-CMDevicecollection -Name $Name)) #Erroraction -Stop does not generate a terminating error for non existing collection names. Therefore I have to verify up front if the collection name exists.
            {
                Write-Error -Message "Collection with name '$name' could not be found"
                $Result.add([PSCUSTOMOBJECT][ORDERED]@{
                    'Collection'=$Name
                    'ErrorOccurred'=$TRUE
                    'RuleName' = "Error: Collection with name '$name' could not be found"
                    'ResourceID' = "Error: Collection with name '$name' could not be found"
                    'SmsProviderObjectPath' = "Error: Collection with name '$name' could not be found"
                    'ResourceClassName' = "Error: Collection with name '$name' could not be found"
                })
            }
            ELSE
            {
                TRY
                {
                    $DirectMembershipRules = Get-CMDeviceCollectionDirectMembershipRule -CollectionName $Name -ErrorAction Stop
                    Foreach($Rule in $DirectMembershipRules)
                    {
                        $Result.add([PSCUSTOMOBJECT][ORDERED]@{
                            'Collection'=$Name
                            'ErrorOccurred'=$False
                            'RuleName' = $Rule.RuleName
                            'ResourceID' = $Rule.ResourceID
                            'SmsProviderObjectPath' = $Rule.SmsProviderObjectPath
                            'ResourceClassName' = $rule.ResourceClassName
                        })
                    }
                }
                CATCH #The catch block currently (12-Jul-2019) will never trigger because non existing collection name does not generate a terminating error at this moment. Bug maybe ?? Instead I added input validation.
                {
                    $Result.add([PSCUSTOMOBJECT][ORDERED]@{
                        'Collection'=$Name
                        'ErrorOccurred'=$TRUE
                        'RuleName' = $_
                        'ResourceID' = $_
                        'SmsProviderObjectPath' = $_
                        'ResourceClassName' = $_
                    })
                }
                Finally
                {
                }
            }
        }
    }
    END
    {
        Set-Location $InitialLocation
        $Result
    }
}