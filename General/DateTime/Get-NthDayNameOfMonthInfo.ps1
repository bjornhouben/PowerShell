Function Get-NthDayNameOfMonthInfo
{
<#
.SYNOPSIS
Get an overview of all days in a month, its day name (weekday) and whether it's the 1st, 2nd, 3rd, 4th or 5th occurrence of that day name (weekday).
.DESCRIPTION
Get an overview of all days in a month, its day name (weekday) and whether it's the 1st, 2nd, 3rd, 4th or 5th occurrence of that day name (weekday).
This helps to easily determine by example the 2nd tuesday of the month (patch tuesday).
.PARAMETER MonthNumber
Specify a month number between 1 and 12 for which you want to get the info. If you don't specify a month, the current month will be chosen based on system date.
.PARAMETER Year
Specify a year between 1900 and 2199 for which you want to get the info. If you don't specify a year, the current year will be chosen based on system date.
.EXAMPLE
Get-NthDayNameOfMonthInfo | Format-Table

DayNumber MonthNumber Year   DayName NthDayNameOccurrence DateTimeObject     
--------- ----------- ----   ------- -------------------- --------------     
        1           7 2019    Monday                    1 01/07/2019 22:02:22
        2           7 2019   Tuesday                    1 02/07/2019 22:02:22
        3           7 2019 Wednesday                    1 03/07/2019 22:02:22
        4           7 2019  Thursday                    1 04/07/2019 22:02:22
        5           7 2019    Friday                    1 05/07/2019 22:02:22
        6           7 2019  Saturday                    1 06/07/2019 22:02:22
        7           7 2019    Sunday                    1 07/07/2019 22:02:22
        8           7 2019    Monday                    2 08/07/2019 22:02:22
        9           7 2019   Tuesday                    2 09/07/2019 22:02:22
       10           7 2019 Wednesday                    2 10/07/2019 22:02:22
       11           7 2019  Thursday                    2 11/07/2019 22:02:22
       12           7 2019    Friday                    2 12/07/2019 22:02:22
       13           7 2019  Saturday                    2 13/07/2019 22:02:22
       14           7 2019    Sunday                    2 14/07/2019 22:02:23
       15           7 2019    Monday                    3 15/07/2019 22:02:23
       16           7 2019   Tuesday                    3 16/07/2019 22:02:23
       17           7 2019 Wednesday                    3 17/07/2019 22:02:23
       18           7 2019  Thursday                    3 18/07/2019 22:02:23
       19           7 2019    Friday                    3 19/07/2019 22:02:23
       20           7 2019  Saturday                    3 20/07/2019 22:02:23
       21           7 2019    Sunday                    3 21/07/2019 22:02:23
       22           7 2019    Monday                    4 22/07/2019 22:02:23
       23           7 2019   Tuesday                    4 23/07/2019 22:02:23
       24           7 2019 Wednesday                    4 24/07/2019 22:02:23
       25           7 2019  Thursday                    4 25/07/2019 22:02:23
       26           7 2019    Friday                    4 26/07/2019 22:02:23
       27           7 2019  Saturday                    4 27/07/2019 22:02:23
       28           7 2019    Sunday                    4 28/07/2019 22:02:23
       29           7 2019    Monday                    5 29/07/2019 22:02:23
       30           7 2019   Tuesday                    5 30/07/2019 22:02:23
       31           7 2019 Wednesday                    5 31/07/2019 22:02:23

This command determines for all days in the current month and year (based on system date) which dayname (weekday) it is and which occurrence it is in that month.
By example July 15th 2019 is the 3rd monday in July 2019.
.EXAMPLE
Get-NthDayNameOfMonthInfo -Month 4 -Year 2019 | Format-Table

DayNumber MonthNumber Year   DayName NthDayNameOccurrence DateTimeObject     
--------- ----------- ----   ------- -------------------- --------------     
        1           4 2019    Monday                    1 01/04/2019 22:05:59
        2           4 2019   Tuesday                    1 02/04/2019 22:05:59
        3           4 2019 Wednesday                    1 03/04/2019 22:05:59
        4           4 2019  Thursday                    1 04/04/2019 22:05:59
        5           4 2019    Friday                    1 05/04/2019 22:05:59
        6           4 2019  Saturday                    1 06/04/2019 22:05:59
        7           4 2019    Sunday                    1 07/04/2019 22:05:59
        8           4 2019    Monday                    2 08/04/2019 22:05:59
        9           4 2019   Tuesday                    2 09/04/2019 22:05:59
       10           4 2019 Wednesday                    2 10/04/2019 22:05:59
       11           4 2019  Thursday                    2 11/04/2019 22:05:59
       12           4 2019    Friday                    2 12/04/2019 22:05:59
       13           4 2019  Saturday                    2 13/04/2019 22:05:59
       14           4 2019    Sunday                    2 14/04/2019 22:05:59
       15           4 2019    Monday                    3 15/04/2019 22:05:59
       16           4 2019   Tuesday                    3 16/04/2019 22:05:59
       17           4 2019 Wednesday                    3 17/04/2019 22:05:59
       18           4 2019  Thursday                    3 18/04/2019 22:05:59
       19           4 2019    Friday                    3 19/04/2019 22:05:59
       20           4 2019  Saturday                    3 20/04/2019 22:05:59
       21           4 2019    Sunday                    3 21/04/2019 22:05:59
       22           4 2019    Monday                    4 22/04/2019 22:05:59
       23           4 2019   Tuesday                    4 23/04/2019 22:05:59
       24           4 2019 Wednesday                    4 24/04/2019 22:05:59
       25           4 2019  Thursday                    4 25/04/2019 22:05:59
       26           4 2019    Friday                    4 26/04/2019 22:05:59
       27           4 2019  Saturday                    4 27/04/2019 22:05:59
       28           4 2019    Sunday                    4 28/04/2019 22:05:59
       29           4 2019    Monday                    5 29/04/2019 22:05:59
       30           4 2019   Tuesday                    5 30/04/2019 22:05:59

This command determines for all days in month 4 (April) of 2019 which dayname (weekday) it is and which occurrence it is in that month.
By example April 30th 2019 is the 5th tuesday in July 2019.
.EXAMPLE
Get-NthDayNameOfMonthInfo -MonthNumber 7 -Year 2019 | Where{($_.Dayname -eq 'Tuesday') -and $_.NthDayNameOccurrence -eq 2} | Select-Object -ExpandProperty DateTimeObject

This command determines the 2nd Tuesday in July 2019.
.EXAMPLE
(Get-NthDayNameOfMonthInfo -MonthNumber 7 -Year 2019 | Where{($_.Dayname -eq 'Tuesday') -and $_.NthDayNameOccurrence -eq 2} | Select-Object -ExpandProperty DateTimeObject).adddays(2)

This command determines the first thursday after the 2nd Tuesday in August 2019. 
NOTE: This is not necessarily the same as the 2nd thursday. By example in August 2019 that would actually be the third thursday.
.EXAMPLE
$July2019 = Get-NthDayNameOfMonthInfo -MonthNumber 7 -Year 2019

This command determines for all days in July 2019 which dayname (weekday) it is and which occurrence it is and stores it in a variable. Then this data can be used to extract data manually or as input for the function Get-NthDayNameOfMonth
.NOTES
ASSUMPTIONS :  \
USE CASE    :  When patching is planned by example every first thursday and saturday after the second tuesday you can easily determine and automate it using this script.
NAME        :  Get-NthDayNameOfMonth
VERSION     :  1.0
LAST UPDATED:  2019-07-06
AUTHOR      :  Bjorn Houben (bjorn@bjornhouben.com)

  ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************

.INPUTS
[INT] for MonthNumber
[INT] for Year

.OUTPUTS
[object]
#>
    [cmdletbinding()]
    Param(
        [Parameter(
            Mandatory=$False)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1,31)]
        [INT]$MonthNumber=(Get-Date).Month,

        [Parameter(
            Mandatory=$False)]
           [ValidateNotNullOrEmpty()]
        [ValidateRange(1900,2199)]
        [INT]$Year=(Get-Date).Year
    )
    BEGIN
    {
        $Output = New-Object System.Collections.Generic.List[System.Object] #This method is quicker than creating an empty array using $Output = @() and then adding to it using += , for more info see: https://powershell.org/2013/09/powershell-performance-the-operator-and-when-to-avoid-it/
        $DaysInCurrentMonth = [datetime]::DaysInMonth($Year,$MonthNumber)
    }
    PROCESS
    {
        1..$DaysInCurrentMonth | ForEach-Object{
            
            $DateTime = Get-Date -Day $_ -Month $MonthNumber -Year $Year -Hour 0 -Minute 0 -Second 0 -Millisecond 0
            #Create the object to output and add it to $Output
            $Output.Add([PSCUSTOMOBJECT][ORDERED]@{
                
                'DayNumber' = $_
                'MonthNumber' = $MonthNumber
                'Year' = $Year
                'DayName' = $($DateTime.DayOfWeek)
                'NthDayNameOccurrence' = ($Output | Where-Object{$_.DayName -eq $($DateTime.DayOfWeek)} | Measure-Object).count +1
                'DateTimeObject' = $DateTime
            })
        }
    }
    END
    {
        $Output
    }
}