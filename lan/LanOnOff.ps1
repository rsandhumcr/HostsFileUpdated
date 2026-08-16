$adapter = Get-NetAdapter -Name "Ethernet"


if($adapter.Status -eq "Up"){

Get-NetAdapter -Name Ethernet | Disable-NetAdapter

} elseif($adapter.Status -eq "Disabled"){

Get-NetAdapter -Name Ethernet | Enable-NetAdapter

}