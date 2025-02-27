### Installation of IBM Concert on a Linux Virtual Machine

The hardware requirements can be found in the Concert [Knowledge Center](https://www.ibm.com/docs/en/concert?topic=vm-installing-concert-software).  In addition, the system requires:
- `wget`, 
- `curl`, 
- `jq`, 
- `tar`,
- `docker` or `podman`


An [IBM Entitlement Key](https://myibm.ibm.com/products-services/containerlibrary) is required to pull the images from the IBM Container Registry.

On RHEL systems, Lingering must be enabled for the user doing the install:
- `loginctl enable-linger <user>`
  
The variables can be updated before running the script to avoid prompting during the setup process.

To Run:
-  Setup a directory where the Concert software will live on the system
-  copy over the concert-install.sh to that directory
-  Change the execution parameters for the script: `chmod 755 concert-install.sh`
-  Run the script: `./concert-install.sh`

𐕣 Funeral Winter 𐕣
