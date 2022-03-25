

## Useful commands

Powershell from a windows VM

````
test-netconnection -ComputerName <name> -port 3389
````

## References

https://app.pluralsight.com/library/courses/microsoft-azure-administrator-configure-name-resolution/table-of-contents

https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-name-resolution-for-vms-and-role-instances

https://docs.microsoft.com/en-us/azure/firewall/tutorial-hybrid-portal-policy

https://docs.microsoft.com/en-us/azure/architecture/reference-architectures/app-service-web-app/scalable-web-app

https://docs.microsoft.com/en-us/azure/virtual-network/virtual-networks-udr-overview

https://docs.microsoft.com/en-us/microsoft-365/enterprise/connect-an-on-premises-network-to-a-microsoft-azure-virtual-network?view=o365-worldwide


## Setup IIS On Workload VM

Via cloud shell

````
Get-AzureRMSubscription
Get-AzSubscription -SubscriptionName mxinfo-prod

Set-AzVMExtension `
        -ResourceGroupName rg-mxinfo-peer-spoke `
        -ExtensionName IIS `
        -VMName vm-spoke-01 `
        -Publisher Microsoft.Compute `
        -ExtensionType CustomScriptExtension `
        -TypeHandlerVersion 1.4 `
        -SettingString '{"commandToExecute":"powershell Add-WindowsFeature Web-Server; powershell      Add-Content -Path \"C:\\inetpub\\wwwroot\\Default.htm\" -Value $($env:computername)"}' `
        -Location WestUS

````