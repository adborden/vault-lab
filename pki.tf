resource "vault_pki_secret_backend_root_cert" "root_cert" {
  backend     = vault_mount.pki.path
  type        = "internal"
  common_name = "lab"
  ttl         = "87600h" # 10 years
}

resource "vault_pki_secret_backend_role" "node" {
  backend = vault_mount.pki.path
  name    = "node"
  allowed_domains = [
    "node-a.lab.internal",
    "node-a.lab",
    "node-a",
    "node-b.lab.internal",
    "node-b.lab",
    "node-b",
    "node-c.lab.internal",
    "node-c.lab",
    "node-c",
    "qemu01.lan.internal",
    "qemu01",
  ]
  allow_subdomains   = false
  allow_bare_domains = true
  allow_localhost    = false
  max_ttl            = 30 * 24 * 3600 # 30 days
  ttl                = 30 * 24 * 3600 # 30 days
  generate_lease     = true
  require_cn         = true
}

resource "vault_pki_secret_backend_root_cert" "etcd_2026" {
  backend     = vault_mount.etcd.path
  type        = "internal"
  common_name = "lab"
  ttl         = 315360000 # 10 years
}

resource "vault_pki_secret_backend_issuer" "issuer_2026" {
  backend     = vault_pki_secret_backend_root_cert.etcd_2026.backend
  issuer_ref  = vault_pki_secret_backend_root_cert.etcd_2026.issuer_id
  issuer_name = "issuer-2026"
}

resource "vault_pki_secret_backend_config_issuers" "config" {
  backend = vault_mount.etcd.path
  default = vault_pki_secret_backend_issuer.issuer_2026.issuer_id
  #default_follows_latest_issuer = true
}

resource "vault_pki_secret_backend_role" "etcd_server" {
  backend = vault_mount.etcd.path
  name    = "server"
  allowed_domains = [
    "node-a.lab",
    "node-a",
    "node-b.lab",
    "node-b",
    "node-c.lab",
    "node-c",
    "qemu01.lan",
    "qemu01",
    "192.168.8.3",
    "192.168.8.4",
    "192.168.8.5"
  ]
  allow_ip_sans      = true
  allow_subdomains   = false
  allow_bare_domains = true
  allow_localhost    = false
  max_ttl            = 30 * 24 * 3600 # 30 days
  ttl                = 30 * 24 * 3600 # 30 days
  generate_lease     = true
  require_cn         = true
  key_usage          = ["DigitalSignature", "KeyEncipherment"]
  ext_key_usage      = ["ServerAuth"]
}


resource "vault_pki_secret_backend_role" "etcd_peer" {
  backend = vault_mount.etcd.path
  name    = "peer"
  allowed_domains = [
    "node-a.lab",
    "node-a",
    "node-b.lab",
    "node-b",
    "node-c.lab",
    "node-c",
    "qemu01",
    "192.168.8.3",
    "192.168.8.4",
    "192.168.8.5"
  ]
  allow_ip_sans      = true
  allow_subdomains   = false
  allow_bare_domains = true
  allow_localhost    = false
  max_ttl            = 30 * 24 * 3600 # 30 days
  ttl                = 30 * 24 * 3600 # 30 days
  generate_lease     = true
  key_usage          = ["DigitalSignature", "KeyEncipherment"]
  ext_key_usage      = ["ServerAuth", "ClientAuth"]
  require_cn         = true
  server_flag        = true
  client_flag        = true
}


resource "vault_pki_secret_backend_role" "etcd_client" {
  backend = vault_mount.etcd.path
  name    = "client"
  allowed_domains = [
    "node-a.lab",
    "node-a",
    "node-b.lab",
    "node-b",
    "node-c.lab",
    "node-c",
    "qemu01"
  ]
  allow_subdomains   = false
  allow_bare_domains = true
  allow_localhost    = false
  max_ttl            = 30 * 24 * 3600 # 30 days
  ttl                = 30 * 24 * 3600 # 10 days
  generate_lease     = true
  require_cn         = true
  key_usage          = ["DigitalSignature"]
  ext_key_usage      = ["ClientAuth"]
  client_flag        = true
  server_flag        = false
}
