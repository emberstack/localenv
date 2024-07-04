param(
    [Parameter(Position=0)]
    [ValidateSet("up", "down")]
    [string] $Command = "up",
    
    [Parameter(Position=1)]
    [Alias("f")]
    [string[]] $OverrideFiles,
    
    [Parameter(Position=2)]
    [string[]] $profiles = @("full"),
    
    [Alias("v")]
    [switch] $RemoveVolumes
)

$composeFileArgs = @()
$composeFileArgs += "compose"
$composeFileArgs += "-f"
$composeFileArgs += "docker-compose.yaml"

$composeFiles = Get-ChildItem -Path . -Filter *.docker-compose.yaml -Recurse | ForEach-Object { $_.FullName }
foreach ($file in $composeFiles) {
    $composeFileArgs += "-f"
    $composeFileArgs += "`"$file`""
}

if ($OverrideFiles) {
    foreach ($overrideFile in $OverrideFiles) {
        $composeFileArgs += "-f"
        $composeFileArgs += "`"$overrideFile`""
    }
}

# Add profiles
if ($profiles) {
    foreach ($profile in $profiles) {
        $composeFileArgs += "--profile"
        $composeFileArgs += $profile
    }
}

# Add common docker-compose options
$composeFileArgs += "--ansi"
$composeFileArgs += "never"

if ($Command -eq "down") {
    $composeFileArgs += "down"
    $composeFileArgs += "--remove-orphans"
    if ($RemoveVolumes) {
         $composeFileArgs += "--volumes"
    }
}
else {
    $composeFileArgs += "up"
    $composeFileArgs += "-d"
    $composeFileArgs += "--build"
    $composeFileArgs += "--force-recreate"
    $composeFileArgs += "--remove-orphans"
}

Start-Process -FilePath "docker" -ArgumentList $composeFileArgs -NoNewWindow -Wait
