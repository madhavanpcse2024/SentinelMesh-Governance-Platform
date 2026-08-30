# PowerShell script to create a clean ZIP archive of the project

param (
    [string]$OutputFile = "SentinelMesh-Governance-Platform_Clean.zip",
    [switch]$IncludeMedia = $false
)

$rootDir = Get-Location
$outputPath = Join-Path $rootDir "..\$OutputFile"

if (Test-Path $outputPath) {
    Remove-Item $outputPath -Force
}

Write-Host "Creating clean zip file at: $outputPath"

Add-Type -AssemblyName System.IO.Compression.FileSystem
$zip = [System.IO.Compression.ZipFile]::Open($outputPath, 'Create')

$files = Get-ChildItem -Path . -Recurse -Force -ErrorAction SilentlyContinue | Where-Object {
    if ($_.PSIsContainer) { return $false }
    
    $relPath = $_.FullName.Substring($rootDir.Path.Length + 1)
    
    # Exclude dependency and build folders
    if ($relPath -match '^(node_modules|gcp\\sentinelmesh\\\.venv|gcp\\sentinelmesh\\__pycache__|artifacts\\[^\\]+\\dist|dist|\.pytest_cache|\.cache|\.git)') {
        return $false
    }
    
    # Optionally exclude heavy media binaries
    if (-not $IncludeMedia) {
        if ($_.Extension -in @('.mp4', '.zip', '.iso', '.tar', '.gz')) {
            return $false
        }
        if ($relPath -match 'demo_frames') {
            return $false
        }
    }
    
    return $true
}

$count = 0
foreach ($file in $files) {
    $relPath = $file.FullName.Substring($rootDir.Path.Length + 1)
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($zip, $file.FullName, $relPath, 'Optimal') | Out-Null
    $count++
}

$zip.Dispose()

$zipSizeMB = [math]::Round((Get-Item $outputPath).Length / 1MB, 2)
Write-Host "Done! Packaged $count files into '$OutputFile' ($zipSizeMB MB)."
