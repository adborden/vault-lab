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
