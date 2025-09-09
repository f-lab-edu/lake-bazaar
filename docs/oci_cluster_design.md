# OCI Always Free 클러스터 구성 설계

## 목적
- Oracle Cloud Always Free 한도 내에서 5노드 클러스터(Hadoop, Hive, Spark, Airflow 등) 구축
- 각 노드 역할 및 인스턴스 타입, 한도/자원 설계 명확화

---

## 1. 클러스터 노드 및 인스턴스 타입

| 노드 | 역할 요약 | 인스턴스 타입 | CPU/메모리 |
|------|-----------|--------------|------------|
| M1   | NameNode, ResourceManager, ZK, JournalNode, ZKFC | A1 Flex | 1 OCPU / 6GB RAM |
| M2   | NameNode, ResourceManager, ZK, JournalNode, ZKFC | A1 Flex | 1 OCPU / 6GB RAM |
| C1   | ZK, JournalNode, JobHistory, Airflow, Spark History, HAProxy, DataNode, NodeManager | A1 Flex | 1 OCPU / 6GB RAM |
| D1   | HiveServer2, Spark Worker, DataNode, NodeManager | E2 Micro | 1/8 OCPU / 1GB RAM |
| D2   | Hive Metastore, Spark Worker, DataNode, NodeManager | E2 Micro | 1/8 OCPU / 1GB RAM |

---

## 2. OCI Always Free 한도
- **A1 Flex:** 최대 4 OCPU, 24GB RAM (이번 설계는 3 OCPU, 18GB RAM 사용)
- **E2 Micro:** 최대 2대 (각 1/8 OCPU, 1GB RAM)
- **부트 볼륨:** 인스턴스당 50GB, 총 200GB 한도 내에서 5대 배포 가능
- **VCN(네트워크):** 최대 2개
- **공인 IP:** 필요 노드에만 할당 가능

---

## 3. 네트워크/방화벽 정책
- 외부(인터넷): SSH(22)만 허용, 운영자 IP로 제한 권장
- 내부(서브넷): 서비스별 필수 포트만 허용(2181, 2888, 3888, 9870, 9864, 8088, 8042, 18080, 10020, 10000, 9083, 8080, 3306 등)

---

## 4. 이미지 및 OS
- 모든 인스턴스는 Always Free Eligible 이미지(Oracle Linux, Ubuntu 등) 사용
- ARM(A1 Flex)과 x86(E2 Micro) 혼합 환경, 대부분의 오픈소스 빅데이터/분산 시스템은 ARM 지원

---