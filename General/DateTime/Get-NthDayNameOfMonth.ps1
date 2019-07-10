Function Get-NthDayNameOfMonth #add pester tests
{
<#
.SYNOPSIS
Get from an overview of all months days one or more specific occurrences of that day name (weekday). By example the 2nd Tuesday of the month.
.DESCRIPTION
Get from an overview of all months days one or more specific occurrences of that day name (weekday). By example the 2nd Tuesday of the month.
The advantage of this function over Get-NthDayNameOfMonthInfo is that the data is gathered once and re-used which is especially useful when doing many lookups.
.PARAMETER NthDayNameOfMonthInfo
Specify the PowerShell object to use as input. This should be created using Get-NthDayNameOfMonthInfo
.PARAMETER DayName
Specify one or more day names (weekdays) for which you want to get the Nth occurrence. By example 'thursday' or 'saturday'.
.PARAMETER NthDayNameOfMonthOccurrence
Specify one or more occurrences of the specified day name(s) / week day(s) for which you want to get the info. By example if you want the 2nd occurrence, enter 2. 
.EXAMPLE
$July2019 = Get-NthDayNameOfMonthInfo -MonthNumber 7 -Year 2019
Get-NthDayNameOfMonth -NthDayNameOfMonthInfo $July2019 -DayName 'Thursday','Saturday' -NthDayNameOccurrence 2,3 | Sort-Object DayName,NthDayNameOccurrence | Format-Table

This command determines for all days in July 2019 which day name (weekday) it is and which occurrence it is and stores it in a variable. 
Then this data is used to extract the 2nd and 3rd Thursday and Saturday of that month.
.EXAMPLE
Get-NthDayNameOfMonthInfo -MonthNumber 7 -Year 2019 | Get-NthDayNameOfMonth -DayName 'Thursday','Saturday' -NthDayNameOccurrence 2,3 | Format-Table | Sort-Object DayName,NthDayNameOccurrence

This command determines for all days in July 2019 which day name (weekday) it is and which occurrence it is.
The result is then piped into Get-NthDayNameOfMonth to extract the 2nd and 3rd Thursday and Saturday of that month.
.EXAMPLE
Get-NthDayNameOfMonth -NthDayNameOfMonthInfo (Get-NthDayNameOfMonthInfo -MonthNumber 7 -Year 2019) -DayName 'Thursday','Saturday' -NthDayNameOccurrence 2,3 | Sort-Object DayName,NthDayNameOccurrence | Format-Table 

This command determines for all days in July 2019 which day name (weekday) it is and which occurrence it is.
The result is used as input for the NthDayNameOfMonthInfo variable of Get-NthDayNameOfMonth to extract the 2nd and 3rd Thursday and Saturday of that month.

.NOTES
ASSUMPTIONS :  \
USE CASE    :  For each system the patching is scheduled every month in either the thursday after the 2nd tuesday of the month or the saturday after the 2nd tuesday of the month. This needs to be translated into the exact dates they will be patched each month.
NAME        :  Get-NthDayNameOfMonth
VERSION     :  1.0
LAST UPDATED:  2019-07-08
AUTHOR      :  Bjorn Houben (bjorn@bjornhouben.com)

  ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************

.INPUTS
[OBJECT] for NthDayNameOfMonthInfo
[STRING[]] for DayName
[INT[]] for NthDayNameOccurrence

.OUTPUTS
[object]
#>
    [cmdletbinding()]
    Param(
        [Parameter(
            Mandatory=$True,
            ValueFromPipeline = $true)]
        [ValidateNotNullOrEmpty()]
        [OBJECT]$NthDayNameOfMonthInfo,

        [Parameter(
            Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript({$_ -in (Get-Culture).DateTimeFormat.DayNames})]
        [STRING[]]$DayName,

        [Parameter(
            Mandatory=$True)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1,5)]
        [INT[]]$NthDayNameOccurrence        
    )
    BEGIN
    {
        $Output = New-Object System.Collections.Generic.List[System.Object] #This method is quicker than creating an empty array using $Output = @() and then adding to it using += , for more info see: https://powershell.org/2013/09/powershell-performance-the-operator-and-when-to-avoid-it/
    }
    PROCESS
    {
        Foreach($Day in $DayName)
        {
            Foreach($Occurrence in $NthDayNameOccurrence)
            {
                $Output.add(($NthDayNameOfMonthInfo | Where-Object {($_.DayName -eq $Day) -and ($_.NthDayNameOccurrence -eq $Occurrence)}))
            }
        }
    }
    END
    {
        $Output
    }
}