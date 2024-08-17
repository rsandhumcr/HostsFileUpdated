
$path_to_file = "download\hosts"
$url = "https://someonewhocares.org/hosts/hosts"
$copy_location = "C:\\Windows\\System32\\drivers\\etc\\"

Write-Host "Downloading from :" + $url

if (Test-Path $path_to_file){
    Write-Host "Updating older file."
    Write-Host "Older Hosts updated:"
    Select-String -Path $path_to_file -Pattern "# Last updated:"
    $filenameFormat ="hosts" + (Get-Date -Format "yyyy-MM-dd_hh_mm_ss") + ".txt"
    Rename-Item -Path $path_to_file -NewName $filenameFormat
}

Invoke-RestMethod $url -OutFile $path_to_file

Write-Host "Latest Hosts updated:"
Select-String -Path $path_to_file -Pattern "# Last updated:"
Copy-Item $path_to_file -Destination $copy_location