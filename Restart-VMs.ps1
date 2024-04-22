param(
    [string]$vCenterServer,
    [string]$vCenterUser,
    [string]$vCenterPass
)

# Ignore invalid or self-signed SSL certificates
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope User

# Connect to the vCenter Server using the provided credentials
Connect-VIServer -Server $vCenterServer -User $vCenterUser -Password $vCenterPass

# List of VMs to restart
$vmList = @(
    "284-01", "284-02", "284-03", "284-04", "284-05", "284-06", "284-07", "284-08", "284-09", "284-10",
    "284-11", "284-12", "284-13", "284-14", "284-15", "284-16", "284-17", "386-00", "386-01", "358-01",
    "babbam2-225", "brunsojc-225", "chengrl-225", "dayam-225", "flohreh-225", "gartnea-225", "grimesdl-225", 
    "henderbl-225", "hendris3-225", "hunterds-225", "lehmanjb-225", "mccurdca-225", "mosinsmj-225", "nyamusjj-225",
    "rain-225", "roseaw-225", "sandlizh-225", "singleb-225", "tanl4-225", "taylo271-225", "taylorw8-225", "walshnj-225", "wanes-225"
)

# Loop through each VM name and restart the VM if found
foreach ($vmName in $vmList) {
    try {
        $vm = Get-VM -Name $vmName
        if ($vm -ne $null) {
            Write-Host "Restarting VM: $vmName"
            Restart-VMGuest -VM $vm -Confirm:$false
        } else {
            Write-Host "VM not found: $vmName"
        }
    } catch {
        Write-Host "Error processing VM: $vmName. Error: $_"
    }
}

# Disconnect from the vCenter Server after operations
Disconnect-VIServer -Server $vCenterServer -Confirm:$false
