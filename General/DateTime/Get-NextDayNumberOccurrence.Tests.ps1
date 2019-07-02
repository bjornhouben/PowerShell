$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"


#Variables
$Year = (Get-Date).Year
$Months = 1..12
$LeapYear = 2020
$NonLeapYear = 2019

$DaysInMonths = Foreach($Month in $Months)
{
    [datetime]::DaysInMonth($Year,$Month) | Select-Object  @{label="Year";expression={$Year}},@{label='Month';expression={$Month}},@{label="DaysInMonth";expression={$_}}
}

Describe 'Test DayNumber validation for valid inputs 1-31'{
    1..31 | Foreach-Object{
        It "Valid DayNumber ($_) should not throw"{
            {Get-NextDayNumberOccurrence -DayNumber $_} | Should NOT THROW
        }
    }
}

Describe 'Test DayNumber validation for invalid inputs 0,-1,32,33'{
    @(-1,0,32,33) | Foreach-Object{
        It "Invalid DayNumber ($_) should throw"{
            {Get-NextDayNumberOccurrence -DayNumber $_} | Should THROW
        }
    }
}

Describe 'Test ReferenceDate Validation for valid inputs'{
    Foreach($Month in $Months)
    {
        $DaysInMonth = $DaysInMonths | Where-Object{$_.Month -eq $Month} | Select-Object -ExpandProperty DaysInMonth
        1..$DaysInMonth | Foreach-Object{
            It "Valid day number input ($_) should not throw in month ($Month)"{
                {Get-NextDayNumberOccurrence -DayNumber 1 -ReferenceDate Get-Date -date ((Get-Date -day $_ -Month $Month -Year $Year).ToString().Replace("$DaysInMonth","$DaysInMonthPlusOne"))} | Should THROW #Note: I tried getting max days in month and then adding 1 day but this didn't work as expected. By example if I would get max days of September (30) and added 1 so it would become 31, the result of (Get-Date -Day 31 -Month 9 -Year 2019) would be October 1st instead of an error.
            }
        }
    }
}

Describe 'Test ReferenceDate Validation for Invalid inputs'{
    Foreach($Month in $Months)
    {
        $DaysInMonth = $DaysInMonths | Where-Object{$_.Month -eq $Month} | Select-Object -ExpandProperty DaysInMonth
        $DaysInMonthPlusOne = $DaysInMonth+1
        It "Invalid day number input ($DaysInMonthPlusOne) should throw in month ($Month)"{
            {Get-NextDayNumberOccurrence -DayNumber 1 -ReferenceDate Get-Date -date ((Get-Date -day $DaysInMonth -Month $Month -Year $Year).ToString().Replace("$DaysInMonth","$DaysInMonthPlusOne"))} | Should THROW #Note: I tried getting max days in month and then adding 1 day but this didn't work as expected. By example if I would get max days of September (30) and added 1 so it would become 31, the result of (Get-Date -Day 31 -Month 9 -Year 2019) would be October 1st instead of an error.
        }
    }
}

Describe 'Test ReferenceDate Validation correct for February 29th in a leap year and a non leap year'{
    It "February 29th should not throw in a leap year ($LeapYear)"{
        {Get-NextDayNumberOccurrence -DayNumber 1 -ReferenceDate (Get-Date -day 29 -Month 2 -Year $LeapYear)} | Should NOT THROW
    }
    It "February 29th should throw in a non leap year ($NonLeapYear)"{
        {Get-NextDayNumberOccurrence -DayNumber 1 -ReferenceDate ((Get-Date -day 28 -Month 2 -Year $NonLeapYear).ToString().Replace("28","29"))} | Should THROW
    }
}

