<#
.Synopsis 
Sets the Personality Strings for PVS Devices if missing
.DESCRIPTION
Sets the Personality Strings for PVS Devices if missing. Run from PVS Server. Must have PVS PSnapIn
.PARAMETER PVSDevice
Requred string parameter. Device to set the personality string on. Script will check to ensure string is teh correct length and whether one exists already.
.PARAMETER PersonalityString
Optional string parameter. Value to set personality string to. If not set, script will create a string based on the device name.
.EXAMPLE
PS> set-pvsPersonalityString.ps1 -PVSDevice PVSERVER
Script will check of a personality string exists and add one if missing based on the PVSERVER name.
.EXAMPLE
PS> set-pvsPersonalityString.ps1 -PVSDevice PVSERVER -PersonalityString 'FFFFFFFFFFFFFFFFFFFFFFFFFFFFC992'
Script will check of a personality string exists and set FFFFFFFFFFFFFFFFFFFFFFFFFFFFC992 as the string if missing.
.Notes 
NAME: set-pvsPersonalityString.ps1
AUTHOR: Alain Assaf
LASTEDIT: 1/3/2018
VERSION: 1.02
CHANGE LOG - Version - When - What - Who
1.00 - 1/3/2018 -Initial script - Alain Assaf
1.01 - 1/3/2018 - Changed string to use hexidecimal characters - Alain Assaf
1.02 - 1/3/2018 - Added try/catch to load snapin. Removed requires - Alain Assaf
.Link 
https://www.linkedin.com/in/alainassaf/
http://wagthereal.com 
#> 
[cmdletbinding(SupportsShouldProcess = $True)]
param(
    [Parameter(Mandatory = $true)]
    [string]$PVSDevice,

    [Parameter(Mandatory = $false)]
    [string]$PersonalityString
)

If ( (Get-PSSnapin -Name Citrix.PVS.SnapIn -ErrorAction SilentlyContinue) -eq $null ) {
    Try {
        Add-PsSnapin Citrix.PVS.SnapIn
    }
    Catch {
        Write-Error "Unable to load the snapin"
        Write-Error $Error[1] 
        Exit 1
    }
}

$PVSDevice = $PVSDevice.ToUpper()
$Device = Get-PvsDevice -DeviceName $PVSDevice

if (!($Device)) {
    write-warning "Server $pvsDevice does not exist. Exiting script."
    Exit 1
}


$string = (Get-PvsDevicePersonality -DeviceName $pvsDevice | Select-Object -ExpandProperty DevicePersonality | Select-Object Value).Value

if ($string) {
    write-host "$pvsDevice has a Personality String"
    write-host "Current value = $string"
    $temp = $string.Length
    write-host "Current length = $temp"
    $answer = read-host "Do you wan to change it? (Y/N)"
    if (($answer -eq 'Y') -or ($answer -eq 'Yes') -or ($answer -eq 'YES')) {
        if ($PersonalityString.length -ne 32) {
            write-warning "Personality String is not 32 characters long (or missing). Script will create personality string"
            $nameLength = $PVSDevice.Length
            $subLength = (32 - $nameLength) - 1
            $newPersonalityString = ""
            for ($i = 0; $i -le $subLength; $i++) { $newPersonalityString = $newPersonalityString + "F" }
            #NOTE: ASSUMES CERTAIN NAMING CONVENTION FOR SERVERS. CHANGE BUT RESULTS HAVE TO BE HEXIDECIMAL - A-F 0-9
            if ($PVSDevice.Contains("CCXA")) {
                $tmpDevice = $PVSDevice.Replace("CCXA", "DCAA")
                $tmpDevice = $tmpDevice.Replace("V", "F")
            }
            elseif ($PVSDevice.Contains("PCXA")) {
                $tmpDevice = $PVSDevice.Replace("PCXA", "CCAA")
                $tmpDevice = $tmpDevice.Replace("V", "F")
            }
            else {
                Write-Warning "Please enter a personality string. Cannot auto-create one based on current servername. Exiting script"
                Exit 1
            }
            $newPersonalityString = $newPersonalityString + $tmpDevice
        }
        else {
            $newPersonalityString = $newPersonalityString
        }
        $o = Get-PvsDevicePersonality -Name $pvsDevice
        $o.Remove(0)
        $o.Add("hwid", $newPersonalityString)
        Set-PvsDevicePersonality $o
        write-host "$pvsDevice Personality String set to $newPersonalityString"
    }
}
else {
    if ($PersonalityString.length -ne 32) {
        write-warning "$PersonalityString is not 32 characters long. Script will create personality string"
        $nameLength = $PVSDevice.Length
        $subLength = (32 - $nameLength) - 1
        $newPersonalityString = ""
        for ($i = 0; $i -le $subLength; $i++) { $newPersonalityString = $newPersonalityString + "F" }
        if ($PVSDevice.Contains("CCXA")) {
            $tmpDevice = $PVSDevice.Replace("CCXA", "DCAA")
            $tmpDevice = $tmpDevice.Replace("V", "F")
        }
        elseif ($PVSDevice.Contains("PCXA")) {
            $tmpDevice = $PVSDevice.Replace("PCXA", "CCAA")
            $tmpDevice = $tmpDevice.Replace("V", "F")
        }
        else {
            Write-Warning "Please enter a personality string. Cannot auto-create one based on current servername. Exiting script"
            Exit 1
        }
        $newPersonalityString = $newPersonalityString + $tmpDevice
    }
    else {
        $newPersonalityString = $newPersonalityString
    }
    $o = Get-PvsDevicePersonality -Name $pvsDevice
    $o.Add("hwid", $newPersonalityString)
    Set-PvsDevicePersonality $o
    write-host "$pvsDevice Personality String set to $newPersonalityString"
}