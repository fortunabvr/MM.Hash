$Path = '.\Bin\MSFTserver\1'
$Uri = 'https://github.com/MSFTserver/ccminer.git'
$Build = "Linux-Clean"


if($CCDevices1 -ne ''){$Devices = $CCDevices1}
if($GPUDevices1 -ne ''){$Devices = $GPUDevices1}

$Name = (Get-Item $script:MyInvocation.MyCommand.Path).BaseName

#Algorithms:
#Lyra2z
#Bitcore
#Hmq1725
#Timetravel

$Commands = [PSCustomObject]@{

    "Lyra2z" = ''
    "Bitcore" = ''
    "Hmq1725" = ''
    "Timetravel" = ''
}

$Commands | Get-Member -MemberType NoteProperty | Select-Object -ExpandProperty Name | ForEach-Object {
 if($Algorithm -eq "$($Pools.(Get-Algorithm($_)).Algorithm)")
  {
    [PSCustomObject]@{
        Symbol = (Get-Algorithm($_))
        MinerName = "ccminer"
	    Type = "NVIDIA1"
        Path = $Path
        Devices = $Devices
        DeviceCall = "ccminer"
        Arguments = "-a $_ -o stratum+tcp://$($Pools.(Get-Algorithm($_)).Host):$($Pools.(Get-Algorithm($_)).Port) -b 0.0.0.0:4068 -u $($Pools.(Get-Algorithm($_)).User1) -p $($Pools.(Get-Algorithm($_)).Pass1) $($Commands.$_)"
        HashRates = [PSCustomObject]@{(Get-Algorithm($_)) = $Stats."$($Name)_$(Get-Algorithm($_))_HashRate".Day}
	    Selected = [PSCustomObject]@{(Get-Algorithm($_)) = ""}
	    Port = 4068
        API = "Ccminer"
        Wrap = $false
        URI = $Uri
        BUILD = $Build
        }
      }
   }

$Pools.PSObject.Properties.Value | Where-Object {$Commands."$($_.Algorithm)" -ne $null} | ForEach {
    if("$($_.Coin)" -eq "Yes")
    {
    [PSCustomObject]@{
        Symbol = $_.Symbol
     MinerName = "ccminer"
     Type = "NVIDIA1"
     Path = $Path
     Devices = $Devices
     DeviceCall = "ccminer"
     Arguments = "-a $($_.Algorithm) -o stratum+tcp://$($_.Host):$($_.Port) -b 0.0.0.0:4068 -u $($_.User1) -p $($_.Pass1) $($Commands.$($_.Algorithm))"
     HashRates = [PSCustomObject]@{$_.Symbol = $Stats."$($Name)_$($_.Symbol)_HashRate".Day}
     API = "Ccminer"
     Selected = [PSCustomObject]@{$($_.Algorithm) = ""}
     Port = 4068
     Wrap = $false
     URI = $Uri
     BUILD = $Build
     }
    }
   }
