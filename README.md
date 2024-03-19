# VM_Azure
Azure VM using Terraform
* ## Pasos a seguir:
* Se crea el archivo [main](main.tf) que tiene:

    Azure Resource Group. <br>
    Azure Virtual Network. <br>
    Azure Subnet. <br>
    Azure Public IP. <br>
    Azure Network Interface. <br>
    Azure Network Security Group. <br>
    Azure Network Interface Security <br>
    Group Association. <br>
    Azure Network Security Rule. <br>
    Azure Virtual Machine. <br>
    Storage OS Disk. <br>

* El archivo [variables](variables.tf) contiene las variables utilizadas para parametrizar la configuración de la infraestructura.

* El archivo [terraform](terraform.tfvars) es un archivo de variables  de Terraform que define las variables en los archivos de configuración de Terraform

* ## Comandos

1. ````terraform init````
2. ````terraform validate````
3. ````terraform plan````
4. ````terraform fmt````
5. ````terraform apply````
6. ````terraform apply````