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


1) What are different artifacts you need to create - name of the artifacts and its purpose


Terraform `Azurerm` for backend where `tf state` will be stored. I am using Azure Blob container for same. 
So before proceeding for tf setup, I created a SA and Blob container using cli. 
To access the container while tf executes, there are multiple ways. I am using simplest possible way, the Azure CLI or a Service Principal.


2) List the tools you will to create and store the Terraform templates.

I have cretaed a structure for this deployment. I kept Azure resources in seperate files for better management. The templates will be uploaded to git based repository so that devops pipeline can access the same. The terrform state is being stored in azure blob.


3) Explain the process and steps to create automated deployment pipeline.

Azure DevOps pipeline will be prepared to execute terraform based deployment. There is a extention available at `Visual Studio Market Place` specifically for terraform. We need to deploy the same on build agents so that we can utilise it for tf deployment. The extention is pretty simple and will need Service Connection to access azure resources.
Pipeline will have 3 main steps primarily - `terraform init` -> `terraform plan` -> `terraform apply`

Please note, I have added one more controlled stage for destroy as well. 


4) Create a sample Terraform template you will use to deploy Below services:
Vnet
2 Subnet
NSG to open port 80 and 443
1 Window VM in each subnet
1 Storage account


There are files with `.tf` extention in this repository. Which will deploy above mentioned items. 


5) Explain how will you access the password stored in Key Vault and use it as Admin Password in the VM Terraform template.

- for this you have two options 
  1/ Create KeyVault in advance using `az cli` and update password as a secret in it and you can use tf module and resources to access the same. When KV is ready map it with Azure variable group or directly use Azure DevOps task to put in a variable and pass it in pipeline.

  2/ Create KV using the tf itself and update it with random strong password tf resouce. I have covered this in tf module. (this way I have shown how to access a kv as well)

  both methods have its own pros/cons. 


