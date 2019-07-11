$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

<#My plan was to do something along the lines of:

#Create an export when the script is working correctly:
(Get-NthDayNameOfMonthInfo -MonthNumber 7 -Year 2019) | Export-CliXML -path $here\Get-NthDayNameOfMonthInfo_July2019_Export.xml -Depth 9999

#Test the script by comparing the export with the result of running the script:
(Get-NthDayNameOfMonthInfo -MonthNumber 7 -Year 2019)  | Should -Be (Import-CliXML -path $here\Get-NthDayNameOfMonthInfo_July2019_Export.xml)

#For some reason this is not working however :(
#>
<# Not working :(
Describe "Verify if the values for July 31st 2019 are correct " {
    It "does something useful2" {
        $Object = New-Object System.Collections.Generic.List[System.Object] #This method is quicker than creating an empty array using $Output = @() and then adding to it using += , for more info see: https://powershell.org/2013/09/powershell-performance-the-operator-and-when-to-avoid-it/
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=1; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[1]; NthDayNameOccurrence=1;DateTimeObject = (Get-Date -day 1 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=2; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[2]; NthDayNameOccurrence=1;DateTimeObject = (Get-Date -day 2 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=3; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[3]; NthDayNameOccurrence=1;DateTimeObject = (Get-Date -day 3 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=4; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[4]; NthDayNameOccurrence=1;DateTimeObject = (Get-Date -day 4 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=5; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[5]; NthDayNameOccurrence=1;DateTimeObject = (Get-Date -day 5 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=6; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[6]; NthDayNameOccurrence=1;DateTimeObject = (Get-Date -day 6 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=7; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[0]; NthDayNameOccurrence=1;DateTimeObject = (Get-Date -day 7 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=8; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[1]; NthDayNameOccurrence=2;DateTimeObject = (Get-Date -day 8 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=9; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[2]; NthDayNameOccurrence=2;DateTimeObject = (Get-Date -day 9 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=10; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[3]; NthDayNameOccurrence=2;DateTimeObject = (Get-Date -day 10 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=11; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[4]; NthDayNameOccurrence=2;DateTimeObject = (Get-Date -day 11 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=12; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[5]; NthDayNameOccurrence=2;DateTimeObject = (Get-Date -day 12 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=13; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[6]; NthDayNameOccurrence=2;DateTimeObject = (Get-Date -day 13 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=14; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[0]; NthDayNameOccurrence=2;DateTimeObject = (Get-Date -day 14 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=15; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[1]; NthDayNameOccurrence=3;DateTimeObject = (Get-Date -day 15 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=16; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[2]; NthDayNameOccurrence=3;DateTimeObject = (Get-Date -day 16 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=17; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[3]; NthDayNameOccurrence=3;DateTimeObject = (Get-Date -day 17 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=18; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[4]; NthDayNameOccurrence=3;DateTimeObject = (Get-Date -day 18 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=19; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[5]; NthDayNameOccurrence=3;DateTimeObject = (Get-Date -day 19 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=20; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[6]; NthDayNameOccurrence=3;DateTimeObject = (Get-Date -day 20 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=21; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[0]; NthDayNameOccurrence=3;DateTimeObject = (Get-Date -day 21 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=22; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[1]; NthDayNameOccurrence=4;DateTimeObject = (Get-Date -day 22 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=23; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[2]; NthDayNameOccurrence=4;DateTimeObject = (Get-Date -day 23 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=24; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[3]; NthDayNameOccurrence=4;DateTimeObject = (Get-Date -day 24 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=25; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[4]; NthDayNameOccurrence=4;DateTimeObject = (Get-Date -day 25 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=26; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[5]; NthDayNameOccurrence=4;DateTimeObject = (Get-Date -day 26 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=27; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[6]; NthDayNameOccurrence=4;DateTimeObject = (Get-Date -day 27 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=28; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[0]; NthDayNameOccurrence=4;DateTimeObject = (Get-Date -day 28 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=29; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[1]; NthDayNameOccurrence=5;DateTimeObject = (Get-Date -day 29 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=30; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[2]; NthDayNameOccurrence=5;DateTimeObject = (Get-Date -day 30 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object.add([PSCUSTOMOBJECT][ORDERED]@{Daynumber=31; MonthNumber=7; Year=2019; DayName=(Get-Culture).DateTimeFormat.DayNames[3]; NthDayNameOccurrence=5;DateTimeObject = (Get-Date -day 31 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)})
        $Object = $object.ToArray()
        (Get-NthDayNameOfMonthInfo -MonthNumber 7 -Year 2019) | Should -Be $Object
    }
}
#>

<# This is not working either
Describe "Verify if some values for July 2019 are correct " {
    $July2019NthDayNameOfMonthInfo = (Get-NthDayNameOfMonthInfo -MonthNumber 7 -Year 2019) | Select-Object -ExcludeProperty DateTimeObject
    $July2019NthDayNameOfMonthInfoReference = Import-Clixml -path $here\Get-NthDayNameOfMonthInfo_July2019_Export.xml | Select-Object -ExcludeProperty DateTimeObject
    1..31 | ForEach-Object {
        It "Verify if values for July 23nd 2019 are correct" {
        $July2019NthDayNameOfMonthInfo[$_] | Assert-Equivalent $July2019NthDayNameOfMonthInfoReference[$_]
        }
    } 
}
#>

Describe "Verify if some values for July 2019 are correct " {
    $July2019NthDayNameOfMonthInfo = (Get-NthDayNameOfMonthInfo -MonthNumber 7 -Year 2019)

    It "Verify if values for July 1st 2019 are correct" {
        $July1st2019 = $July2019NthDayNameOfMonthInfo | Where-Object{$_.DayNumber -eq 1}
        $July1st2019.DayName | Should -Be (Get-Culture).DateTimeFormat.DayNames[1]
        $July1st2019.Monthnumber | Should -Be 7
        $July1st2019.Daynumber | Should -Be 1
        $July1st2019.NthDayNameOccurrence | Should -be 1
        $July1st2019.DateTimeObject | Should -be (Get-Date -Day 1 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)
    }
        It "Verify if values for July 23nd 2019 are correct" {
        $July23rd2019 = $July2019NthDayNameOfMonthInfo | Where-Object{$_.DayNumber -eq 23}
        $July23rd2019.DayName | Should -Be (Get-Culture).DateTimeFormat.DayNames[2]
        $July23rd2019.Monthnumber | Should -Be 7
        $July23rd2019.Daynumber | Should -Be 23
        $July23rd2019.NthDayNameOccurrence | Should -be 4
        $July23rd2019.DateTimeObject | Should -be (Get-Date -Day 23 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)
    }
 
    It "Verify if values for July 31st 2019 are correct" {
        $July31st2019 = $July2019NthDayNameOfMonthInfo | Where-Object{$_.DayNumber -eq 31}
        $July31st2019.DayName | Should -Be (Get-Culture).DateTimeFormat.DayNames[3]
        $July31st2019.Monthnumber | Should -Be 7
        $July31st2019.Daynumber | Should -Be 31
        $July31st2019.NthDayNameOccurrence | Should -be 5
        $July31st2019.DateTimeObject | Should -be (Get-Date -Day 31 -Month 7 -Year 2019 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)
    }
}

Describe "Verify if some values for February 2020 are correct " {
    $February2020NthDayNameOfMonthInfo = (Get-NthDayNameOfMonthInfo -MonthNumber 2 -Year 2020)

    It "Verify if values for July 1st 2019 are correct" {
        $February1st2020 = $February2020NthDayNameOfMonthInfo | Where-Object{$_.DayNumber -eq 1}
        $February1st2020.DayName | Should -Be (Get-Culture).DateTimeFormat.DayNames[6]
        $February1st2020.Monthnumber | Should -Be 2
        $February1st2020.Daynumber | Should -Be 1
        $February1st2020.NthDayNameOccurrence | Should -be 1
        $February1st2020.DateTimeObject | Should -be (Get-Date -Day 1 -Month 2 -Year 2020 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)
    }
        It "Verify if values for February 23nd 2019 are correct" {
        $February23rd2020 = $February2020NthDayNameOfMonthInfo | Where-Object{$_.DayNumber -eq 23}
        $February23rd2020.DayName | Should -Be (Get-Culture).DateTimeFormat.DayNames[0]
        $February23rd2020.Monthnumber | Should -Be 2
        $February23rd2020.Daynumber | Should -Be 23
        $February23rd2020.NthDayNameOccurrence | Should -be 4
        $February23rd2020.DateTimeObject | Should -be (Get-Date -Day 23 -Month 2 -Year 2020 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)
    }
 
    It "Verify if values for February 29th 2019 are correct" {
        $February29th2020 = $February2020NthDayNameOfMonthInfo | Where-Object{$_.DayNumber -eq 29}
        $February29th2020.DayName | Should -Be (Get-Culture).DateTimeFormat.DayNames[6]
        $February29th2020.Monthnumber | Should -Be 2
        $February29th2020.Daynumber | Should -Be 29
        $February29th2020.NthDayNameOccurrence | Should -be 5
        $February29th2020.DateTimeObject | Should -be (Get-Date -Day 29 -Month 2 -Year 2020 -Hour 0 -Minute 0 -Second 0 -Millisecond 0)
    }
}