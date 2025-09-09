tenancy_ocid            = "ocid1.tenancy.oc1..aaaaaaaa4aucoyxgqh3n4mlbwy7f32ua436e45wczoa3ja3blrgtzvqm2gaa"
compartment_ocid        = "ocid1.tenancy.oc1..aaaaaaaa4aucoyxgqh3n4mlbwy7f32ua436e45wczoa3ja3blrgtzvqm2gaa"
ssh_public_key_abs_path = "/Users/chanyong/.ssh/id_rsa.pub" # 반드시 '절대경로i'

# 기본: 무료 마이크로
shape = "VM.Standard.E2.1.Micro"

# (E2 Micro 자원 부족하면 아래로 전환)
# shape             = "VM.Standard.A1.Flex"
# a1flex_ocpus      = 1
# a1flex_memory_gb  = 6
