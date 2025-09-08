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
    # outputs 예시: {"master1_public_ip": {"value": "1.2.3.4"}, ...}
    hosts = {
        'masters': [],
        'workers': []
    }
    for k, v in data.items():
        if k.startswith('master'):
            hosts['masters'].append((k, v['value']))
        elif k.startswith('worker'):
            hosts['workers'].append((k, v['value']))

    print('[masters]')
    for name, ip in sorted(hosts['masters']):
        print(f'{name} ansible_host={ip}')
    print('\n[workers]')
    for name, ip in sorted(hosts['workers']):
        print(f'{name} ansible_host={ip}')

if __name__ == '__main__':
    main()
