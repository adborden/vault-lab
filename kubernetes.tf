resource "vault_auth_backend" "kubernetes" {
  type = "kubernetes"
}

# Vault runs inside the lab cluster, so it authenticates TokenReview
# requests with its own pod service account (vault/vault, bound to
# system:auth-delegator by the Helm chart). The token and CA cert are
# read from /var/run/secrets/kubernetes.io/serviceaccount and re-read
# on rotation, so neither token_reviewer_jwt nor kubernetes_ca_cert is
# set here.
resource "vault_kubernetes_auth_backend_config" "lab" {
  backend         = vault_auth_backend.kubernetes.path
  kubernetes_host = "https://kubernetes.default.svc"
}

data "vault_policy_document" "backblaze_exporter" {
  rule {
    path         = "kv/data/fl.a14n.net/production/backblaze-b2-exporter/default"
    capabilities = ["read"]
    description  = "read backblaze-b2-exporter credentials"
  }
}

resource "vault_policy" "backblaze_exporter" {
  name   = "backblaze-exporter"
  policy = data.vault_policy_document.backblaze_exporter.hcl
}

resource "vault_kubernetes_auth_backend_role" "backblaze_exporter" {
  backend                          = vault_auth_backend.kubernetes.path
  role_name                        = "backblaze-exporter"
  bound_service_account_names      = ["backblaze-exporter-vault"]
  bound_service_account_namespaces = ["backblaze-exporter"]
  token_policies                   = [vault_policy.backblaze_exporter.name]
  token_ttl                        = 3600
  token_max_ttl                    = 24 * 3600
}
