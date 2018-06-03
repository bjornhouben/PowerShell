$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Verify input validation working correctly" {
    It "Valid input (1.1.1.1/0) Should not throw" {
        {Convert-IPCIDRNotationtoIPSubnetMaskNotation -IPCIDR '1.1.1.1/0' | Should Not Throw}
    }
    It "Invalid formatting (1.1.1.1-0 instead of 1.1.1.1/0) should throw" {
        {Convert-IPCIDRNotationtoIPSubnetMaskNotation -IPCIDR '1.1.1.1-0' | Should Not Throw}
    }
    It "Invalid IP address (1.1.1.1.1) Should throw" {
        {Convert-IPCIDRNotationtoIPSubnetMaskNotation -IPCIDR '1.1.1.1.1/0' | Should Not Throw}
    }
    It "Invalid IP address (1.1.1.256) Should throw" {
        {Convert-IPCIDRNotationtoIPSubnetMaskNotation -IPCIDR '1.1.1.1.1/0' | Should Not Throw}
    }
    It "Invalid IP address (001.001.001.001) Should throw" {
        {Convert-IPCIDRNotationtoIPSubnetMaskNotation -IPCIDR '1.1.1.1.1/0' | Should Not Throw}
    }
    It "Invalid CIDR (/33) Should Throw" {
        {Convert-IPCIDRNotationtoIPSubnetMaskNotation -IPCIDR '1.1.1.1/33' | Should Throw}
    }
}

#region example using CSV for performing tests
$Tests = Import-Csv -path "$here\Convert-IPCidrNotationToIpSubnetMaskNotation.Tests.Csv" -Delimiter ';'
Foreach ($Test in $Tests) #Determine for your own situation if you should use a foreach or Pester test cases 
{
    Describe "Convert-IPCIDRNotationtoIPSubnetMaskNotation for $($Test.Input)" {
        $Result = Convert-IPCIDRNotationtoIPSubnetMaskNotation -IPCIDR $Test.Input
        It "IPCIDR result should be $($Test.ExpectedIpCIDR)" {
            $Result.IPCIDR | Should -Be $($Test.ExpectedIpCIDR)
        }
        It "IPAddress result should be $($Test.ExpectedIPAddress)" {
            $Result.IpAddress | Should -Be $($Test.ExpectedIPAddress)
        }
        It "SubNetMask result should be $($Test.ExpectedSubnetMask)" {
            $Result.SubNetMask | Should -Be $($Test.ExpectedSubnetMask)
        }
        It "Ip and subnet mask result should be $($Test.ExpectedIpAndSubnetMask)" {
            $Result.IpAndSubNetMask | Should -Be $($Test.ExpectedIpAndSubnetMask)
        }
    }
}
#endregion example using CSV for performing tests

#region example using testcases for performing tests

#I personally prefer the output from the CSV example and that I run the function only once per input. But from what I understood using testcases is better when the results of the tests are used by other applications like NUnit
#When trying to convert the CSV based test to a test cases test I ran into the issue that the CSV column was initially called input and that I tried to use $input which is an automatic variable. For more info see: https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_automatic_variables

