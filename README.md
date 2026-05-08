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
