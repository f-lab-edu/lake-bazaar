#!/usr/bin/env python3
"""
tofu outputs → Ansible hosts.ini 자동 생성 스크립트
- VM명, public_ip, (추후 확장: private_ip, role 등) 기반
- 실행 예시: tofu output -json | python3 render_hosts_from_tofu.py > hosts.ini
"""
import sys
import json

def main():
    data = json.load(sys.stdin)
    # outputs 예시: {"master1_internal_ip": {"value": "10.x.x.x"}, "master1_public_ip": {...}}
    def pick_ip(name: str) -> str:
        internal = data.get(f"{name}_internal_ip", {}).get("value")
        public = data.get(f"{name}_public_ip", {}).get("value")
        return internal or public or ""

    masters = ["master1", "master2"]
    workers = ["worker1", "worker2", "worker3"]

    print('[masters]')
    for name in masters:
        ip = pick_ip(name)
        if ip:
            print(f'{name} ansible_host={ip}')
        else:
            print(name)
    print('\n[workers]')
    for name in workers:
        ip = pick_ip(name)
        if ip:
            print(f'{name} ansible_host={ip}')
        else:
            print(name)

if __name__ == '__main__':
    main()
