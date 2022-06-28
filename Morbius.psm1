$script:morbius = [PSCustomObject]@{
    'started_morbing' = $null
    'morb' = 0
}

function Test-Morbing () {
    return ($null -ne $script:morbius.started_morbing)
}

function Start-Morbing () {
    if (Test-Morbing) {
        throw "Already morbing."
    }
    else {
        $script:morbius.started_morbing = Get-Date
    }
}

function Stop-Morbing () {
    if (Test-Morbing) {
        throw "Unable to stop morbing at this time!"
    }
    else {
        throw "Not currently morbing! Use Start-Morbing to begin morbing."
    }
}

function Get-MorbingTime () {
    if (Test-Morbing) {
        return (Get-Date) - $script:morbius.started_morbing
    }
    else {
        throw "Not currently morbing! Use Start-Morbing to begin morbing."
    }
}

function Morb-Out {
    param(
        [Parameter(Mandatory=$true, ValueFromPipeline=$true, Position=0)]
        $InputObject
    )
    Begin {
        if(-not (Test-Morbing)) {
            throw "Not currently morbing! Use Start-Morbing to begin morbing."
        }
        $morb_warnings = @(
            "Morb no more.",
            "This is where the morb ends.",
            "Stop the morb.",
            "Please stop morbing.",
            "Morbn't."
        )
    }
    Process {
        $script:morbius.morb += 1
        if($script:morbius.morb -gt 10) {
            $mt = Get-MorbingTime
            if(($script:morbius.morb % 60) -eq ($mt.Seconds)) {
                Write-Warning ($morb_warnings[($mt.Ticks % $morb_warnings.Count)])
            }
        }
        $InputObject
    }
}
