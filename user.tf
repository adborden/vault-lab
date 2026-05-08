resource "vault_auth_backend" "userpass" {
  type = "userpass"

  tune {
    max_lease_ttl = "12h"
  }
}

resource "vault_identity_entity" "adborden" {
  name     = "adborden"
  policies = ["admin"]
  metadata = {
    foo = "bar"
  }
}

resource "vault_identity_mfa_totp" "default" {
  issuer = "default"
}
