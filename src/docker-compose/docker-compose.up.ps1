param(
    [string[]] $OverrideFiles
)


$composeFiles = Get-ChildItem -Path . -Filter *.docker-compose.yaml -Recurse | ForEach-Object { $_.FullName }

$composeFileArgs = @()
$composeFileArgs += "-f"
$composeFileArgs += "docker-compose.yaml"

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

# Add additional docker-compose options
$composeFileArgs += "-p"
$composeFileArgs += "localenv"
$composeFileArgs += "--ansi"
$composeFileArgs += "never"
$composeFileArgs += "up"
$composeFileArgs += "-d"
$composeFileArgs += "--build"
$composeFileArgs += "--force-recreate"
$composeFileArgs += "--remove-orphans"

Start-Process -FilePath "docker-compose" -ArgumentList $composeFileArgs -NoNewWindow -Wait