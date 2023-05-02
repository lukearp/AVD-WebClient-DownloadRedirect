# Variables to Set #
$dest = "X:\"
$sourcePath = "$($env:USERPROFILE)\Downloads\WebClient"
$credUserName = "localadmin"
# End to Variables to Set #

$pw = $(Get-Content -Path "C:\Scripts\password.txt") | ConvertTo-SecureString
$cred = [pscredential]::new($credUserName,$pw)
$sourceDir = Get-Item -Path "$($sourcePath)"
$runLoop = $false
if($sourceDir -eq $null)
{
    $sourceDir = New-Item -Path "$($sourcePath)" -ItemType Directory
}
$destinationDir = Get-Item -Path $dest
if($destinationDir -eq $null)
{
    try {
        $drive = New-PSDrive -Name $dest.Split(":")[0] -PSProvider FileSystem -Root "\\tsclient\Remote Desktop Virtual Drive\Downloads" -Credential $cred -ErrorAction Stop
        $runLoop = $true
    }
    catch {
        break;
    }
}
while($runLoop)
{   
    $items = Get-ChildItem -Path $sourceDir.FullName
    foreach($item in $items)
    {
            try {
                Move-Item -Path $item.FullName -Destination $dest
            }
            catch {
            
            }
    }
    Start-Sleep -Seconds 5;
}