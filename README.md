## Table of Contents

[1. 문서 개요](#1)

  - [1.1. 목적](#1.1)
  - [1.2. 범위](#1.2)
  - [1.3. 시스템 구성](#1.3)
  - [1.4. 참고자료](#1.4)
  
[2. Marketplace Environment Release 생성](#2)
  
[3. Marketplace Environment 설치](#3)

  - [3.1. Stemcell 업로드](#3.1)
  - [3.2. Marketplace Environment Release 업로드](#3.2)
  - [3.3. Marketplace Environment Deployment 파일 수정 및 배포](#3.3)


## <div id="1"/> 1. 문서 개요

### <div id="1.1"/> 1.1. 목적

본 문서는 Marketplace 서비스에 필요한 제반 환경을 구축하기 위해 Marketplace Environment Release를 Bosh2.0을 이용하여 설치 하는 방법을 기술하였다.

### <div id="1.2"/> 1.2. 범위

설치 범위는 Marketplace 서비스에 필요한 기본 환경 구성을 위한 설치를 기준으로 작성하였다.

### <div id="1.3"/> 1.3. 시스템 구성

본 장에서는 Marketplace Environment 구성에 대해 기술하였다. Marketplace 서비스에 필요한 환경은 binary_storage, mariadb의 최소사항을 구성하였다.  

VM명 | 인스턴스 수 | vCPU수 | 메모리(GB) | 디스크(GB)
:--- | :---: | :---: | :---:| :---
binary_storage | 1 | 1 |1 | 
mariadb | 1 | 1 | 2 | Root 8G + Persistent disk 10G

### <div id="1.4"/> 1.4. 참고자료
> http://bosh.io/docs  
> http://docs.cloudfoundry.org/  

## <div id="2"/> 2. Marketplace Environment Release 생성  

- PaaS-TA Marketplace Environment Release의 최신버전을 다운로드 받는다.  
    ```
    $ git clone https://github.com/PaaS-TA/PAAS-TA-MARKETPLACE-ENV-RELEASE.git
    $ cd PAAS-TA-MARKETPLACE-ENV-RELEASE
    ```
- source 파일을 다운로드하여 src 디렉토리에 복사한다.  
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
        │   └── swift-all-in-one.tar.gz
    ```

- Marketplace Environment Release 파일을 생성한다.
    ```
    ## <RELEASE_TARBALL_PATH> :: release file path (e.g. /home/ubuntu/workspace/paasta-marketplace-env-release.tgz) 
    $ bosh -e <bosh_name> create-release --name=paasta-marketplace-env-release --version=1.0 --tarball=<RELEASE_TARBALL_PATH> --force
    ```  

## <div id="3"/> 3. Marketplace Environment 설치  

### <div id="3.1"/> 3.1 Stemcell 업로드

Marketplace Environment 설치에 필요한 Stemcell을 확인하여 존재하지 않을 경우 BOSH 설치 가이드 문서를 참고 하여 Stemcell을 업로드 한다. (Marketplace Environment는 Stemcell ubuntu-xenial 315.64 버전을 사용, PaaSTA-Stemcell.zip)

-	설치 파일 다운로드 위치 : https://paas-ta.kr/download/package

```
# Stemcell 목록 확인
$ bosh -e micro-bosh stemcells
Using environment '10.0.1.6' as client 'admin'

Name                                     Version  OS             CPI  CID  
bosh-aws-xen-hvm-ubuntu-xenial-go_agent  315.64*  ubuntu-xenial  -    ami-0297ff649e8eea21b  

(*) Currently deployed

1 stemcells

Succeeded
```

### <div id="3.2"/> 3.2. Marketplace Environment Release 업로드

- 릴리즈 목록을 확인하여 Marketplace Environment 릴리즈가 업로드 되어 있지 않은 것을 확인한다.

```
# 릴리즈 목록 확인
$ bosh -e micro-bosh releases
Using environment '10.0.1.6' as client 'admin'

Name                   Version    Commit Hash  
binary-buildpack       1.0.32*    2399a07  
bosh-dns               1.12.0*    5d607ed  
bosh-dns-aliases       0.0.3*     eca9c5a  
bpm                    1.1.0*     27e1c8f  
capi                   1.83.0*    6b3cd37

... ((생략)) ...

(*) Currently deployed
(+) Uncommitted changes

34 releases

Succeeded
```

- Marketplace Environment 릴리즈 파일을 업로드한다.

```
# 릴리즈 파일 업로드
## <RELEASE_TARBALL_PATH> :: release file path (e.g. /home/ubuntu/workspace/paasta-marketplace-env-release.tgz) 
$ bosh -e micro-bosh upload-release <RELEASE_TARBALL_PATH>

Using environment

######################################################## 100.00% 376.25 KiB/s 0s
Task 138754

Task 138754 | 07:01:31 | Extracting release: Extracting release (00:00:00)
Task 138754 | 07:01:31 | Verifying manifest: Verifying manifest (00:00:00)
Task 138754 | 07:01:31 | Resolving package dependencies: Resolving package dependencies (00:00:00)
Task 138754 | 07:01:31 | Creating new packages: mariadb/467dceb9fb6dbc9df546c837c92895243c3a173d9dae773ae7ff9518ee3eac0d (00:00:30)
Task 138754 | 07:02:01 | Creating new packages: python/6ecc99084b929c8382f8a81410e1b9f13728b57c684bcb13c4f5e490f4ad9620 (00:00:01)
Task 138754 | 07:02:02 | Creating new packages: swift-all-in-one/18bf9d0780d9c4b978424bfda05e7c8494b53af7fbd7bd1f8a3bf65ed0ae1ea1 (00:00:10)
Task 138754 | 07:02:12 | Creating new jobs: binary_storage/0116e8751ba57fb2b86b537d117bac0bc68ccc029afa5e3d9587244a731d7453 (00:00:00)
Task 138754 | 07:02:12 | Creating new jobs: mariadb/9547d812241b33b9017b077a455b770cab55dfef30318e743702e12f6d80827e (00:00:01)
Task 138754 | 07:02:13 | Release has been created: paasta-marketplace-env-release/1.0 (00:00:00)

Task 138754 Started  Thu Dec 19 07:01:31 UTC 2019
Task 138754 Finished Thu Dec 19 07:02:13 UTC 2019
Task 138754 Duration 00:00:42
Task 138754 done

Succeeded
```

- 릴리즈 목록을 확인하여 Marketplace Environment 릴리즈가 업로드 되어 있는 것을 확인한다.

```
# 릴리즈 목록 확인
$ bosh -e micro-bosh releases
Using environment '10.0.1.6' as client 'admin'

Name                            Version    Commit Hash  
binary-buildpack                1.0.32*    2399a07  
bosh-dns                        1.12.0*    5d607ed  
bosh-dns-aliases                0.0.3*     eca9c5a  
bpm                             1.1.0*     27e1c8f  
capi                            1.83.0*    6b3cd37  
paasta-marketplace-env-release  1.0*       8598207   

... ((생략)) ...

(*) Currently deployed
(+) Uncommitted changes

35 releases

Succeeded
```

### <div id="3.3"/> 3.3. Marketplace Environment Deployment 파일 수정 및 배포

BOSH Deployment manifest는 Components 요소 및 배포의 속성을 정의한 YAML 파일이다.
Deployment 파일에서 사용하는 network, vm_type, disk_type 등은 Cloud config를 활용하고, 활용 방법은 BOSH 2.0 가이드를 참고한다.

-	Cloud config 설정 내용을 확인한다.

```
# Cloud config 조회
$ bosh -e micro-bosh cloud-config
Using environment '10.0.1.6' as client 'admin'

azs:
- cloud_properties:
    availability_zone: ap-northeast-2a
  name: z1
- cloud_properties:
    availability_zone: ap-northeast-2a
  name: z2

... ((생략)) ...

- cloud_properties:
    availability_zone: ap-northeast-2a
  name: z7
compilation:
  az: z4
  network: default
  reuse_compilation_vms: true
  vm_type: xlarge
  workers: 5
disk_types:
- disk_size: 1024
  name: default

... ((생략)) ...

- cloud_properties:
    type: gp2
  disk_size: 500000
  name: 50GB_GP2
networks:
- name: default
  subnets:
  - az: z1
    cloud_properties:
      security_groups: paasta-security-group
      subnet: subnet-00000000000000000
    dns:
    - 8.8.8.8
    gateway: 10.0.1.1
    range: 10.0.1.0/24
    reserved:
    - 10.0.1.2 - 10.0.1.9
    static:
    - 10.0.1.10 - 10.0.1.120

... ((생략)) ...

- cloud_properties:
    ephemeral_dist:
      size: 4096
      type: gp2
    instance_type: t2.small
  name: caas_small
- cloud_properties:
    ephemeral_dist:
      size: 30000
      type: gp2
    instance_type: m4.xlarge
  name: caas_small_highmem

Succeeded
```

- Deployment 파일을 서버 환경에 맞게 수정한다.

```
name: paasta-marketplace-env                             # 서비스 배포이름(필수) bosh deployments 로 확인 가능한 이름

releases:
- name: paasta-marketplace-env-release
  version: latest

stemcells:
- alias: default
  os: ((stemcell_os))
  version: latest

update:
  canaries: 1                                               # canary 인스턴스 수(필수)
  canary_watch_time: 5000-120000                            # canary 인스턴스가 수행하기 위한 대기 시간(필수)
  update_watch_time: 5000-120000                            # non-canary 인스턴스가 수행하기 위한 대기 시간(필수)
  max_in_flight: 1                                          # non-canary 인스턴스가 병렬로 update 하는 최대 개수(필수)
  serial: false

instance_groups:
- name: binary_storage
  azs:
  - z2
  instances: 1
  stemcell: default
  persistent_disk: 102400
  vm_type: ((vm_type_medium))
  networks:
  - name: ((default_network_name))
  jobs:
  - name: binary_storage
    release: paasta-marketplace-env-release
- name: mariadb
  instances: 1
  azs:
  - z2
  stemcell: default
  vm_type: ((vm_type_small))
  persistent_disk: 4096
  networks:
  - name: ((default_network_name))
  jobs:
  - name: mariadb
    release: paasta-marketplace-env-release

######### PROPERTIES ##########
properties:
  mariadb:                                                 # MARIA DB SERVER 설정 정보
    port: ((db_port))
    admin_user:
      password: ((db_admin_password))                      # MARIA DB ADMIN USER PASSWORD
  binary_storage:                                          # BINARY STORAGE SERVER 설정 정보
    proxy_port: 10008                                      # 프록시 서버 Port(Object Storage 접속 Port)
    auth_port: 5000
    username:                                              # 최초 생성되는 유저이름(Object Storage 접속 유저이름)
      - paasta-marketplace
    password:                                              # 최초 생성되는 유저 비밀번호(Object Storage 접속 유저 비밀번호)
      - paasta
    tenantname:                                            # 최초 생성되는 테넌트 이름(Object Storage 접속 테넌트 이름)
      - paasta-marketplace
    email:                                                 # 최소 생성되는 유저의 이메일
      - email@email.com
    binary_desc:
      - 'marketplace-container'
```

- paasta-marketplace-env를 배포한다.

```
$ sh ./deploy-paasta-marketplace-env.sh
Using environment '10.174.0.3' as client 'admin'

Using deployment 'paasta-marketplace-env'

+ azs:
+ - cloud_properties:
+     zone: asia-northeast2-a
+   name: z1
+ - cloud_properties:
+     zone: asia-northeast2-a
+   name: z2
+ - cloud_properties:
+     zone: asia-northeast2-a
+   name: z3
+ - cloud_properties:
+     zone: asia-northeast2-b
+   name: z4
+ - cloud_properties:
+     zone: asia-northeast2-b
+   name: z5
+ - cloud_properties:
+     zone: asia-northeast2-c
+   name: z6
+ - cloud_properties:
+     zone: asia-northeast2-a
+   name: z7

... ((생략)) ...  

+ instance_groups:
+ - azs:
+   - z2
+   instances: 1
+   jobs:
+   - name: binary_storage
+     release: paasta-marketplace-env-release
+   name: binary_storage
+   networks:
+   - name: default
+   persistent_disk: 102400
+   stemcell: default
+   vm_type: medium
+ - azs:
+   - z2
+   instances: 1
+   jobs:
+   - name: mariadb
+     release: paasta-marketplace-env-release
+   name: mariadb
+   networks:
+   - name: default
+   persistent_disk: 4096
+   stemcell: default
+   vm_type: small

+ name: paasta-marketplace-env

+ properties:
+   binary_storage:
+     auth_port: "<redacted>"
+     binary_desc:
+     - "<redacted>"
+     email:
+     - "<redacted>"
+     password:
+     - "<redacted>"
+     proxy_port: "<redacted>"
+     tenantname:
+     - "<redacted>"
+     username:
+     - "<redacted>"
+   mariadb:
+     admin_user:
+       password: "<redacted>"
+     port: "<redacted>"

Continue? [yN]: y

Task 138757

Task 138757 | 07:06:15 | Preparing deployment: Preparing deployment (00:00:03)
Task 138757 | 07:06:18 | Preparing deployment: Rendering templates (00:00:00)
Task 138757 | 07:06:18 | Preparing package compilation: Finding packages to compile (00:00:00)
Task 138757 | 07:06:18 | Compiling packages: mariadb/467dceb9fb6dbc9df546c837c92895243c3a173d9dae773ae7ff9518ee3eac0d
Task 138757 | 07:06:18 | Compiling packages: swift-all-in-one/18bf9d0780d9c4b978424bfda05e7c8494b53af7fbd7bd1f8a3bf65ed0ae1ea1
Task 138757 | 07:06:18 | Compiling packages: python/6ecc99084b929c8382f8a81410e1b9f13728b57c684bcb13c4f5e490f4ad9620
Task 138757 | 07:08:08 | Compiling packages: swift-all-in-one/18bf9d0780d9c4b978424bfda05e7c8494b53af7fbd7bd1f8a3bf65ed0ae1ea1 (00:01:50)
Task 138757 | 07:08:30 | Compiling packages: mariadb/467dceb9fb6dbc9df546c837c92895243c3a173d9dae773ae7ff9518ee3eac0d (00:02:12)
Task 138757 | 07:09:37 | Compiling packages: python/6ecc99084b929c8382f8a81410e1b9f13728b57c684bcb13c4f5e490f4ad9620 (00:03:19)
Task 138757 | 07:10:04 | Creating missing vms: binary_storage/4967679f-7b4a-4095-a063-4fcfb0db8c8b (0)
Task 138757 | 07:10:04 | Creating missing vms: mariadb/dc9fe129-0b8b-487a-85da-aa8606b73ca0 (0)
Task 138757 | 07:11:16 | Creating missing vms: binary_storage/4967679f-7b4a-4095-a063-4fcfb0db8c8b (0) (00:01:12)
Task 138757 | 07:11:16 | Creating missing vms: mariadb/dc9fe129-0b8b-487a-85da-aa8606b73ca0 (0) (00:01:12)
Task 138757 | 07:11:27 | Updating instance binary_storage: binary_storage/4967679f-7b4a-4095-a063-4fcfb0db8c8b (0) (canary)
Task 138757 | 07:11:27 | Updating instance mariadb: mariadb/dc9fe129-0b8b-487a-85da-aa8606b73ca0 (0) (canary) (00:01:32)
Task 138757 | 07:15:55 | Updating instance binary_storage: binary_storage/4967679f-7b4a-4095-a063-4fcfb0db8c8b (0) (canary) (00:04:28)

Task 138757 Started  Thu Dec 19 07:06:15 UTC 2019
Task 138757 Finished Thu Dec 19 07:15:55 UTC 2019
Task 138757 Duration 00:09:40
Task 138757 done

Succeeded
```

- 배포된 paasta-marketplace-env를 확인한다.

```
$ bosh -e micro-bosh -d paasta-marketplace-env vms

Deployment 'paasta-marketplace-env'

Instance                                             Process State  AZ  IPs              VM CID                                   VM Type  Active
binary_storage/66e5bf20-da8d-42b4-a325-fba5f6e326e8  running        z2  XXX.XXX.XXX.XXX  vm-a81d9fe1-e9e8-4729-9786-bbb5f1518234  medium   true
mariadb/01ce2b6f-1038-468d-92f8-f68f72f7ea77         running        z2  XXX.XXX.XXX.XXX  vm-ce5deeed-ba4e-49d1-b6ab-1f07c779e776  small    true
```
