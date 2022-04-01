# Platform9 Managed Kubernetes - Hetzner Node

Platform9 provides a free managed Kubernetes platform for bare metal, vps or ova image nodes hosted by your own. This repository manage a node within Hetzner Cloud and configure these node as master to create a Platform9 Kubernetes "cluster".

The main purpose is to create a public reachable Kubernetes platform as fast as possible as playground and for testing purposes. To reduce costs and to protect the environment you can destroy the Hetzner and Platform9 setup at all time completely.

### Requirements

* Hetzner Cloud account and API token
* Platform9 free account
* Docker

Docker is used as Terraform executable. If you want to use Terraform instead of Docker you can execute the following command before you run the scripts.

```
sed -i 's/docker run -v `pwd`:\/tf -w \/tf hashicorp\/terraform:1\.1\.7/terraform/g' deploy.sh
sed -i 's/docker run -v `pwd`:\/tf -w \/tf hashicorp\/terraform:1\.1\.7/terraform/g' destroy.sh
```

### Deploy

* clone this repository
* cd into directory
* chmod +x deploy and destroy script

The script will ask for all required information. Get your API key from Hetzner and receive all information for Platform9 like account URL or username via Platform9 WebUI.

Run:   
`./deploy.sh`

### Destroy

Run:  
`./destroy.sh`

### Credits

* [www.platform9.com](https://platform9.com/)
* [www.hetzner.com](https://www.hetzner.com/)
* [www.terraform.io](https://www.terraform.io/)
