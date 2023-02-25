

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
terra
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

Hub Vnet 10.140.0.0/16
10.140.2.0
FW 10.140.1.0/24
Gateway 10.140.1.0/24


Spoke Vnet 10.142.0.0/16
10.142.2.0/24

Routes 0.0.0.0/0 to Firewall - attached to 10.142.2.0

On Prem Vnet
10.144.0.0/16
GW 10.144.1.0/24
10.144.2.0/24

Routes 10.142.0.0/16 to firewall - attached to 10.140.1.0/24

## Gitlab issue

error during reconfigure step
sudo gitlab-ctl reconfigure

