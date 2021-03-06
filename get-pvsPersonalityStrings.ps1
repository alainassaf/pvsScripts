<# 
.Synopsis 
Lists the Personality Strings for PVS Devices
.DESCRIPTION
Lists the Personality Strings for PVS Devices. Run from PVS Server. Must have PVS PSnapIn
.PARAMETER Missing
Switch parameter. If present it will only list servers that are missing a personality string.
.PARAMETER RightSize
Switch  parameter. If present it will only list servers that have a personality string that is not 32 characters in lenght.
.EXAMPLE
PS> get-pvsPersonalityStrings.ps1
Lists a table of PVS devices with personality strings.
.EXAMPLE
PS> get-pvsPersonalityStrings.ps1 -Missing
Lists a table of PVS devices with missing Personality strings.
.EXAMPLE
PS> get-pvsPersonalityStrings.ps1 -RightSize
Lists a table of PVS devices with Personality strings that are not 32 characters in length.
.Notes 
NAME: get-pvsPersonalityStrings.ps1
AUTHOR: Alain Assaf
LASTEDIT: 1/3/2018
VERSION: 1.03
CHANGE LOG - Version - When - What - Who
1.00 - 1/3/2018 -Initial script - Alain Assaf
1.01 - 1/3/2018 - Fixed hwid string handleing - Alain Assaf
1.02 - 1/3/2018 - Changed output to not use format table - Alain Assaf
1.03 - 1/3/2018 - Added switches to list missing or wrong sized personality strings - Alain Assaf
.Link 
https://www.linkedin.com/in/alainassaf/
http://wagthereal.com 
#> 
[cmdletbinding(SupportsShouldProcess = $True)]
param(
    [Parameter(Mandatory = $false)]
    [switch]$Missing,

    [Parameter(Mandatory = $false)]
    [switch]$RightSize
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

#Add-PSSnapin Citrix.PVS.SnapIn

$pvsdevices = Get-PvsDevice | Select-Object devicename

#Initialize array
$finalout = @()
$MissingString = @()
$RigthSizeString = @()

foreach ($device in $pvsdevices) {
    $personalityTable = new-object System.Object
    $string = (Get-PvsDevicePersonality -DeviceName $device.DeviceName | Select-Object -ExpandProperty DevicePersonality | Select-Object Value).Value
    if (($string.Length -ne 32) -and ($RightSize)) {
        $personalityTable | Add-Member NoteProperty 'Server' $device.DeviceName
        $personalityTable | Add-Member NoteProperty 'PersonalityString' $string
        $personalityTable | Add-Member NoteProperty 'String Size' $string.Length
        $RigthSizeString += $personalityTable
    }
    elseif (($string -eq $null) -and ($Missing)) {
        $personalityTable | Add-Member NoteProperty 'Server' $device.DeviceName
        $MissingString += $personalityTable
    }
    else {
        $personalityTable | Add-Member NoteProperty 'Server' $device.DeviceName
        $personalityTable | Add-Member NoteProperty 'PersonalityString' $string
        $finalout += $personalityTable
    }
    
}

#$finalout | ft -AutoSize

if ($RightSize) {
    write-host "Incorrect Personality String Length" -ForegroundColor RED
    $RigthSizeString
}
elseif ($Missing) {
    write-host "Missing Personality String" -ForegroundColor RED
    $MissingString
}
else {
    write-host "All PVS Devices" -ForegroundColor RED
    $finalout
}