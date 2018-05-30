$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

$Tests = Import-Csv -path "$here\Convert-IPCidrNotationToIpSubnetMaskNotation.Tests.Csv" -Delimiter ';'

Foreach ($Test in $Tests)
{
    Describe "Convert-IPCIDRNotationtoIPSubnetMaskNotation for $($Test.Input)" {
        $Result = Convert-IPCIDRNotationtoIPSubnetMaskNotation -IPCIDR $Test.Input
        It "IPCIDR result should be $($Test.ExpectedIpCIDR)" {
            $Result | Select-Object -ExpandProperty IPCIDR | Should -Be $($Test.ExpectedIpCIDR)
        }
        It "IPAddress result should be $($Test.ExpectedIPAddress)" {
            $Result | Select-Object -ExpandProperty IpAddress | Should -Be $($Test.ExpectedIPAddress)
        }
        It "SubNetMask result should be $($Test.ExpectedSubnetMask)" {
            $Result | Select-Object -ExpandProperty SubNetMask | Should -Be $($Test.ExpectedSubnetMask)
        }
        It "Ip and subnet mask result should be $($Test.ExpectedIpAndSubnetMask)" {
            $Result | Select-Object -ExpandProperty IpAndSubNetMask | Should -Be $($Test.ExpectedIpAndSubnetMask)
        }
    }
}