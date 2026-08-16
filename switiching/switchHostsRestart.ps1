
$File = Get-Item C:\Windows\System32\drivers\etc\hosts
$Size = $file.Length
$SizeInKb = ($Size/1KB)

if ( $SizeInKb -gt 2) {
    copy C:\Windows\System32\drivers\etc\hosts C:\Windows\System32\drivers\etc\hosts.bak 
}
 
copy C:\Windows\System32\drivers\etc\hosts.orig C:\Windows\System32\drivers\etc\hosts
ipconfig /flushdns

shutdown.exe /r
