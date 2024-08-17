
$path_to_file = "download\hosts"
$url = "https://someonewhocares.org/hosts/hosts"
$copy_location = "C:\\Windows\\System32\\drivers\\etc\\"
$old_version = ''
Write-Host "Downloading from :" + $url

if (Test-Path $path_to_file){
    Write-Host "Updating older file."
    Write-Host "Older Hosts updated:"

    $old_version = Select-String -Path $path_to_file -Pattern "# Last updated:" | select-object Line -first 1
    Write-Host "Old Version :" + $old_version.Line
    $filenameFormat ="hosts" + (Get-Date -Format "yyyy-MM-dd_hh_mm_ss") + ".txt"
    Rename-Item -Path $path_to_file -NewName $filenameFormat
}

Invoke-RestMethod $url -OutFile $path_to_file

Write-Host "Latest Hosts updated:"
$new_version = Select-String -Path $path_to_file -Pattern "# Last updated:" | select-object Line -first 1
Write-Host "New Version :" + $new_version.Line
if ($old_version.Line -ne $new_version.Line )
{
    Copy-Item $path_to_file -Destination $copy_location
} else 
{
    Write-Host "Same version"
}
