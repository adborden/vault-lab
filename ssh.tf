resource "vault_mount" "home" {
  type = "ssh"
  path = "home"
}

resource "vault_ssh_secret_backend_ca" "home" {
  backend              = vault_mount.home.path
  generate_signing_key = true
}

resource "vault_ssh_secret_backend_role" "admin" {
  name                    = "admin"
  backend                 = vault_mount.home.path
  key_type                = "ca"
  allow_user_certificates = true
  allowed_users           = "adborden, core, ubuntu"
  max_ttl                 = 3600 * 24 * 365 # 1 year
  allowed_extensions = join(",", [
    "permit-pty",
    "permit-port-forwarding",
    "permit-agent-forwarding",
    "permit-user-rc",
    "verify-required",
  ])
  default_extensions = {
    "permit-pty"              = ""
    "permit-port-forwarding"  = ""
    "permit-agent-forwarding" = ""
    "permit-user-rc"          = ""
  }
}
