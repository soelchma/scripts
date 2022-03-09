$azSubs = Get-AzSubscription
$AzureVM = @()
$date = Get-Date
$day = $date.Day
$month = $date.Month
$year = $date.Year

foreach ( $azSub in $azSubs ){
    Set-AzContext -Subscription $azSub | Out-Null
    $azSubName = $azSub.Name

    foreach ($azVM in Get-AzVM) {
        $props = @{
            VMName = $azVM.Name
            Region = $azVM.Location
            OsType = $azVM.StorageProfile.OsDisk.OsType
            ResourceGroupName = $azVM.ResourceGroupName
            subscriptionName = $azSubName
        }
        if (!$azVM.LicenseType) {
            $props += @{
                LicenseType = "No_License"
            }
        }
        else {
            $props += @{
                LicenseType = $azVM.LicenseType
            }
        }
    $ServiceObject = New-Object -TypeName PSObject -Property $props
    $AzureVM += $ServiceObject
    }
}

$AzureVM | Export-Csv -Path "C:\YOUR\PATH\$month-$year-$day-VM-AHB-Licensing.csv" -NoTypeInformation -force
