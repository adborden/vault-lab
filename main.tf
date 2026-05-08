# Enable PKI backend
resource "vault_mount" "pki" {
  path        = "pki"
  type        = "pki"
  description = "PKI backend for issuing TLS certs to auth against Vault"
}

# Enable PKI backend
resource "vault_mount" "etcd" {
  path                  = "etcd"
  type                  = "pki"
  description           = "PKI backend for issuing etcd TLS certs for Flatcar Linux nodes"
  max_lease_ttl_seconds = 20 * 365 * 24 * 3600 # 20 years
}
