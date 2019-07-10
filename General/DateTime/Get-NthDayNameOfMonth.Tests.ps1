$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Test for some samples if the values are as expected" {
    $Result = Get-NthDayNameOfMonth -NthDayNameOfMonthInfo (Get-NthDayNameOfMonthInfo -MonthNumber 7 -Year 2019) -DayName (Get-Culture).DateTimeFormat.DayNames[2],(Get-Culture).DateTimeFormat.DayNames[6] -NthDayNameOccurrence 3,4
    It "Result should contain 4 results" {
        ($Result | Measure-Object).Count | Should -be 4
    }
    It "Verify the values for July 16th 2019" {
        $ResultJuly16th2019 = $Result | Where-Object{$_.DayNumber -eq 16}
        $ResultJuly16th2019.DayName | Should -Be (Get-Culture).DateTimeFormat.DayNames[2]
        $ResultJuly16th2019.Monthnumber | Should -Be 7
        $ResultJuly16th2019.Daynumber | Should -Be 16
        $ResultJuly16th2019.NthDayNameOccurrence | Should -be 3
        $ResultJuly16th2019.DateTimeObject | Should -be (Get-Date -Day 16 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)
    }
    It "Verify the values for July 23rd 2019" {
        $ResultJuly23rd2019 = $Result | Where-Object{$_.DayNumber -eq 23}
        $ResultJuly23rd2019.DayName | Should -Be (Get-Culture).DateTimeFormat.DayNames[2]
        $ResultJuly23rd2019.Monthnumber | Should -Be 7
        $ResultJuly23rd2019.Daynumber | Should -Be 23
        $ResultJuly23rd2019.NthDayNameOccurrence | Should -be 4
        $ResultJuly23rd2019.DateTimeObject | Should -be (Get-Date -Day 23 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)
    }
    It "Verify the values for July 20th 2019" {
        $ResultJuly20th2019 = $Result | Where-Object{$_.DayNumber -eq 20}
        $ResultJuly20th2019.DayName | Should -Be (Get-Culture).DateTimeFormat.DayNames[6]
        $ResultJuly20th2019.Monthnumber | Should -Be 7
        $ResultJuly20th2019.Daynumber | Should -Be 20
        $ResultJuly20th2019.NthDayNameOccurrence | Should -be 3
        $ResultJuly20th2019.DateTimeObject | Should -be (Get-Date -Day 20 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)
    }
    It "Verify the values for July 27th 2019" {
        $ResultJuly27th2019 = $Result | Where-Object{$_.DayNumber -eq 27}
        $ResultJuly27th2019.DayName | Should -Be (Get-Culture).DateTimeFormat.DayNames[6]
        $ResultJuly27th2019.Monthnumber | Should -Be 7
        $ResultJuly27th2019.Daynumber | Should -Be 27
        $ResultJuly27th2019.NthDayNameOccurrence | Should -be 4
        $ResultJuly27th2019.DateTimeObject | Should -be (Get-Date -Day 27 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)
    }
}