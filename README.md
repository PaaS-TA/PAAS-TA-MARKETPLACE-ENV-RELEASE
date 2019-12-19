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

