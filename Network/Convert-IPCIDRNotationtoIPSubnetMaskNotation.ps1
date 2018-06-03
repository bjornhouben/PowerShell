Function Convert-IPCIDRNotationtoIPSubnetMaskNotation
{
 <#
      .Synopsis
        Convert IP CIDR notation (192.168.2.1/24) to the correct IP Subnet Mask notation (192.168.2.1 255.255.255.0)
      .DESCRIPTION
        Convert IP CIDR notation (192.168.2.1/24) to the correct IP Subnet Mask notation (192.168.2.1 255.255.255.0)
      .PARAMETER IPCIDR
        Enter the IPCIDR as follows: 192.168.2.1/24
      .EXAMPLE
        Convert-IPCIDRNotationtoIPSubnetMaskNotation -IPCIDR '192.168.1.2/24' | Format-Table
        
        Description
    
        -----------
    
        Convert a single IP address with the IP CIDR notation to the IP SubnetMask notation and show all output.
      .EXAMPLE
        Convert-IPCIDRNotationtoIPSubnetMaskNotation -IPCIDR '192.168.1.2/24' | Select-Object IPandSubnetMask
        
        Description
    
        -----------
    
        Convert a single IP address with the IP CIDR notation to the IP SubnetMask notation and select only the IPandSubnetMask
      .EXAMPLE
        Convert-IPCIDRNotationtoIPSubnetMaskNotation -IPCIDR '192.168.1.2/24' -verbose
        
        Description
    
        -----------
    
        Convert a single IP address with the IP CIDR notation to the IP SubnetMask notation and show verbose output
      .EXAMPLE
        Convert-IPCIDRNotationtoIPSubnetMaskNotation -IPCIDR '192.168.1.2/24' -whatif
        
        Description
    
        -----------
    
        Simulate converting a single IP address with the IP CIDR notation to the IP SubnetMask notation without actually doing it.
      .EXAMPLE
        $SourceFile = 'C:\Temp\IPCIDRAddresses.txt'
        $TargetFile = 'C:\Temp\IPSubnetMaskAddresses.txt'
        $IPCIDRAddresses = Get-Content -path $SourceFile
        $IPCIDRAddresses | Convert-IPCIDRNotationtoIPSubnetMaskNotation | Select-Object IPandSubnetMask -ExpandProperty IPandSubnetMask | Out-File -FilePath $TargetFile -Force -append
        Invoke-Expression $TargetFile
        
        Description
    
        -----------
    
        Get IP addresses with the IP CIDR notation from a .txt file
        Convert it to the IP SubnetMask notation
        Select only the IPandSubnetMask
        Output the results to the output file
        Open the output file
      .EXAMPLE
        $SourceFile = 'C:\Temp\IPCIDRAddresses.txt'
        $IPCIDRAddresses = Get-Content -path $SourceFile
        $IPCIDRAddresses | Convert-IPCIDRNotationtoIPSubnetMaskNotation | Out-Gridview
        
        Description
    
        -----------
    
        Get IP addresses with the IP CIDR notation from a .txt file
        Convert it to the IP SubnetMask notation
        Show the results in Out-Gridview
      .EXAMPLE
        $SourceFile = 'C:\Temp\IPCIDRAddresses.txt'
        $IPCIDRAddresses = Get-Content -path $SourceFile
        $IPCIDRAddresses | Convert-IPCIDRNotationtoIPSubnetMaskNotation | Format-Table
        
        Description
    
        -----------
    
        Get IP addresses with the IP CIDR notation from a .txt file
        Convert it to the IP SubnetMask notation
        Show the results using Format-Table
      .EXAMPLE
        $SourceFile = 'C:\Temp\IPCIDRAddresses.txt'
        $TargetFile = 'C:\Temp\IPSubnetMaskAddresses.csv'
        $IPCIDRAddresses = Get-Content -path $SourceFile
        $IPCIDRAddresses | Convert-IPCIDRNotationtoIPSubnetMaskNotation | ConvertTo-Csv -NoTypeInformation | Out-File -FilePath $TargetFile -Force -append
        Invoke-Expression $TargetFile
        
        Description
    
        -----------
    
        Get IP addresses with the IP CIDR notation from a .txt file
        Convert it to the IP SubnetMask notation
        Output the results to the output file as csv
        Open the output file
      .EXAMPLE
        '192.168.2.1/24','172.16.1.1/16' | Convert-IPCIDRNotationtoIPSubnetMaskNotation | Format-Table
        Invoke-Expression $TargetFile
        
        Description
    
        -----------
    
        Manually enter two IP addresses in the IP CIDR notation, convert them to the IP SubnetMask notation and output the result using Format-Table.
      .EXAMPLE
        Convert-IPCIDRNotationtoIPSubnetMaskNotation -IPCIDR '192.168.2.1/24','172.16.1.1/16' | Format-Table
        Invoke-Expression $TargetFile
        
        Description
    
        -----------
    
        Manually enter two IP addresses in the IP CIDR notation, convert them to the IP SubnetMask notation and output the result using Format-Table.
      .NOTES
        there are no checks yet to verify if the IP address is possible and if the CIDR subnet mask are possible.
    #>
    [CmdletBinding(SupportsShouldProcess=$true)] #Provides advanced functionality. For more details see "What does PowerShell's [CmdletBinding()] Do?" : http://www.windowsitpro.com/blog/powershell-with-a-purpose-blog-36/windows-powershell/powershells-[cmdletbinding]-142114
    Param
    (
        #Defines the IPCIDR parameter
        [Parameter(Mandatory=$true, #Parameter is mandatory.
                   ValueFromPipeline=$True, #Allows pipeline input.
                   Position=0, #Allows function to be called without explicitly specifying parameters, but instead using positional parameters in the correct order
                   HelpMessage='Enter the Enter the IPCIDR as follows: "192.168.2.1/24"')] #Enter a help message to be shown when no parameter value is provided.
        [ValidateScript({$_ -match "^([1-9]?\d|1\d\d|2[0-4]\d|25[0-5])\.([1-9]?\d|1\d\d|2[0-4]\d|25[0-5])\.([1-9]?\d|1\d\d|2[0-4]\d|25[0-5])\.([1-9]?\d|1\d\d|2[0-4]\d|25[0-5])\/([0-9]|[12][0-9]|3[0-2])$"})]
        [ValidateNotNullOrEmpty()] #Validate the input is not NULL or empty
        [String[]]$IPCIDR #IPCIDR parameter is of the String array type and can contain multiple string.
    )

    BEGIN
    {
        $Output = @() #Create empty array to contain results
    }
    PROCESS
    {
        Foreach($entry in $IPCIDR) #Foreach is to handle pipeline input and multiple inputs
        {
            IF($entry -eq $NULL)
            {
            }
            ELSE
            {
                if ($pscmdlet.ShouldProcess("$entry", 'Convert IPCIDR notation to IP SubnetMask notation'))
                {
                    Write-Verbose -Message "Try splitting the IP and CIDR from the IPCIDR input for $entry"
                    $IP = $entry.split('/')[0]
                    $CIDR = $entry.split('/')[1]

                    $SubnetMask = switch ($CIDR) #Get the subnet mask belonging to the CIDR notation
                    { 
                        0   {'0.0.0.0'}
                        1   {'128.0.0.0'}
                        2   {'192.0.0.0'}
                        3   {'224.0.0.0'}
                        4   {'240.0.0.0'}
                        5   {'248.0.0.0'}
                        6   {'252.0.0.0'}
                        7   {'254.0.0.0'}
                        8	  {'255.0.0.0'}
                        9	  {'255.128.0.0'}
                        10	{'255.192.0.0'}
                        11	{'255.224.0.0'}
                        12	{'255.240.0.0'}
                        13	{'255.248.0.0'}
                        14	{'255.252.0.0'}
                        15	{'255.254.0.0'}
                        16	{'255.255.0.0'}
                        17	{'255.255.128.0'}
                        18	{'255.255.192.0'}
                        19	{'255.255.224.0'}
                        20	{'255.255.240.0'}
                        21	{'255.255.248.0'}
                        22	{'255.255.252.0'}
                        23	{'255.255.254.0'}
                        24	{'255.255.255.0'}
                        25	{'255.255.255.128'}
                        26	{'255.255.255.192'}
                        27	{'255.255.255.224'}
                        28	{'255.255.255.240'}
                        29	{'255.255.255.248'}
                        30	{'255.255.255.252'}
                        31	{'255.255.255.254'}
                        32	{'255.255.255.255'}
                    }
    
                    $result = [pscustomobject][ordered]@{ #construct the $result object
                        IPCIDR = $entry
                        IPAddress = $IP
                        CIDR = "/$CIDR"
                        SubnetMask = $SubnetMask
                        IPandSubnetMask = "$IP $SubnetMask"
                    }
                    Write-Verbose -Message "Converted $entry to $($Result.IPandSubnetMask)"

                    $Output += $Result #Add the result to the $output object
                }
            }
        }
    }
    END
    {
        $Output #Output result to pipeline
    }
}