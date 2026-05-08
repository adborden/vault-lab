# Read system health check
path "sys/health" {
  capabilities = ["read", "sudo"]
}

# Create and manage ACL policies
path "sys/policies/acl" {
  capabilities = ["list"]
}

path "sys/policies/acl/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Enable and manage mounts
path "sys/mounts/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Enable and manage authentication methods
path "auth/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Enable and manage identity
path "identity/*" {
  capabilities = ["create", "read", "update", "delete", "list", "sudo"]
}

# Manage Key-Value secrets engine
path "secret/*" {
  capabilities = ["create", "read", "update", "delete", "list"]
}

# Root
path "*" {
  capabilities = ["create", "read", "update", "patch", "delete", "list", "sudo"]
}
