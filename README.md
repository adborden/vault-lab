# vault terraform

Manage vault configuration as code.

## Features

- ssh certificate authority
- k3s secret key store
- pki for lab
- CA authentication for node bootstrap

## Usage

Get a [token for vault](#vault-tokens).

## Vault tokens

Login using the userpass method:

```bash
vault login -address=https://vault.fl.a14n.net -method=userpass username=adborden password=<password>
```

Or from password manager:

```bash
eval "$(pass vault/fl.a14n.net/adborden)"
```

## Application secrets

Applications in the lab cluster read secrets from the `kv` (KV v2) mount
using [Kubernetes auth](kubernetes.tf). Each application gets a policy
granting read on its secret path and a role bound to its service account.

Secret values are not managed by terraform; write them with the vault CLI
after getting a [token](#vault-tokens).

```bash
export VAULT_ADDR=https://vault.fl.a14n.net
```

### backblaze-b2-exporter

Path: `kv/fl.a14n.net/production/backblaze-b2-exporter/default`, readable
by the `backblaze-exporter` service account in the `backblaze-exporter`
namespace (role `backblaze-exporter`).

Create a read-only application key in Backblaze B2, then write it. The key is
read from stdin (`-`) so it doesn't end up in shell history or `ps` output:

```bash
read -rsp 'B2 application id: ' B2_APP_ID
read -rsp 'B2 application key: ' B2_APP_KEY
vault kv put -mount=kv \
  fl.a14n.net/production/backblaze-b2-exporter/default \
  application_key_id="$B2_APP_ID" \
  application_key="$B2_APP_KEY"
unset B2_APP_KEY B2_APP_ID
```

To rotate a single field without rewriting the others, use `vault kv patch`
with the same arguments.

Verify the secret was written (`-field` prints only the key ID, not the
application key):

```bash
vault kv get -mount=kv -field=application_key_id \
  fl.a14n.net/production/backblaze-b2-exporter/default
```

## SSH certificates

## k3s secrets

## PKI for lab
