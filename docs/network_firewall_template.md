# 네트워크/방화벽 템플릿 (VPC/FW) 설계

## 목적
- 5노드 클러스터(Hadoop, Hive, Spark, Zookeeper 등) 운영에 필요한 최소 포트만 오픈하는 보안 정책 설계
- 불필요한 외부 접근 차단, 서비스별 필수 포트만 허용

## 1. 필수 오픈 포트 정의

| 서비스         | 포트    | 설명                                 |
| -------------- | ------- | ------------------------------------ |
| SSH            | 22      | 운영/관리용 SSH 접속                 |
| Zookeeper      | 2181    | 클러스터 coordination                |
| Zookeeper      | 2888    | Follower <-> Leader 통신             |
| Zookeeper      | 3888    | Follower 선출                        |
| Hadoop NN      | 9870    | NameNode Web UI                      |
| Hadoop DN      | 9864    | DataNode Web UI                      |
| YARN RM        | 8088    | ResourceManager Web UI               |
| YARN NM        | 8042    | NodeManager Web UI                   |
| Spark History  | 18080   | Spark History Server                  |
| MapReduce JHS  | 10020   | JobHistory Server                    |
| HiveServer2    | 10000   | Hive JDBC                            |
| Hive Metastore | 9083    | Hive Metastore                       |
| Airflow        | 8080    | Airflow Web UI                       |
| MySQL          | 3306    | Hive Metastore backend               |

> 참고: 실제 오픈 포트는 배포 환경/보안 정책에 따라 조정 가능

## 2. 네트워크/방화벽 설계 방향
- 외부(인터넷) → SSH(22)만 허용 (운영자 IP로 제한 권장)
- 클러스터 내부 통신(서브넷 내): 위 필수 포트만 허용
- 나머지 모든 인바운드 트래픽 차단
