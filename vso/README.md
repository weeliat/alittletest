---
Vault Setup (one-time)

First, configure the database secrets engine and a static role in Vault:

# Enable database secrets engine
vault secrets enable database

# Configure the PostgreSQL connection
vault write database/config/my-postgresql-database \
  plugin_name=postgresql-database-plugin \
  allowed_roles="my-static-role" \
  connection_url="postgresql://{{username}}:{{password}}@postgres.default.svc.cluster.local:5432/mydb" \
  username="vaultadmin" \
  password="adminpassword"

# Create a static role (Vault manages password rotation)
vault write database/static-roles/my-static-role \
  db_name="my-postgresql-database" \
  username="staticuser" \
  rotation_period="1h"

# Verify you can read static creds
vault read database/static-creds/my-static-role

Grant the Kubernetes auth role access to read static creds:

vault policy write vso-db-policy - <<EOF
path "database/static-creds/my-static-role" {
  capabilities = ["read"]
}
EOF

vault write auth/kubernetes/role/vso-db-role \
  bound_service_account_names=default \
  bound_service_account_namespaces=vso-example \
  policies=vso-db-policy \
  ttl=24h