Describe "Verify if output from Convert-IPCIDRNotationtoIPSubnetMaskNotation is correct" {
    $TestCases = @(
        @{InputValue = '192.168.1.1/0'; ExpectedIPCIDR = '192.168.1.1/0'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '0.0.0.0'; ExpectedIpAndSubnetMask = '192.168.1.1 0.0.0.0'}
        @{InputValue = '192.168.1.1/1'; ExpectedIPCIDR = '192.168.1.1/1'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '128.0.0.0'; ExpectedIpAndSubnetMask = '192.168.1.1 128.0.0.0'}
        @{InputValue = '192.168.1.1/2'; ExpectedIPCIDR = '192.168.1.1/2'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '192.0.0.0'; ExpectedIpAndSubnetMask = '192.168.1.1 192.0.0.0'}
        @{InputValue = '192.168.1.1/3'; ExpectedIPCIDR = '192.168.1.1/3'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '224.0.0.0'; ExpectedIpAndSubnetMask = '192.168.1.1 224.0.0.0'}
        @{InputValue = '192.168.1.1/4'; ExpectedIPCIDR = '192.168.1.1/4'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '240.0.0.0'; ExpectedIpAndSubnetMask = '192.168.1.1 240.0.0.0'}
        @{InputValue = '192.168.1.1/5'; ExpectedIPCIDR = '192.168.1.1/5'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '248.0.0.0'; ExpectedIpAndSubnetMask = '192.168.1.1 248.0.0.0'}
        @{InputValue = '192.168.1.1/6'; ExpectedIPCIDR = '192.168.1.1/6'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '252.0.0.0'; ExpectedIpAndSubnetMask = '192.168.1.1 252.0.0.0'}
        @{InputValue = '192.168.1.1/7'; ExpectedIPCIDR = '192.168.1.1/7'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '254.0.0.0'; ExpectedIpAndSubnetMask = '192.168.1.1 254.0.0.0'}
        @{InputValue = '192.168.1.1/8'; ExpectedIPCIDR = '192.168.1.1/8'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.0.0.0'; ExpectedIpAndSubnetMask = '192.168.1.1 255.0.0.0'}
        @{InputValue = '192.168.1.1/9'; ExpectedIPCIDR = '192.168.1.1/9'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.128.0.0'; ExpectedIpAndSubnetMask = '192.168.1.1 255.128.0.0'}
        @{InputValue = '192.168.1.1/10'; ExpectedIPCIDR = '192.168.1.1/10'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.192.0.0'; ExpectedIpAndSubnetMask = '192.168.1.1 255.192.0.0'}
        @{InputValue = '192.168.1.1/11'; ExpectedIPCIDR = '192.168.1.1/11'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.224.0.0'; ExpectedIpAndSubnetMask = '192.168.1.1 255.224.0.0'}
        @{InputValue = '192.168.1.1/12'; ExpectedIPCIDR = '192.168.1.1/12'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.240.0.0'; ExpectedIpAndSubnetMask = '192.168.1.1 255.240.0.0'}
        @{InputValue = '192.168.1.1/13'; ExpectedIPCIDR = '192.168.1.1/13'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.248.0.0'; ExpectedIpAndSubnetMask = '192.168.1.1 255.248.0.0'}
        @{InputValue = '192.168.1.1/14'; ExpectedIPCIDR = '192.168.1.1/14'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.252.0.0'; ExpectedIpAndSubnetMask = '192.168.1.1 255.252.0.0'}
        @{InputValue = '192.168.1.1/15'; ExpectedIPCIDR = '192.168.1.1/15'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.254.0.0'; ExpectedIpAndSubnetMask = '192.168.1.1 255.254.0.0'}
        @{InputValue = '192.168.1.1/16'; ExpectedIPCIDR = '192.168.1.1/16'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.255.0.0'; ExpectedIpAndSubnetMask = '192.168.1.1 255.255.0.0'}
        @{InputValue = '192.168.1.1/17'; ExpectedIPCIDR = '192.168.1.1/17'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.255.128.0'; ExpectedIpAndSubnetMask = '192.168.1.1 255.255.128.0'}
        @{InputValue = '192.168.1.1/18'; ExpectedIPCIDR = '192.168.1.1/18'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.255.192.0'; ExpectedIpAndSubnetMask = '192.168.1.1 255.255.192.0'}
        @{InputValue = '192.168.1.1/19'; ExpectedIPCIDR = '192.168.1.1/19'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.255.224.0'; ExpectedIpAndSubnetMask = '192.168.1.1 255.255.224.0'}
        @{InputValue = '192.168.1.1/20'; ExpectedIPCIDR = '192.168.1.1/20'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.255.240.0'; ExpectedIpAndSubnetMask = '192.168.1.1 255.255.240.0'}
        @{InputValue = '192.168.1.1/21'; ExpectedIPCIDR = '192.168.1.1/21'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.255.248.0'; ExpectedIpAndSubnetMask = '192.168.1.1 255.255.248.0'}
        @{InputValue = '192.168.1.1/22'; ExpectedIPCIDR = '192.168.1.1/22'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.255.252.0'; ExpectedIpAndSubnetMask = '192.168.1.1 255.255.252.0'}
        @{InputValue = '192.168.1.1/23'; ExpectedIPCIDR = '192.168.1.1/23'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.255.254.0'; ExpectedIpAndSubnetMask = '192.168.1.1 255.255.254.0'}
        @{InputValue = '192.168.1.1/24'; ExpectedIPCIDR = '192.168.1.1/24'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.255.255.0'; ExpectedIpAndSubnetMask = '192.168.1.1 255.255.255.0'}
        @{InputValue = '192.168.1.1/25'; ExpectedIPCIDR = '192.168.1.1/25'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.255.255.128'; ExpectedIpAndSubnetMask = '192.168.1.1 255.255.255.128'}
        @{InputValue = '192.168.1.1/26'; ExpectedIPCIDR = '192.168.1.1/26'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.255.255.192'; ExpectedIpAndSubnetMask = '192.168.1.1 255.255.255.192'}
        @{InputValue = '192.168.1.1/27'; ExpectedIPCIDR = '192.168.1.1/27'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.255.255.224'; ExpectedIpAndSubnetMask = '192.168.1.1 255.255.255.224'}
        @{InputValue = '192.168.1.1/28'; ExpectedIPCIDR = '192.168.1.1/28'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.255.255.240'; ExpectedIpAndSubnetMask = '192.168.1.1 255.255.255.240'}
        @{InputValue = '192.168.1.1/29'; ExpectedIPCIDR = '192.168.1.1/29'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.255.255.248'; ExpectedIpAndSubnetMask = '192.168.1.1 255.255.255.248'}
        @{InputValue = '192.168.1.1/30'; ExpectedIPCIDR = '192.168.1.1/30'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.255.255.252'; ExpectedIpAndSubnetMask = '192.168.1.1 255.255.255.252'}
        @{InputValue = '192.168.1.1/31'; ExpectedIPCIDR = '192.168.1.1/31'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.255.255.254'; ExpectedIpAndSubnetMask = '192.168.1.1 255.255.255.254'}
        @{InputValue = '192.168.1.1/32'; ExpectedIPCIDR = '192.168.1.1/32'; ExpectedIpAddress = '192.168.1.1'; ExpectedSubnetMask = '255.255.255.255'; ExpectedIpAndSubnetMask = '192.168.1.1 255.255.255.255'}
        )

    It "IPCIDR result for input <inputvalue> should be <ExpectedIPCIDR>" -TestCases $TestCases {
        param($InputValue, $ExpectedIpCIDR, $ExpectedIpAddress, $ExpectedSubnetMask, $ExpectedIpAndSubnetMask)
        (Convert-IPCIDRNotationtoIPSubnetMaskNotation -IPCIDR $InputValue).IPCIDR | Should -Be $ExpectedIpCIDR
    }
    It "IPAddress result for input <inputvalue> should be <ExpectedIpAddress>" -TestCases $TestCases {
        param($InputValue, $ExpectedIpCIDR, $ExpectedIpAddress, $ExpectedSubnetMask, $ExpectedIpAndSubnetMask)
        (Convert-IPCIDRNotationtoIPSubnetMaskNotation -IPCIDR $InputValue).IpAddress | Should -Be $ExpectedIpAddress
    }
    It "SubNetMask result for input <inputvalue> should be <ExpectedSubnetMask>" -TestCases $TestCases {
        param($InputValue, $ExpectedIpCIDR, $ExpectedIpAddress, $ExpectedSubnetMask, $ExpectedIpAndSubnetMask)
        (Convert-IPCIDRNotationtoIPSubnetMaskNotation -IPCIDR $InputValue).SubnetMask | Should -Be $ExpectedSubnetMask
    }
    It "Ip and subnet mask result for input <inputvalue> should be <ExpectedIpAndSubnetMask>" -TestCases $TestCases {
        param($InputValue, $ExpectedIpCIDR, $ExpectedIpAddress, $ExpectedSubnetMask, $ExpectedIpAndSubnetMask)
        (Convert-IPCIDRNotationtoIPSubnetMaskNotation -IPCIDR $InputValue).IpAndSubnetMask | Should -Be $ExpectedIpAndSubnetMask
    }
}
#endregion example using testcases for performing tests
