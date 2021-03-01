


Function Export-AdPhones{
<#
        .SYNOPSIS
        Helper function to export results of AD phone query.

        .DESCRIPTION
        Exports collection of objects as CSV.
        Defaults to $ENV:USERPROFILE\Desktop as path

        .PARAMETER outputFile
        Specifies the output file name and path.
        Defaults to "$ENV:USERPROFILE\Desktop\phone_list_yyyyMMdd.csv".

        .PARAMETER Objects
        Collection of objects to export. Presuming results come from Get-AdPhones cmdlet.
        
        .PARAMETER Properties
        Array of AD properties to include. 
        Default properties @("samAccountName","employeeId","ipPhone","givenName","surname","name","userPrincipalName","mail","department","extensionAttribute10")
        
        .PARAMETER sortBy
        Which property to sort on.
        Default sort is "IpPhone".

        .EXAMPLE
        PS> Export-AdPhones -objects:$adPhones
        Exported: 10
        File: 'C:\Users\sampleUser\Desktop\phone_list_20210301.csv'File.doc

        .LINK
        Online version: https://bitbucket.org/acelaya77/get-adphones

        .LINK
        Set-Item
    #>

    [CmdletBinding()]
    Param(
        [Parameter()][System.IO.FileInfo] $outFile,
        [Parameter(Mandatory)] $objects,
        [Parameter()] $properties,
        [Parameter()] $sortBy
    )
    Process{

        if ( [string]::IsNullOrEmpty($outFile) ) {
            [System.IO.FileInfo]$outFile = (Join-Path $env:userProfile\Desktop "phone_list_$(get-date -f 'yyyyMMdd').csv")
        }

        $count = $($objects | measure-Object).Count
        if ( $count -gt 0){
            if (Test-Path $outFile){
                Write-Verbose $("Overwriting file: {0}" -f $outFile)
            }
            $objects | select-Object $properties | sort-Object $sortBy | export-csv -nti -delimiter:"," $outFile
            Write-Verbose $("Exported: {0}`r`nFile: '{1}'" -f $count,$outFile )
        }else{
            Write-Verbose "No results"
        }

    }
}

Function Get-AdPhones {

<#
        .SYNOPSIS
        Obtain all AD users who have "ipPhone" assignments.

        .DESCRIPTION
        Collects and optionally exports collection of AD users who have "ipPhone" attribute from AD.

        .PARAMETER export
        Call helper function to export results. For more info:
        Get-Help Export-ADPhones 
        
        .PARAMETER Properties
        Array of AD properties to include. 
        Default properties @("samAccountName","employeeId","ipPhone","givenName","surname","name","userPrincipalName","mail","department","extensionAttribute10")
        
        .EXAMPLE
        PS> $phones = Get-AdPhones

        .EXAMPLE
        PS> $phones = Get-AdPhones -Export

        .LINK
        Online version: https://bitbucket.org/acelaya77/get-adphones

        .LINK
        Set-Item
    #>


    [Cmdletbinding()]
    Param(
        [Parameter()] [Switch] $Export,
        [Parameter()] $properties
    )

    Process{

    if ( ($properties | measure-Object).Count -lt 1){
        $properties = @(
            "samAccountName"
            "employeeId"
            "ipPhone"
            "givenName"
            "surname"
            "name"
            "userPrincipalName"
            "mail"
            "department"
            "extensionAttribute10"
        )
    }

    if (-not $properties -contains "ipPhone"){
        $properties += "ipPhone"
    }

    $splat = @{
        properties = [array]$properties
    }

    $adUsers = get-aduser -Filter:"ipPhone -like '*'" @splat | sort-Object ipPhone

    Switch ( $PSBoundParameters.ContainsKey("Export")){
        $true{
            Export-AdPhones -object:$adUsers -sortBy:"ipPhone" -properties:$Splat.properties -verbose
        }
        Default{}
    }

    $($adUsers | sort-Object ipPhone)

    }
}



#Get-AdPhones 

