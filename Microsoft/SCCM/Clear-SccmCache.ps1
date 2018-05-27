#$ComputerNames = Import-Csv -Path 'C:\Beheer\Scripts\Servers.csv' -Delimiter ',' 
$ComputerNames = Get-ADComputer -filter * -Properties OperatingSystem,LastLogonDate | Where{($_.OperatingSystem -match 'Server') -and ($_.LastLogonDate -ge (Get-Date).AddDays(-90))} | Select-Object -ExpandProperty Name

$Output=@()
Foreach($ComputerName in $ComputerNames)
{
    Write-Output "Started task to clear SCCM cache $Computername"
    $FreeSpaceInGBBefore = Invoke-Command -ComputerName $ComputerName -Scriptblock {[MATH]::Round(((Get-WmiObject win32_volume | Where{$_.Name -eq 'C:\'} | Select -ExpandProperty Freespace)/1GB),2)}
    $Scriptblock = { #Code to empty the SCCM Cache
        $UIResourceMgr = New-Object -ComObject UIResource.UIResourceMgr
        $Cache = $UIResourceMgr.GetCacheInfo()
        $Cache.GetCacheElements() <#| Where-Object{$_.LastReferenceTime -gt (Get-Date).adddays(-14)}#> | foreach {$Cache.DeleteCacheElement($_.CacheElementID)}
    }
    Invoke-Command -ComputerName $ComputerName -ScriptBlock $ScriptBlock -ErrorAction SilentlyContinue | Out-Null
    $FreeSpaceInGBAfter = Invoke-Command -ComputerName $ComputerName -Scriptblock {[MATH]::Round(((Get-WmiObject win32_volume | Where{$_.Name -eq 'C:\'} | Select -ExpandProperty Freespace)/1GB),2)}
    $Object=[PSCUSTOMOBJECT][ORDERED]@{
        'Computername' = $ComputerName
        'FreeSpaceInGBBefore' = $FreeSpaceInGBBefore
        'FreeSpaceInGBAfter' = $FreeSpaceInGBAfter
    }
    $Object
    $Output += $Object
    Write-Output "Stopped task to clear SCCM cache $Computername"
}
$Output