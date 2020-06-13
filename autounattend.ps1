# Setup folders
New-Item “$env:SystemDrive\Install” -ItemType directory


# Download latest dotnet/codeformatter release from github
$repo = "blabley/AutoInstall"
$file = "AutoInstall.zip"
$releases = "https://api.github.com/repos/$repo/releases"

Write-Host Determining latest release
$tag = (Invoke-WebRequest $releases | ConvertFrom-Json)[0].tag_name

$download = "https://github.com/$repo/releases/download/$tag/$file"
$name = $file.Split(".")[0]
$zip = "$name-$tag.zip"
$dir = "$name-$tag"

Write-Host Dowloading latest release
Invoke-WebRequest $download -Out $zip

Write-Host Extracting release files
Expand-Archive $zip -Force

# Cleaning up target dir
Remove-Item $name -Recurse -Force -ErrorAction SilentlyContinue 

# Moving from temp dir to target dir
Move-Item $dir\$name -Destination $name -Force

# Removing temp files
Remove-Item $zip -Force
Remove-Item $dir -Recurse -Force

Start-Process $env:SystemDrive\Install\AutoInstall.cmd