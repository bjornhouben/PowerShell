$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe 'Test correctness of results using some test samples with reference dates'{
    It "Next occurrence of 2nd Tuesday a reference date of July 8th 2019 should result in TotalDaysUntilNextDayNumberOccurrence value of 1"{
        (Get-NextNthDayNameOfMonthOccurrence -DayName 'Tuesday' -NthDayNameOccurrence 2 -ReferenceDate (Get-Date -Month 7 -day 8 -Year 2019) | Select-Object -ExpandProperty TotalDaysUntilNextNthDayNameOfMonthOccurrence) | Should -Be 1
    }
    It "Next occurrence of 2nd Tuesday a reference date of July 8th 2019 should result in NextNthDayNameOfMonthOccurrence value of July 9th 2019"{
        (Get-NextNthDayNameOfMonthOccurrence -DayName 'Tuesday' -NthDayNameOccurrence 2 -ReferenceDate (Get-Date -Month 7 -day 8 -Year 2019) | Select-Object -ExpandProperty NextNthDayNameOfMonthOccurrence).ToShortDateString() | Should -Be (Get-Date -day 9 -Month 7 -Year 2019).ToShortDateString()
    }
    It "Next occurrence of 2nd Tuesday a reference date of July 9th 2019 should result in TotalDaysUntilNextDayNumberOccurrence value of 35"{
        (Get-NextNthDayNameOfMonthOccurrence -DayName 'Tuesday' -NthDayNameOccurrence 2 -ReferenceDate (Get-Date -Month 7 -day 9 -Year 2019) | Select-Object -ExpandProperty TotalDaysUntilNextNthDayNameOfMonthOccurrence) | Should -Be 35
    }
    It "Next occurrence of 2nd Tuesday a reference date of July 9th 2019 should result in NextNthDayNameOfMonthOccurrence value of August 13th 2019"{
        (Get-NextNthDayNameOfMonthOccurrence -DayName 'Tuesday' -NthDayNameOccurrence 2 -ReferenceDate (Get-Date -Month 7 -day 9 -Year 2019) | Select-Object -ExpandProperty NextNthDayNameOfMonthOccurrence).ToShortDateString() | Should -Be (Get-Date -day 13 -Month 8 -Year 2019).ToShortDateString()
    }
    It "Next occurrence of 2nd Tuesday a reference date of July 10th 2019 should result in TotalDaysUntilNextDayNumberOccurrence value of 34"{
        (Get-NextNthDayNameOfMonthOccurrence -DayName 'Tuesday' -NthDayNameOccurrence 2 -ReferenceDate (Get-Date -Month 7 -day 10 -Year 2019) | Select-Object -ExpandProperty TotalDaysUntilNextNthDayNameOfMonthOccurrence) | Should -Be 34
    }
    It "Next occurrence of 2nd Tuesday a reference date of July 10th 2019 should result in NextNthDayNameOfMonthOccurrence value of August 13th 2019"{
        (Get-NextNthDayNameOfMonthOccurrence -DayName 'Tuesday' -NthDayNameOccurrence 2 -ReferenceDate (Get-Date -Month 7 -day 10 -Year 2019) | Select-Object -ExpandProperty NextNthDayNameOfMonthOccurrence).ToShortDateString() | Should -Be (Get-Date -day 13 -Month 8 -Year 2019).ToShortDateString()
    }
    It "Next occurrence of 2nd Tuesday a reference date of December 24th 2019 should result in TotalDaysUntilNextDayNumberOccurrence value of 21"{
        (Get-NextNthDayNameOfMonthOccurrence -DayName 'Tuesday' -NthDayNameOccurrence 2 -ReferenceDate (Get-Date -Month 12 -day 24 -Year 2019) | Select-Object -ExpandProperty TotalDaysUntilNextNthDayNameOfMonthOccurrence) | Should -Be 21
    }
    It "Next occurrence of 2nd Tuesday a reference date of December 24th 2019 should result in NextNthDayNameOfMonthOccurrence value of January 14th 2020"{
        (Get-NextNthDayNameOfMonthOccurrence -DayName 'Tuesday' -NthDayNameOccurrence 2 -ReferenceDate (Get-Date -Month 12 -day 24 -Year 2019) | Select-Object -ExpandProperty NextNthDayNameOfMonthOccurrence).ToShortDateString() | Should -Be (Get-Date -day 14 -Month 1 -Year 2020).ToShortDateString()
    }
}

Describe 'Test correctness of result when not specifying a reference date'{
    $Dayname = (Get-Culture).DateTimeFormat.DayNames[6] #Saturday
    $Date = Get-Date
    $Month = $Date.Month 
    $Year = $Date.Year
    $Daynumber = $Date.Day
    It "Next occurrence of 2nd Saturday without specifying a reference date should result in the same value of TotalDaysUntilNextDayNumberOccurrence as when the reference date of today is specified"{
        (Get-NextNthDayNameOfMonthOccurrence -DayName $Dayname -NthDayNameOccurrence 2 | Select-Object -ExpandProperty TotalDaysUntilNextNthDayNameOfMonthOccurrence) | Should -Be (Get-NextNthDayNameOfMonthOccurrence -DayName $Dayname -NthDayNameOccurrence 2 -ReferenceDate (Get-Date -Month $Month -day $Daynumber -Year $Year) | Select-Object -ExpandProperty TotalDaysUntilNextNthDayNameOfMonthOccurrence)
    }
    It "Next occurrence of 2nd Saturday without specifying a reference date should result in the same value of NextNthDayNameOfMonthOccurrence as when the reference date of today is specified"{
        (Get-NextNthDayNameOfMonthOccurrence -DayName $Dayname -NthDayNameOccurrence 2 | Select-Object -ExpandProperty NextNthDayNameOfMonthOccurrence).ToShortDateString() | Should -Be (Get-NextNthDayNameOfMonthOccurrence -DayName $Dayname -NthDayNameOccurrence 2 -ReferenceDate (Get-Date -Month $Month -day $Daynumber -Year $Year) | Select-Object -ExpandProperty NextNthDayNameOfMonthOccurrence).ToShortDateString()
    }
}