# get-pvsPersonalityStrings.ps1
Lists the Personality Strings for PVS Devices

#PS> get-help .\get-pvsPersonalityStrings.ps1 -full

NAME<br>
    C:\Codevault\github\pvsScripts\get-pvsPersonalityStrings.ps1

SYNOPSIS<br>
    Lists the Personality Strings for PVS Devices

SYNTAX<br>
    C:\Codevault\github\pvsScripts\get-pvsPersonalityStrings.ps1 [-Missing] [-RightSize] [-WhatIf] [-Confirm] [<CommonParameters>]

DESCRIPTION<br>
    Lists the Personality Strings for PVS Devices. Run from PVS Server. Must have PVS PSnapIn

PARAMETERS
    -Missing [<SwitchParameter>]
        Switch parameter. If present it will only list servers that are missing a personality string.

        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -RightSize [<SwitchParameter>]
        Switch  parameter. If present it will only list servers that have a personality string that is not 32 characters in lenght.

        Required?                    false
        Position?                    named
        Default value                False
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -WhatIf [<SwitchParameter>]

        Required?                    false
        Position?                    named
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    -Confirm [<SwitchParameter>]

        Required?                    false
        Position?                    named
        Default value
        Accept pipeline input?       false
        Accept wildcard characters?  false

    <CommonParameters>
        This cmdlet supports the common parameters: Verbose, Debug,
        ErrorAction, ErrorVariable, WarningAction, WarningVariable,
        OutBuffer, PipelineVariable, and OutVariable. For more information, see
        about_CommonParameters (http://go.microsoft.com/fwlink/?LinkID=113216).

NOTES


        NAME: get-pvsPersonalityStrings.ps1
        AUTHOR: Alain Assaf
        LASTEDIT: 1/3/2018
        VERSION: 1.03
        CHANGE LOG - Version - When - What - Who
        1.00 - 1/3/2018 -Initial script - Alain Assaf
        1.01 - 1/3/2018 - Fixed hwid string handleing - Alain Assaf
        1.02 - 1/3/2018 - Changed output to not use format table - Alain Assaf
        1.03 - 1/3/2018 - Added switches to list missing or wrong sized personality strings - Alain Assaf

    -------------------------- EXAMPLE 1 --------------------------
    PS>get-pvsPersonalityStrings.ps1

    Lists a table of PVS devices with personality strings.

    -------------------------- EXAMPLE 2 --------------------------
    PS>get-pvsPersonalityStrings.ps1 -Missing

    Lists a table of PVS devices with missing Personality strings.

    -------------------------- EXAMPLE 3 --------------------------
    PS>get-pvsPersonalityStrings.ps1 -RightSize

    Lists a table of PVS devices with Personality strings that are not 32 characters in length.

RELATED LINKS
    https://www.linkedin.com/in/alainassaf/
    http://wagthereal.com
    
# Legal and Licensing
The check-deedrive.ps1 script is licensed under the [MIT license][].

[MIT license]: LICENSE.md

# Want to connect?
* LinkedIn - https://www.linkedin.com/in/alainassaf
* Twitter - http://twitter.com/alainassaf
* Wag the Real - my blog - https://wagthereal.com
* Edgesightunderthehood - my other - blog https://edgesightunderthehood.com

# Help
I welcome any feedback, ideas or contributors.