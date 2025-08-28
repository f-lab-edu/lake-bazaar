# Project IaaC 구조

```bash
infra/
  tofu/                      # OpenTofu (Terraform) 코드
    modules/
      project/               # (선택) API 활성화, 기본 IAM
      network/               # VPC, Subnet, FW rules
      service_accounts/      # 서비스 계정, IAM 바인딩
      compute_instances/     # GCE 인스턴스(Trino/Hadoop 등)
      gcs/                   # GCS 버킷
      cloudsql_mysql/        # Cloud SQL for MySQL (Hive Metastore 용)
    envs/
      dev/
        main.tf
        versions.tf
        variables.tf
        terraform.tfvars     # dev 변수
        backend.tf           # Remote State
        outputs.tf
      prod/
        ... (동일)
  ansible/                   # 구성 관리(Configure)
    inventories/
      dev/
        hosts.ini            # tofu outputs 로 생성/갱신
      prod/
        hosts.ini
    group_vars/
      all.yml                # 공통 변수 (timezone, ulimit 등)
      trino_workers.yml
      hdfs_datanodes.yml
    roles/
      base/                  # 사용자/SSH/패키지/시간동기/로그
        tasks/main.yml
        files/
        templates/
      hardening/
        tasks/main.yml
      java/
        tasks/main.yml
      monitoring_agent/
        tasks/main.yml       # node_exporter, fluentbit 등
      kernel_tuning/
        tasks/main.yml       # vm.max_map_count, nofile 등
    playbooks/
      site.yml               # 전체 베이스라인 적용
      trino.yml              # trino 노드 공통 설정
      hdfs.yml               # hdfs 노드 공통 설정
    scripts/
      render_hosts_from_tofu.py  # tofu outputs → hosts.ini 생성기
```
