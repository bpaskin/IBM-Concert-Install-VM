### Installation of IBM Concert on a Linux Virtual Machine

The hardware requirements can be found in the Concert [Knowledge Center](https://www.ibm.com/docs/en/concert?topic=vm-installing-concert-software).  In addition, the system requires:
- `wget`, 
- `curl`, 
- `jq`, 
- `tar`,
- `docker` or `podman`
<br/>
An [IBM Entitlement Key](https://myibm.ibm.com/products-services/containerlibrary) is required to pull the images from the IBM Container Registry.
<br/>
On RHEL systems, Lingering must be enabled for the user doing the install:
- `loginctl enable-linger <user>`
<br/>
The variables can be updated before running the script to avoid prompting during the setup process.
<br/>
To Run:
1. Setup a directory where the Concert software will live on the system
2. copy over the concert-install.sh to that directory
3. Change the execution parameters for the script: `chmod 755 concert-install.sh`
4. Run the script: `./concert-install.sh`
<br/>
<br/>
𐕣 Funeral Winter 𐕣
