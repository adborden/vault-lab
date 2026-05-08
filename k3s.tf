# Enable AppRole
resource "vault_auth_backend" "approle" {
  type = "approle"
  path = "auth/approle"

  tune {
    max_lease_ttl = "8760h"
  }
}

data "vault_policy_document" "k8s_server" {
  rule {
    path         = "etcd/issue/server"
    capabilities = ["create", "update"]
    description  = "create etcd certificate and keys"
  }

  rule {
    path         = "etcd/issue/client"
    capabilities = ["create", "update"]
    description  = "create etcd certificate and keys"
  }

  rule {
    path         = "etcd/issue/peer"
    capabilities = ["create", "update"]
    description  = "create etcd certificate and keys"
  }

  rule {
    path         = "kv/data/etcd/*"
    capabilities = ["read"]
    description  = "read etcd certificate secrets"
  }

  rule {
    path         = "kv/data/fl.a14n.net/*"
    capabilities = ["read"]
    description  = "read k8s tokens"
  }

  rule {
    path         = "kv/data/k3s/*"
    capabilities = ["read"]
    description  = "read k8s tokens"
  }
}

data "vault_policy_document" "k8s_agent" {
  rule {
    path         = "kv/data/fl.a14n.net/*"
    capabilities = ["read"]
    description  = "read k8s tokens"
  }

  rule {
    path         = "kv/data/k3s/*"
    capabilities = ["read"]
    description  = "read k8s tokens"
  }
}

resource "vault_policy" "k8s_agent" {
  name   = "k8s-agent"
  policy = data.vault_policy_document.k8s_agent.hcl
}

resource "vault_policy" "k8s_server" {
  name   = "k8s-server"
  policy = data.vault_policy_document.k8s_server.hcl
}

resource "vault_approle_auth_backend_role" "k3s_server" {
  backend        = vault_auth_backend.approle.path
  role_name      = "k3s-server"
  token_policies = [vault_policy.k8s_server.name]
  token_ttl      = 3600
  token_max_ttl  = 24 * 3600
  secret_id_ttl  = 24 * 3600 * 365
}

resource "vault_approle_auth_backend_role" "k3s_agent" {
  backend        = vault_auth_backend.approle.path
  role_name      = "k3s-agent"
  token_policies = [vault_policy.k8s_agent.name]
  token_ttl      = 3600
  token_max_ttl  = 24 * 3600
  secret_id_ttl  = 24 * 3600 * 365
}
