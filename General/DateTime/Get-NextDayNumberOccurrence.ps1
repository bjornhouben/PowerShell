Function Get-NextDayNumberOccurrence
{
<#
.SYNOPSIS
Gets the next occurrence of a day number.
.DESCRIPTION
Gets the next occurrence of a day number. The number of days in a month differs (also with leap years) and the next occurrence also depends on the date from which you want to determine the next day number occurrence. By example if you run it on January 1st 2019 and want to determine the next occurrence of the day number 31 it will return January 31st. When you run it on February 1st and want to determine the next occurrence of the day number 31 it will return March 31st 2019.
.PARAMETER DayNumber
Specify a day number between 1 and 31 for which you want to determine the next day number occurrence.
.PARAMETER ReferenceDate
Optionally specify a date to use as a reference date using a [DATETIME] input. If you don't specify a reference date, today's date will be used as the reference date.
This could be useful if you want to determine the next day number occurrence from a past or future reference date. By example to test if it works correctly for leap year.
.EXAMPLE
Get-NextDayNumberOccurrence -DayNumber 31

DayNumber ReferenceDate       NextDayNumberOccurrence TotalDaysUntilNextDayNumberOccurrence
--------- -------------       ----------------------- -------------------------------------
       31 01/07/2019 16:01:14 31/07/2019 16:01:14                                        30

This command determines when day number 31 will occur next after the current date when it was run (in this example July 1st 2019).
.EXAMPLE
Get-NextDayNumberOccurrence -DayNumber 24,29,30,31 | Sort-Object DaysUntilNextDayNumberOccurrence

DayNumber ReferenceDate       NextDayNumberOccurrence TotalDaysUntilNextDayNumberOccurrence
--------- -------------       ----------------------- -------------------------------------
       24 01/07/2019 16:17:51 24/07/2019 16:17:51                                        23
       29 01/07/2019 16:17:51 29/07/2019 16:17:51                                        28
       30 01/07/2019 16:17:51 30/07/2019 16:17:51                                        29
       31 01/07/2019 16:17:51 31/07/2019 16:17:51                                        30

This command determines when day number 24,29,30 and 31 will occur next after the current date when it was run (in this example July 1st 2019).
.EXAMPLE
Get-NextDayNumberOccurrence -DayNumber 1 -ReferenceDate (Get-Date -day 31 -Month 12 -Year 2019)

DayNumber ReferenceDate       NextDayNumberOccurrence TotalDaysUntilNextDayNumberOccurrence
--------- -------------       ----------------------- -------------------------------------
        1 31/12/2019 15:43:51 01/01/2020 15:43:51                                         1

This command determines when day number 1 will occur next after Decmber 31st 2019.
.EXAMPLE
Get-NextDayNumberOccurrence -DayNumber 31 -ReferenceDate (Get-Date -day 1 -Month 1 -Year 2019)

DayNumber ReferenceDate       NextDayNumberOccurrence TotalDaysUntilNextDayNumberOccurrence
--------- -------------       ----------------------- -------------------------------------
       31 01/01/2019 15:36:29 31/01/2019 15:36:29                                        30

This command determines when day number 31 will occur next after January 1st 2019.
.EXAMPLE
Get-NextDayNumberOccurrence -DayNumber 31 -ReferenceDate (Get-Date -day 1 -Month 2 -Year 2019)

DayNumber ReferenceDate       NextDayNumberOccurrence TotalDaysUntilNextDayNumberOccurrence
--------- -------------       ----------------------- -------------------------------------
       31 01/02/2019 15:40:11 31/03/2019 15:40:11                                        58

This command determines when day number 31 will occur next after February 1st 2019.
.EXAMPLE
Get-NextDayNumberOccurrence -DayNumber 31 -ReferenceDate (Get-Date -day 31 -Month 5 -Year 2019)

DayNumber ReferenceDate       NextDayNumberOccurrence TotalDaysUntilNextDayNumberOccurrence
--------- -------------       ----------------------- -------------------------------------
       31 31/05/2019 15:42:52 31/07/2019 15:42:52                                        61

This command determines when day number 31 will occur next after May 31st 2019.
.EXAMPLE
Get-NextDayNumberOccurrence -DayNumber 1 -ReferenceDate (Get-Date -day 31 -Month 12 -Year 2019)

DayNumber ReferenceDate       NextDayNumberOccurrence TotalDaysUntilNextDayNumberOccurrence
--------- -------------       ----------------------- -------------------------------------
        1 31/12/2019 15:43:51 01/01/2020 15:43:51                                         1

This command determines when day number 1 will occur next after December 31st 2019.
.EXAMPLE
$DaysUntilNextDayNumberOccurrence = 1..31 | Foreach{Get-NextDayNumberOccurrence -DayNumber $_} | Sort-Object TotalDaysUntilNextDayNumberOccurrence

$DaysUntilNextDayNumberOccurrence | Where{$_.DayNumber -eq 31} | Select-Object -ExpandProperty TotalDaysUntilNextDayNumberOccurrence
30
$DaysUntilNextDayNumberOccurrence | Where{$_.DayNumber -eq 30} | Select-Object -ExpandProperty TotalDaysUntilNextDayNumberOccurrence
29
$DaysUntilNextDayNumberOccurrence | Where{$_.DayNumber -eq 29} | Select-Object -ExpandProperty TotalDaysUntilNextDayNumberOccurrence
28

These commands determines when day number 1 to 31 will occur next after the current date when it was run (in this case July 1st 2019), store it in a variable.
Then the results are gathered and you can get the results from the variable (in memory) instead of having to re-run the function every time. This can be useful if you lookup the same next day number occurrence many times.
.NOTES
ASSUMPTIONS :  \
USE CASE    :  In our environment the systems are placed in a SCCM collection for patching by day number (the SCCM collections are numbered from 1 to 31). By first determining the SCCM agents that are not working correctly, then determining the SCCM patching collection it is in (based number) and then determining when it will be patched next (including the days until the next occurrence) we can determine the best order in which we need to fix SCCM agent issues.
               It is important that we minimize the number of systems that cannot be patched. The importance is stressed even more because we follow a DTAP (Dev, Test, Acc, Prod) patching cycle and not being able to patch a system in DTA could mean that we cannot / may not patch the corresponding next system. Or even worse, it could mean that the DTAP street is not followed and we patch a production system without first having patched the DTA equivalents. This could lead to a production failure that could have been prevented otherwise.
NAME        :  Get-NextDayNumberOccurrence
VERSION     :  1.0
LAST UPDATED:  2019-07-01
AUTHOR      :  Bjorn Houben (bjorn@bjornhouben.com)

  ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************

.INPUTS
[INT] for DayNumber
[DATETIME] for ReferenceDate

.OUTPUTS
[object]
#>
    [cmdletbinding()]
    Param(
        [Parameter(
            Mandatory=$True,
            ValueFromPipeline=$True)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1,31)]
        [INT[]]$DayNumber,

        [Parameter(
            Mandatory=$False,
            ValueFromPipeline=$True)]
           [ValidateNotNullOrEmpty()]
           [ValidateScript({$NULL -ne (Get-Date $_)})] #Prevent input of dates that do not exist
        [DATETIME]$ReferenceDate
    )
    BEGIN
    {
        #Create empty output variable to hold future output
        $Output = New-Object System.Collections.Generic.List[System.Object] #This method is quicker than creating an empty array using $Output = @() and then adding to it using += , for more info see: https://powershell.org/2013/09/powershell-performance-the-operator-and-when-to-avoid-it/

        #If $ReferenceDate has been specified, use that as the reference date. If not, use the current datetime as referencedate
        IF($ReferenceDate)
        {
            $CurrentDateTime = $ReferenceDate
        }
        ELSE
        {
            $CurrentDateTime = Get-Date
        }

        #Get the current date time to extract the current month and year
        $CurrentDayNumber = $CurrentDateTime.Day
        $CurrentMonthNumber = $CurrentDateTime.Month
        $CurrentYear = $CurrentDateTime.Year

        #Determine the number of days in the current month
        $DaysInCurrentMonth = [datetime]::DaysInMonth($CurrentYear,$CurrentMonthNumber)
    }
    PROCESS
    {
        Foreach($Number in $DayNumber)
        {
            #New variables are created with the initial values to which months (and years) will be added if applicable.
            #These new variables are necessary because otherwise you get incorrect values when looking up multiple values.
            $DaysInMonth = $DaysInCurrentMonth
            $MonthNumber = $CurrentMonthNumber
            $Year = $CurrentYear

            #If the day number has already passed this month, add a month because we want to get the next day number occurrence
            IF($Number -le $CurrentDayNumber) #If you try to determine the next day number occurrence on the same day number it will not return 0. If you want it to return 0, change it to -lt
            {
                IF($MonthNumber -eq 12)
                {
                    $MonthNumber = 1
                    $Year++
                }
                ELSE
                {
                    $MonthNumber++
                }
            }

            #Determine the days in the month
            $DaysInMonth = [datetime]::DaysInMonth($Year,$MonthNumber)

            #Keep adding months until you find the next month that contains the day number
            WHILE($Number -gt $DaysInMonth)
            {
                $MonthNumber++ #Before I also had a check to see if the month was 12 and than add a year, but since December consists of 31 days, $Number can never be greater than $DaysInMonth
                $DaysInMonth = [datetime]::DaysInMonth($Year,$MonthNumber) #Update the value of $DaysInMonth
            }

            #Create a datetime output for the found next daynumber occurrence
            $NextDayNumberOccurence = Get-Date -day $Number -Month $MonthNumber -Year $Year

            #Round the values
            $TotalDaysUntilNextDayNumberOccurrence = [math]::Round((($NextDayNumberOccurence - $CurrentDateTime) | Select-Object -ExpandProperty TotalDays),2)
            #$TotalHoursUntilNextDayNumberOccurrence = [math]::Round((($NextDayNumberOccurence - $CurrentDateTime) | Select-Object -ExpandProperty TotalHours),0)

            #Create the object to output and add it to $Output
            $Output.Add([PSCUSTOMOBJECT][ORDERED]@{
                'DayNumber' = $Number
                'ReferenceDate' = $CurrentDateTime #Get-Date -date $CurrentDateTime -Format (Get-culture).DateTimeFormat.UniversalSortableDateTimePattern
                #'MonthNumber' = $MonthNumber
                #'Year' = $Year
                'NextDayNumberOccurrence' = $NextDayNumberOccurence #Get-Date -date $NextDayNumberOccurence -Format (Get-culture).DateTimeFormat.UniversalSortableDateTimePattern
                'TotalDaysUntilNextDayNumberOccurrence' = $TotalDaysUntilNextDayNumberOccurrence
                #'TotalHoursUntilNextDayNumberOccurrence' = $TotalHoursUntilNextDayNumberOccurrence
            })
        }
    }
    END
    {
        $Output
    }
}