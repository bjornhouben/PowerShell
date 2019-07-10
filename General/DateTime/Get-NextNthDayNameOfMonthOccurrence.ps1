Function Get-NextNthDayNameOfMonthOccurrence
{
    <#
.SYNOPSIS
Gets the next occurrence of the Nth day name. By example the next occurrence of the 2nd tuesday of a month.
.DESCRIPTION
Gets the next occurrence of the Nth day name. By example the next occurrence of the 2nd tuesday of a month. It uses Get-NthDayNameOfMonthInfo to determine it.
.PARAMETER DayName
Specify one or more day names (weekdays) for which you want to get the Nth occurrence. By example 'thursday' or 'saturday'.
.PARAMETER NthDayNameOfMonthOccurrence
Specify the NthDayNameOfMonthOccurrence for which you want to get the next occurrence. By example if you want the 2nd occurrence, enter 2. 
.PARAMETER ReferenceDate
Optionally specify a date to use as a reference date using a [DATETIME] input. If you don't specify a reference date, today's date will be used as the reference date.
This could be useful if you want to determine the next Nth day name (week day) occurrence from a past or future reference date.
.EXAMPLE
Get-NextNthDayNameOfMonthOccurrence -DayName 'Tuesday' -NthDayNameOccurrence 2 -ReferenceDate (Get-Date -Month 7 -day 8 -Year 2019) #Should return July 9th 2019 as NextNthDayNameOfMonthOccurrence, should return 1 as TotalDaysUntilNextNthDayNameOfMonthOccurrence

DayName                                       : Tuesday
NthDayNameOccurrence                          : 2
ReferenceDate                                 : 08/07/2019 00:00:00
NextNthDayNameOfMonthOccurrence               : 09/07/2019 00:00:00
TotalDaysUntilNextNthDayNameOfMonthOccurrence : 1

This command determines the next second tuesday after July 8th 2019.
.EXAMPLE
Get-NextNthDayNameOfMonthOccurrence -DayName 'Tuesday' -NthDayNameOccurrence 2 -ReferenceDate (Get-Date -Month 7 -day 9 -Year 2019) #Should return August 13th 2019 as NextNthDayNameOfMonthOccurrence, should return 35 as TotalDaysUntilNextNthDayNameOfMonthOccurrence

DayName                                       : Tuesday
NthDayNameOccurrence                          : 2
ReferenceDate                                 : 09/07/2019 00:00:00
NextNthDayNameOfMonthOccurrence               : 13/08/2019 00:00:00
TotalDaysUntilNextNthDayNameOfMonthOccurrence : 35

This command determines the next second tuesday after July 9th 2019.
.EXAMPLE
Get-NextNthDayNameOfMonthOccurrence -DayName 'Tuesday' -NthDayNameOccurrence 2 -ReferenceDate (Get-Date -Month 7 -day 10 -Year 2019) #Should return August 13th 2019 as NextNthDayNameOfMonthOccurrence, should return 34 as TotalDaysUntilNextNthDayNameOfMonthOccurrence

DayName                                       : Tuesday
NthDayNameOccurrence                          : 2
ReferenceDate                                 : 10/07/2019 00:00:00
NextNthDayNameOfMonthOccurrence               : 13/08/2019 00:00:00
TotalDaysUntilNextNthDayNameOfMonthOccurrence : 34

This command determines the next second tuesday after July 10th 2019.
.EXAMPLE
Get-NextNthDayNameOfMonthOccurrence -DayName 'Tuesday' -NthDayNameOccurrence 2 -ReferenceDate (Get-Date -Month 12 -day 24 -Year 2019) #Should return January 14th 2019 as NextNthDayNameOfMonthOccurrence, should return 21 as TotalDaysUntilNextNthDayNameOfMonthOccurrence

DayName                                       : Tuesday
NthDayNameOccurrence                          : 2
ReferenceDate                                 : 24/12/2019 00:00:00
NextNthDayNameOfMonthOccurrence               : 14/01/2020 00:00:00
TotalDaysUntilNextNthDayNameOfMonthOccurrence : 21

This command determines the next second tuesday after December 24th 2019.
.EXAMPLE
1..12 | Foreach-Object{Get-NextNthDayNameOfMonthOccurrence -DayName 'Tuesday' -NthDayNameOccurrence 2 -ReferenceDate (Get-Date -Day 1 -Month $_ -year 2019)} | Select-Object -ExpandProperty NextNthDayNameOfMonthOccurrence

Tuesday, 8 January 2019 22:30:19
Tuesday, 12 February 2019 22:30:19
Tuesday, 12 March 2019 22:30:19
Tuesday, 9 April 2019 22:30:19
Tuesday, 14 May 2019 22:30:19
Tuesday, 11 June 2019 22:30:19
Tuesday, 9 July 2019 22:30:19
Tuesday, 13 August 2019 22:30:19
Tuesday, 10 September 2019 22:30:19
Tuesday, 8 October 2019 22:30:19
Tuesday, 12 November 2019 22:30:19
Tuesday, 10 December 2019 22:30:19

This command determines all 2nd tuesdays of the month (patch tuesdays) in 2019.
.EXAMPLE
(Get-NextNthDayNameOfMonthOccurrence -DayName 'Tuesday' -NthDayNameOccurrence 2 -ReferenceDate (Get-Date -Month 5 -day 1 -Year 2019) | Select-Object -ExpandProperty NextNthDayNameOfMonthOccurrence).AddDays(2)

Thursday, 16 May 2019 00:00:00

This command determines the first thursday after the next second tuesday using July 1st 2019 as the reference date.
Beware: The thursday after the second tuesday of the month is not necessarily the second thursday of the month. By example in May 2019 the 2nd tuesday is May 14th, while the second thursday is May 9th.
.NOTES
ASSUMPTIONS :  \
USE CASE    :  In our environment the systems are placed in a SCCM collection for patching by Nth day name (weekday) occurrence. By first determining the SCCM agents that are not working correctly, then determining the SCCM patching collection it is in and then determining when it will be patched next (including the days until the next occurrence) we can determine the best order in which we need to fix SCCM agent issues.
               It is important that we minimize the number of systems that cannot be patched. The importance is stressed even more because we follow a DTAP (Dev, Test, Acc, Prod) patching cycle and not being able to patch a system in DTA could mean that we cannot / may not patch the corresponding next system. Or even worse, it could mean that the DTAP street is not followed and we patch a production system without first having patched the DTA equivalents. This could lead to a production failure that could have been prevented otherwise.
NAME        :  Get-NextNthDayNameOfMonthOccurrence
VERSION     :  1.0
LAST UPDATED:  2019-07-09
AUTHOR      :  Bjorn Houben (bjorn@bjornhouben.com)

  ****************************************************************
  * DO NOT USE IN A PRODUCTION ENVIRONMENT UNTIL YOU HAVE TESTED *
  * THOROUGHLY IN A LAB ENVIRONMENT. USE AT YOUR OWN RISK.  IF   *
  * YOU DO NOT UNDERSTAND WHAT THIS SCRIPT DOES OR HOW IT WORKS, *
  * DO NOT USE IT OUTSIDE OF A SECURE, TEST SETTING.             *
  ****************************************************************

.INPUTS
[STRING] for DayName
[INT] for NthDayNameOfMonthOccurrence
[DATETIME] for ReferenceDate

.OUTPUTS
[object]
#>
    [cmdletbinding()]
    Param(
        [Parameter(
            Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { $_ -in (Get-Culture).DateTimeFormat.DayNames })]
        [STRING]$DayName,

        [Parameter(
            Mandatory = $True)]
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, 5)]
        [INT]$NthDayNameOccurrence,

        [Parameter(
            Mandatory = $False,
            ValueFromPipeline = $True)]
        [ValidateNotNullOrEmpty()]
        [ValidateScript( { $NULL -ne (Get-Date $_) })] #Prevent input of dates that do not exist
        [DATETIME]$ReferenceDate
    )
    BEGIN
    {
        #If $ReferenceDate has been specified, use that as the reference date. If not, use the current datetime as referencedate
        IF ($ReferenceDate)
        {
            $CurrentDateTime = Get-Date -Date $ReferenceDate -hour 0 -Minute 0 -Second 0 -Millisecond 0
        }
        ELSE
        {
            $CurrentDateTime = Get-Date -Hour 0 -Minute 0 -Second 0 -Millisecond 0
        }

        #Get the current date time to extract the current month and year
        $CurrentDayNumber = $CurrentDateTime.Day
        $CurrentMonthNumber = $CurrentDateTime.Month
        $CurrentYear = $CurrentDateTime.Year
    }
    PROCESS
    {
        #Gets the Nth occurrence of the DayName (Weekday) in the currentmonth
        $NthDayNameOfMonth = Get-NthDayNameOfMonthInfo -MonthNumber $CurrentMonthNumber -Year $CurrentYear | Where-Object { ($_.DayName -eq $DayName) -and ($_.NthDayNameOccurrence -eq $NthDayNameOccurrence) }
        $Number = $NthDayNameOfMonth.DayNumber
        $MonthNumber = $CurrentMonthNumber
        $Year = $CurrentYear

        #If the day number has already passed this month, add a month because we want to get the next day number occurrence
        IF ($Number -gt $CurrentDayNumber)
        {
            $NextNthDayNameOfMonthOccurrence = $NthDayNameOfMonth | Select-Object -ExpandProperty DateTimeObject
        }
        ELSEIF ($Number -le $CurrentDayNumber) #If you try to determine the next day number occurrence on the same day number it will not return 0. If you want it to return 0, change it to -lt
        {
            IF ($MonthNumber -eq 12)
            {
                $MonthNumber = 1
                $Year++
            }
            ELSE
            {
                $MonthNumber++
            }
            $NextNthDayNameOfMonthOccurrence = Get-NthDayNameOfMonthInfo -MonthNumber $MonthNumber -Year $Year | Where-Object { ($_.DayName -eq $DayName) -and ($_.NthDayNameOccurrence -eq $NthDayNameOccurrence) } | Select-Object -ExpandProperty DateTimeObject

        }
        #Round the values
        $TotalDaysUntilNextNthDayNameOfMonthOccurrence = [math]::Round((($NextNthDayNameOfMonthOccurrence - $CurrentDateTime) | Select-Object -ExpandProperty TotalDays), 2)

        #Create the object to output and add it to $Output
        [PSCUSTOMOBJECT][ORDERED]@{
            'DayName'                                       = $DayName
            'NthDayNameOccurrence'                          = $NthDayNameOccurrence
            'ReferenceDate'                                 = $CurrentDateTime #Get-Date -date $CurrentDateTime -Format (Get-culture).DateTimeFormat.UniversalSortableDateTimePattern
            'NextNthDayNameOfMonthOccurrence'               = $NextNthDayNameOfMonthOccurrence #Get-Date -date $NextDayNumberOccurence -Format (Get-culture).DateTimeFormat.UniversalSortableDateTimePattern
            'TotalDaysUntilNextNthDayNameOfMonthOccurrence' = $TotalDaysUntilNextNthDayNameOfMonthOccurrence
        }
    }
    END
    {
        $Output
    }

}