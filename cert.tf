resource "vault_auth_backend" "cert" {
  path = "cert"
  type = "cert"
}

resource "vault_cert_auth_backend_role" "node" {
  name        = "node"
  certificate = file("ca.pem")
  backend     = vault_auth_backend.cert.path
  # Deprecated, delete this
  allowed_names = [
    "node-a.lab.internal",
    "node-a",
    "node-b.lab.internal",
    "node-b",
    "node-c.lab.internal",
    "node-c",
    "qemu01",
    "qemu01.lan.internal",
    "localhost",
    "navi",
  ]
  allowed_common_names = [
    "node-a.lab.internal",
    "node-a",
    "node-b",
    "node-b.lab.internal",
    "node-c.lab.internal",
    "node-c",
    "qemu01.lan.internal",
    "qemu01",
    "localhost",
    "navi",
  ]
  token_ttl      = 600
  token_max_ttl  = 900
  token_policies = ["k8s-server"]
}

resource "vault_cert_auth_backend_role" "node_k3s" {
  name = "k3s"
  # This CA file should include both intermediate and the root
  # certs. I think this is because ingress-nginx strips the
  # intermediate when included by the client. If vault
  # termindates its own TLS, this might work.
  certificate = file("smallstep-ca.pem")
  backend     = vault_auth_backend.cert.path
  allowed_dns_sans = [
    "node-a.lab.internal",
    "node-b.lab.internal",
    "node-c.lab.internal",
    "navi.lan.internal",
  ]
  token_ttl      = 600
  token_max_ttl  = 900
  token_policies = ["k8s-server"]
}
