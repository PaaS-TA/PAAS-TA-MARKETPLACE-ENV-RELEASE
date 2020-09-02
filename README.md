## PAAS-TA-MARKETPLACE-ENV-RELEASE   

### Notices     
  - Use PAAS-TA-MARKETPLACE-ENV-RELEASE >= v.1.0.0   
    - PaaS-TA >= v.5.0.0   
    - service-deployment >= v5.0.1   

### PaaS-TA Marketplace Environment Release Configuration   

  - binary_storage :: 1 machine   
  - mariadb :: 1 machine   

### Create PaaS-TA Marketplace Environment Release   
  - Download the latest PaaS-TA Marketplace Environment Release   
    ```
    $ git clone https://github.com/PaaS-TA/PAAS-TA-MARKETPLACE-ENV-RELEASE.git   
    $ cd PAAS-TA-MARKETPLACE-ENV-RELEASE   
    ```
  - Download & Copy "source files" into the src directory   
    ```
    ## download source files   
    $ wget -O source-files.zip http://45.248.73.44/index.php/s/oK6LMotMFjCGoz9/download   
    
    ## unzip download source files   
    $ unzip source-files.zip   
    
    ## final src directory   
    src
        ├── mariadb   
        │   ├── mariadb-10.1.22-linux-x86_64.tar.gz   
        ├── python   
        │   ├── Python-2.7.8.tgz   
        ├── swift-all-in-one   
            └── swift-all-in-one.tar.gz      
    ```
  - Create PaaS-TA Marketplace Environment Release   
    ```
    ## <VERSION> :: release version (e.g. 1.0.1)   
    ## <RELEASE_TARBALL_PATH> :: release file path (e.g. /home/ubuntu/workspace/paasta-marketplace-env-release-<VERSION>.tgz)    
    $ bosh -e <bosh_name> create-release --name=paasta-marketplace-env-release --version=<VERSION> --tarball=<RELEASE_TARBALL_PATH> --force   
    ```   
### Deployment   
- https://github.com/PaaS-TA/service-deployment   
