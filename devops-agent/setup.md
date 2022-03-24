# Setup of Azure VM as an Azure Dev Ops Build Agent


## Update Packages

````
sudo apt update 
sudo apt upgrade -y
````

## Create an account to run the agent

````
sudo adduser devops

sudo usermod -aG sudo devops

su - devops

````


## Install
* dotnet 2.1 SDK
* dotnet 3.1 SDK
* dotnet 5.0 SDK
* docker



## Docker
````
sudo apt install apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable"
sudo apt update
apt-cache policy docker-ce
sudo apt install docker-ce
sudo systemctl status docker

sudo usermod -aG docker devops

````

## Dotnet

````
wget https://packages.microsoft.com/config/ubuntu/21.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb

sudo apt update

sudo apt install dotnet-sdk-5.0
sudo apt install dotnet-sdk-2.1
sudo apt install dotnet-sdk-3.1

dotnet --list-sdks
````


## Install Trivy For Docker Image Scanning

````
sudo apt update
sudo apt install wget apt-transport-https gnupg lsb-release
wget -qO - https://aquasecurity.github.io/trivy-repo/deb/public.key | sudo apt-key add -
echo deb https://aquasecurity.github.io/trivy-repo/deb $(lsb_release -sc) main | sudo tee -a /etc/apt/sources.list.d/trivy.list
sudo apt update
sudo apt install trivy
````

### Add Junit template for test results

````

````
## Dev Ops Setup
* Create new Agent Pool
* Create Build agent
* Download agent
* Run startup script

https://docs.microsoft.com/en-us/azure/devops/pipelines/agents/v2-linux?view=azure-devops

###  Steps
* Create new Personal Access Token  - Scope Agent Pools Read & Manage 
* Copy the access token (This will be required when running the script to initialize the agent)
* Create a new Agent in an agent pool (Create a new agent pool if necessary)
* Create a working directory for the agent 
````
mkdir devopsagent
````
* Download the agent - copy the url to the clipboard
````
curl https://vstsagentpackage.azureedge.net/agent/2.190.0/vsts-agent-linux-x64-2.190.0.tar.gz --output vsts-agent.tar.gz
````
* Extract the agent
````
tar zxvf vsts-agent.tar.gz

````
* Configure the agent
````
./config.sh

````

Server URL https://dev.azure.com/{your-organization}

* Enter the pool name (created above)
* Enter a name for the agent

* Set the agent to run as a daemon
````
sudo ./svc.sh install <username>
sudo ./svc.sh start
sudo ./svc.sh status

````
## Clean Up
* Change the SSH port firewall rule to deny

## Terraform CLI

Install the Terraform executable on the devops server

* Download the archive with the executable and extract to /usr/bin/

````
curl https://releases.hashicorp.com/terraform/1.0.5/terraform_1.0.5_linux_amd64.zip -o terraform.zip
unzip terraform.zip
sudo mv terraform /usr/local/bin/

````

Verify terraform is available
````
terraform --verision
````

Clean up
````
rm terraform.zip

````
As the devops user
````
mkdir ~/.terraform.d
mkdir ~/.terraform.d/plugin-cache

````
## Terraform Cloud

### Create a Team API Token
A Team API Token can be used to allow interacting with Terraform cloud from the devops agent.  The team token can be used to authenticate to Terraform cloud in order to run Terraform Plan and Apply via the CLI.

Steps in Terraform Cloud
* Organization Settings
* Teams
* Create Team API Token

On the DevOps Server as the devops user

````
vim .terraformrc

````
.terraformrc example

````
plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"

credentials "app.terraform.io" {
    token = "<Team API Token>"
}
````


## Sonar Issue

````
sysctl -w vm.max_map_count=524288
sysctl -w fs.file-max=131072
ulimit -n 131072
ulimit -u 8192
````

## Attaching a data disk
* Create a new managed disk via Terraform
* Create a virtual machine data disk attachment to attach the new disk to the VM.

### Initialize the data disk

SSH to the virtual machine


* Find the disk

````
sudo lsblk -o NAME,HCTL,SIZE,MOUNTPOINT | grep -i "sd"
````

You should see an entry for the new disk.

* Partition the new disk

````
sudo parted /dev/sdc --script mklabel gpt mkpart xfspart xfs 0% 100%
sudo mkfs.xfs /dev/sdc1
sudo partprobe /dev/sdc1

````

* Mount the disk

````
sudo mkdir /data001
sudo mount /dev/sdc1 /data001

````

* Add the disk to /etc/fstab

````
sudo blkid
````

Get the disk information from the output
````
/dev/sdc1: UUID="2c1a239d-9ea3-4df6-8dc2-ea1a6d3cc68d" TYPE="xfs" PARTLABEL="xfspart" PARTUUID="8c3f3402-1c90-41aa-8c7e-ae5eb43482a2"

````
````
sudo vim /etc/fstab

````
Add a line with the disk information

UUID=2c1a239d-9ea3-4df6-8dc2-ea1a6d3cc68d   /data001   xfs   defaults,nofail   1   2

* Verify the disk

````
sudo lsblk -o NAME,HCTL,SIZE,MOUNTPOINT | grep -i "sd"
````

## Move the DevOps working directory

* Stop the devops agent service

````
sudo ./svc.sh stop
sudo ./svc.sh status
````

* Create a directory to use and change the ownership

````
sudo mkdir /data001/devops-agent
sudo chown -R devops:devops /data001/devops-agent
````


* Change the working directory in the config file

````
sudo vim .agent

````


* Start the devops agent service

````
sudo ./svc.sh start
sudo ./svc.sh status
````
