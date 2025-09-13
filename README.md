### GCP 인증키 환경변수
GCP 서비스 계정 키 파일 경로는 환경변수로도 지정할 수 있습니다.

```sh
export GOOGLE_CREDENTIALS_FILE=/path/to/your/gcp-key.json
```
또는 .env 파일에 추가:
```
GOOGLE_CREDENTIALS_FILE=/path/to/your/gcp-key.json
```
Terraform 실행 시 자동으로 참조됩니다.
# lake-bazaar
e-commerce 플랫폼의 주문 및 상품 데이터를 Ingestion, Transform, Load, Serving 하여 Business Insight 도출을 도와주는 Data Lake House Platform


## 환경 변수 설정

환경 변수는 `.env` 파일로 관리

```sh
cp .env.sample .env
# .env 파일을 열어 실제 환경에 맞게 수정
```

환경 변수 적용:
```sh
source .env
```

### 주요 환경 변수
- `ANSIBLE_USER`: Ansible 및 SSH 접속 계정명
- `ANSIBLE_SSH_PRIVATE_KEY_FILE`: SSH 프라이빗 키 경로

## 배포/프로비저닝 자동화 사용법

1. 환경 변수 적용
	```sh
	source .env
	```
2. VM 생성 및 베이스 OS 자동화 (예시)
	```sh
	cd infra/tofu/envs/prod
	tofu apply -auto-approve
	# 또는 destroy: tofu destroy -auto-approve
	```
3. master1 베이스 OS 부트스트랩
	```sh
	bash ../../../../bootstrap_master1.sh <MASTER1_IP> $ANSIBLE_USER $ANSIBLE_SSH_PRIVATE_KEY_FILE
	```
