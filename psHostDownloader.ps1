
$option = '1hosts'

if ($option -eq 'someonewhocares')
{
    $path_to_file = "download\hosts"
    $path_to_file_temp = "download\hosts_temp"
    $url = "https://someonewhocares.org/hosts/hosts"
    $search_term = "# Last updated:"
}

if ($option -eq '1hosts')
{
    $path_to_file = "download2\hosts"
    $path_to_file_temp = "download2\hosts_temp"
    $url = "https://raw.githubusercontent.com/badmojr/1Hosts/master/Pro/hosts.win"
    $search_term = "# Last modified:"
}

$copy_location = "C:\\Windows\\System32\\drivers\\etc\\"
$old_version = 'No Current Version'
Write-Host "Downloading from :" $url

if (Test-Path $path_to_file){
    $old_version_line = Select-String -Path $path_to_file -Pattern $search_term | select-object Line -first 1
    $old_version = $old_version_line.Line
    Write-Host "Previous Version : "  $old_version
}

if (Test-Path $path_to_file_temp) {
    Remove-Item -Path $path_to_file_temp
}

Invoke-RestMethod $url -OutFile $path_to_file_temp

$new_version_line = Select-String -Path $path_to_file_temp -Pattern $search_term | select-object Line -first 1
$new_version = $new_version_line.Line
Write-Host "Current Version  : "  $new_version

if ($old_version -ne $new_version )
{
    $FileSize = (Get-Item -Path $path_to_file_temp).Length
    Write-host "Curent version size MB":($FileSize/1MB)
    if (Test-Path $path_to_file)
    {
        $filenameFormat ="hosts" + (Get-Date -Format "yyyy-MM-dd_hh_mm_ss") + ".txt"
        Rename-Item -Path $path_to_file -NewName $filenameFormat
    }
    Copy-Item $path_to_file_temp -Destination $path_to_file
    Copy-Item $path_to_file -Destination $copy_location
    Write-Host "*** Updated to "  $new_version -ForegroundColor DarkGreen 
} else 
{
    Write-Host "Same version, not updated " $new_version -ForegroundColor Yellow
}

if (Test-Path $path_to_file_temp) {
    Remove-Item -Path $path_to_file_temp
}

