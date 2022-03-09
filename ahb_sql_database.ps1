$azSubs = Get-AzSubscription
$AzureSqlDatabase = @()
$date = Get-Date
$day = $date.Day
$month = $date.Month
$year = $date.Year

foreach ($azSub in $azSubs) {
    Set-AzContext -Subscription $azSub | Out-Null
    $azSubName = $azSub.Name
    $sqlServers = Get-AzSqlServer

    foreach ($sqlServer in $sqlServers)  {

        $sqlServer_name = $sqlServer.ServerName
        $sqlServer_rg   = $sqlServer.ResourceGroupName

        foreach ($sqlDatabase in Get-AzSqlDatabase -ServerName $sqlServer_name -ResourceGroupName $sqlServer_rg) {
            $props = @{
                databaseName        = $sqlDatabase.DatabaseName
                licenseType         = $sqlDatabase.LicenseType
                resourceGroupName   = $sqlDatabase.ResourceGroupName
                subscriptionName    = $azSubName
            }
        $ServiceObject = New-Object -TypeName PSObject -Property $props
        $AzureSqlDatabase += $ServiceObject
        }
    }
}

$AzureSqlDatabase | Export-Csv -Path "C:\YOR\PATH\$year-$month-$day-SqlDatabase-ABH-Licensing.csv" -NoTypeInformation -force


