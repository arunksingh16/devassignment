#### Solution for Question 2
Terraform based deployment to support following Azure Infra components -
- Azure VNet 
- Azure Subnet
- Azure NSG
- Window VM
- Service Account

Terraform deployment has following files for specific purpose. 
- main.tf   [ for modules, providers and data-sources to create all resources ]
- var.tf    [ Variables ]
- vnet.tf   [ For VNet/Subnet/NSG deployment ]
- sa.tf     [ For SA deployment ]
- kv.tf     [ For KV deployment ]
- winvm.tf  [ For Windows VM Deployment ]


The deployment is completely automated using Azure DevOps Pipeline. 

Initialisation - 
You can initilise the terraform using service principle. But to keep things simple I am using standard task in Azure DevOps for deployment. 

Stages - 
