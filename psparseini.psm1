function ConvertFrom-IniFile {
    <#
        .SYNOPSIS
        Converts an INI file into a PowerShell hashtable.
        
        .DESCRIPTION
        Reads an INI file and returns the contents as a PowerShell hashtable. 
        
        .PARAMETER FilePath
        The full path to the INI file to be converted to a hashtable.
        
        .EXAMPLE
        $convertedHashtable = ConvertFrom-IniFile -FilePath '$env:appdata\app\config.ini'
        
        .NOTES
        Author: PowerPCFan
        Version: 1.0.1
    #>
    
    param (
        [Parameter(Mandatory)]
        [string]$FilePath
    )
    
    if (-not (Test-Path -Path $Path)) {
        throw "File not found: $Path"
    }
    
    $ini = @{}
    $currentSection = 'NO_SECTION'
    $ini[$currentSection] = @{}
    
    foreach ($line in Get-Content -Path $Path) {
        $trimmedLine = $line.Trim()
        
        # Skip empty lines and comments
        if ($trimmedLine -eq '' -or $trimmedLine -match '^[#;]') {
            continue
        }
        
        # Section header [SectionName]
        if ($trimmedLine -match '^\[(.+?)\]$') {
            $currentSection = $matches[1].Trim()
            if (-not $ini.ContainsKey($currentSection)) {
                $ini[$currentSection] = @{}
            }
            continue
        }
        
        # Key=value pair
        if ($trimmedLine -match '^(.*?)=(.*)$') {
            $key = $matches[1].Trim()
            $value = $matches[2].Trim()
            $ini[$currentSection][$key] = $value
        }
    }
    
    return $ini
}
