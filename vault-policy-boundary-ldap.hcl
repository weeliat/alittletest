# =============================================================
# Vault Policy: Boundary Credential Store — LDAP Static Role
# Token type: orphan (created with vault token create -orphan)
# =============================================================

# Read static credentials for RDP accounts
path "ldap/static-creds/rdp-static-role" {
  capabilities = ["read"]
}

# Renew credentials leases issued by the LDAP secrets engine
path "sys/leases/renew" {
  capabilities = ["update"]
}

# Allow Boundary to renew its own orphan token before expiry
path "auth/token/renew-self" {
  capabilities = ["update"]
}

# Allow Boundary to verify the token is still valid on startup
path "auth/token/lookup-self" {
  capabilities = ["read"]
}
