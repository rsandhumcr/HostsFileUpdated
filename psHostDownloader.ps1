
$path_to_file = "download\hosts"
$path_to_file_temp = "download\hosts_temp"

$url = "https://someonewhocares.org/hosts/hosts"
$copy_location = "C:\\Windows\\System32\\drivers\\etc\\"

$old_version = ''
Write-Host "Downloading from :" $url

if (Test-Path $path_to_file){
    $old_version = Select-String -Path $path_to_file -Pattern "# Last updated:" | select-object Line -first 1
    Write-Host "Previous Version : "  $old_version.Line
}

if (Test-Path $path_to_file_temp) {
    Remove-Item -Path $path_to_file_temp
}

Invoke-RestMethod $url -OutFile $path_to_file_temp

$new_version = Select-String -Path $path_to_file_temp -Pattern "# Last updated:" | select-object Line -first 1
Write-Host "Current Version :"  $new_version.Line
if ($old_version.Line -ne $new_version.Line )
{
    $filenameFormat ="hosts" + (Get-Date -Format "yyyy-MM-dd_hh_mm_ss") + ".txt"
    Rename-Item -Path $path_to_file -NewName $filenameFormat
    Copy-Item $path_to_file_temp -Destination $path_to_file
    Copy-Item $path_to_file -Destination $copy_location
    Write-Host "Updated to "  $new_version.Line
} else 
{
    Write-Host "Same version, not updated "
}

if (Test-Path $path_to_file_temp) {
    Remove-Item -Path $path_to_file_temp
}