Describe 'Test correctness of results using some test samples'{
    It "Next occurrence of day number 31 with a reference date of January 1st 2019 should result in TotalDaysUntilNextDayNumberOccurrence value of 30"{
        Get-NextDayNumberOccurrence -DayNumber 31 -ReferenceDate (Get-Date -day 1 -Month 1 -Year 2019) | Select-Object -ExpandProperty TotalDaysUntilNextDayNumberOccurrence | Should -Be 30
    }
    It "Next occurrence of day number 31 with a reference date of January 1st 2019 should result in NextDayNumberOccurrence of January 31st 2019"{
        (Get-NextDayNumberOccurrence -DayNumber 31 -ReferenceDate (Get-Date -day 1 -Month 1 -Year 2019) | Select-Object -ExpandProperty NextDayNumberOccurrence).ToShortDateString() | Should -Be (Get-Date -day 31 -Month 1 -Year 2019).ToShortDateString()
    }
    It "Next occurrence of day number 31 with a reference date of February 1st 2019 should result in TotalDaysUntilNextDayNumberOccurrence value of 58"{
        Get-NextDayNumberOccurrence -DayNumber 31 -ReferenceDate (Get-Date -day 1 -Month 2 -Year 2019) | Select-Object -ExpandProperty TotalDaysUntilNextDayNumberOccurrence | Should -Be 58
    }
    It "Next occurrence of day number 31 with a reference date of February 1st 2019 should result in NextDayNumberOccurrence of March 31st 2019"{
        (Get-NextDayNumberOccurrence -DayNumber 31 -ReferenceDate (Get-Date -day 1 -Month 2 -Year 2019) | Select-Object -ExpandProperty NextDayNumberOccurrence).ToShortDateString() | Should -Be (Get-Date -day 31 -Month 3 -Year 2019).ToShortDateString()
    }
    It "Next occurrence of day number 31 with a reference date of May 31st 2019 should result in TotalDaysUntilNextDayNumberOccurrence value of 61"{
        Get-NextDayNumberOccurrence -DayNumber 31 -ReferenceDate (Get-Date -day 31 -Month 5 -Year 2019) | Select-Object -ExpandProperty TotalDaysUntilNextDayNumberOccurrence | Should -Be 61
    }
    It "Next occurrence of day number 31 with a reference date of May 31st 2019 should result in NextDayNumberOccurrence of July 31st 2019"{
        (Get-NextDayNumberOccurrence -DayNumber 31 -ReferenceDate (Get-Date -day 31 -Month 5 -Year 2019) | Select-Object -ExpandProperty NextDayNumberOccurrence).ToShortDateString() | Should -Be (Get-Date -day 31 -Month 7 -Year 2019).ToShortDateString()
    }
    It "Next occurrence of day number 1 with a reference date of December 31st 2018 should result in TotalDaysUntilNextDayNumberOccurrence value of 1"{
        Get-NextDayNumberOccurrence -DayNumber 1 -ReferenceDate (Get-Date -day 31 -Month 12 -Year 2018) | Select-Object -ExpandProperty TotalDaysUntilNextDayNumberOccurrence | Should -Be 1
    }
    It "Next occurrence of day number 1 with a reference date of December 31st 2018 should result in NextDayNumberOccurrence of January 1st 2019"{
        (Get-NextDayNumberOccurrence -DayNumber 1 -ReferenceDate (Get-Date -day 31 -Month 12 -Year 2018) | Select-Object -ExpandProperty NextDayNumberOccurrence).ToShortDateString() | Should -Be (Get-Date -day 1 -Month 1 -Year 2019).ToShortDateString()
    }
    It "Next occurrence of day number 1 with a reference date of December 31st 2019 should result in TotalDaysUntilNextDayNumberOccurrence value of 1"{
        Get-NextDayNumberOccurrence -DayNumber 1 -ReferenceDate (Get-Date -day 31 -Month 12 -Year 2019) | Select-Object -ExpandProperty TotalDaysUntilNextDayNumberOccurrence | Should -Be 1
    }
    It "Next occurrence of day number 1 with a reference date of December 31st 2019 should result in NextDayNumberOccurrence of January 1st 2020"{
        (Get-NextDayNumberOccurrence -DayNumber 1 -ReferenceDate (Get-Date -day 31 -Month 12 -Year 2019) | Select-Object -ExpandProperty NextDayNumberOccurrence).ToShortDateString() | Should -Be (Get-Date -day 1 -Month 1 -Year 2020).ToShortDateString()
    }
}