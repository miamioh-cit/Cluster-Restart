param(
    [string]$vCenterServer,
    [string]$vCenterUser,
    [string]$vCenterPass
)

# Ignore invalid or self-signed SSL certificates
Set-PowerCLIConfiguration -InvalidCertificateAction Ignore -Confirm:$false -Scope User

# Connect to the vCenter Server using the provided credentials
Connect-VIServer -Server $vCenterServer -User $vCenterUser -Password $vCenterPass

# Define the target folder name
$folderName = "DevOps"

try {
    # Get the folder object
    $folder = Get-Folder -Name $folderName

    if ($folder -eq $null) {
        Write-Host "Folder '$folderName' not found in vCenter."
        Disconnect-VIServer -Server $vCenterServer -Confirm:$false
        exit
    }

    # Get all VMs inside the folder
    $vmList = Get-VM -Location $folder

    if ($vmList.Count -eq 0) {
        Write-Host "No VMs found in folder '$folderName'."
    } else {
        # Loop through each VM and restart it
        foreach ($vm in $vmList) {
            try {
                Write-Host "Restarting VM: $($vm.Name)"
                Restart-VMGuest -VM $vm -Confirm:$false
            } catch {
                Write-Host "Error restarting VM: $($vm.Name). Error: $_"
            }
        }
    }

} catch {
    Write-Host "Error accessing vCenter or folder. Error: $_"
}

# Disconnect from the vCenter Server
Disconnect-VIServer -Server $vCenterServer -Confirm:$false
