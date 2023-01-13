# kubernetes 테스트베드 생성

Vagrant와 VirtualBox를 활용해서 로컬 환경에 쿠버네티스 클러스터를 구축하기 위해 만들어졌습니다.

## Kubernetes 클러스터 환경
- 운영체제 CentOS 8
- kubernetes v1.24 이상 가능 (v1.24, v1.25)
- cri-o v1.24 이상 가능 (v1.24, v1.25)
- calico v3.24.5

## Kubernetes 클러스터 사용자 설정
- 테스트베드는 마스터 노드 1대와 워커 노드 N대(최소 3대)로 구성
- Vagrantfile에서 아래의 변수를 변경해 Kubernetes 버전 및 노드 IP 설정
```
# variables
IMAGE_NAME = "generic/centos8"
K8S_VERSION = "1.25"
MASTER_IP = "192.168.100.10"
WORKER_CNT = 3
```

## Kubernetes 클러스터 생성
Vagrant 명령어를 실행해 쿠버네티스 클러스터를 생성합니다.
```
vagrant up
```