<#
.SYNOPSIS
Gathers netwrork interface information

.DESCRIPTION
This function outputs a system object that contains all interface details for the client

.PARAMETER InterfaceStatus
Check for only up or down

.PARAMETER AddressFamily
TCPIP version 4 or 6, default is both

.INPUTS
Parameters above

.OUTPUTS
None

.EXAMPLE
Get-NetworkInformation -Interfacestatus Up
#>
function Get-NetworkInformation {
    [CmdletBinding(DefaultParameterSetName = "Default")]
    [OutputType('System.Object[]')]
    param (
        [Parameter(Mandatory=$False)][ValidateSet("Up","Down")]
        [string]$InterfaceStatus,
        [Parameter(Mandatory=$False)][ValidateSet("IPv4","IPv6")]
        [string]$AddressFamily
    )
    begin{
        if ($AddressFamily) {
            if ($AddressFamily -eq "IPv4") {
                $AddrFam = "InterNetwork"
            }
            if ($AddressFamily -eq "IPv6") {
                $AddrFam = "InterNetworkV6"
            }
        }
    }
    process {
        [System.Collections.Arraylist]$PSObjectCollection = @()
        $interfaces = [System.Net.NetworkInformation.NetworkInterface]::GetAllNetworkInterfaces()
        $InterfacesToExplore = $interfaces
        if ($InterfaceStatus) {
            $InterfacesToExplore = $InterfacesToExplore | Where-Object {$_.OperationalStatus -eq $InterfaceStatus}
        }
        if ($AddressFamily) {
            $InterfacesToExplore = $InterfacesToExplore | Where-Object {$($_.GetIPProperties().UnicastAddresses | ForEach-Object {$_.Address.AddressFamily}) -contains $AddrFam}
        }
        foreach ($adapter in $InterfacesToExplore) {
            $ipprops = $adapter.GetIPProperties()
            $ippropsPropertyNames = $($ipprops | Get-Member -MemberType Property).Name
            if ($AddressFamily) {
                $UnicastAddressesToExplore = $ipprops.UnicastAddresses | Where-Object {$_.Address.AddressFamily -eq $AddrFam}
            }
            else {
                $UnicastAddressesToExplore = $ipprops.UnicastAddresses
            }
            foreach ($ip in $UnicastAddressesToExplore) {
                $FinalPSObject = [pscustomobject]@{}
                $adapterPropertyNames = $($adapter | Get-Member -MemberType Property).Name
                foreach ($adapterPropName in $adapterPropertyNames) {
                    $FinalPSObjectMemberCheck = $($FinalPSObject | Get-Member -MemberType NoteProperty).Name
                    if ($FinalPSObjectMemberCheck -notcontains $adapterPropName) {
                        $FinalPSObject | Add-Member -MemberType NoteProperty -Name $adapterPropName -Value $($adapter.$adapterPropName)
                    }
                }
                foreach ($ippropsPropName in $ippropsPropertyNames) {
                    $FinalPSObjectMemberCheck = $($FinalPSObject | Get-Member -MemberType NoteProperty).Name
                    if ($FinalPSObjectMemberCheck -notcontains $ippropsPropName -and
                        $ippropsPropName -ne "UnicastAddresses" -and $ippropsPropName -ne "MulticastAddresses") {
                        $FinalPSObject | Add-Member -MemberType NoteProperty -Name $ippropsPropName -Value $($ipprops.$ippropsPropName)
                    }
                }
                $ipUnicastPropertyNames = $($ip | Get-Member -MemberType Property).Name
                foreach ($UnicastPropName in $ipUnicastPropertyNames) {
                    $FinalPSObjectMemberCheck = $($FinalPSObject | Get-Member -MemberType NoteProperty).Name
                    if ($FinalPSObjectMemberCheck -notcontains $UnicastPropName) {
                        $FinalPSObject | Add-Member -MemberType NoteProperty -Name $UnicastPropName -Value $($ip.$UnicastPropName)
                    }
                }
                $null = $PSObjectCollection.Add($FinalPSObject)
            }
        }
    }
    end {
        return $PSObjectCollection
    }
}
New-Alias -Name ifconfig -Value Get-NetworkInformation