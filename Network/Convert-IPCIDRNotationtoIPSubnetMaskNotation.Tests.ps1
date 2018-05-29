$here = Split-Path -Parent $MyInvocation.MyCommand.Path
$sut = (Split-Path -Leaf $MyInvocation.MyCommand.Path) -replace '\.Tests\.', '.'
. "$here\$sut"

Describe "Convert-IPCIDRNotationtoIPSubnetMaskNotation" {
    $Result = Convert-IPCIDRNotationtoIPSubnetMaskNotation -IPCIDR '192.168.1.2/24'
    It "IPCIDR result should be 192.168.1.2/24" {
        $Result | Select-Object -ExpandProperty IPCIDR | Should -Be '192.168.1.2/24' 
    }
    It "IPAddress result should be 192.168.1.2" {
        $Result | Select-Object -ExpandProperty IpAddress | Should -Be '192.168.1.2'
    }
    It "SubNetMask result should be 255.255.255.0" {
        $Result | Select-Object -ExpandProperty SubNetMask | Should -Be '255.255.255.0'
    }
    It "Ip and subnet mask result should be 192.168.1.2 255.255.255.0" {
        $Result | Select-Object -ExpandProperty IpAndSubNetMask | Should -Be '192.168.1.2 255.255.255.0'
    }
}
