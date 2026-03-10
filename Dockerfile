FROM hashicorp/vault-enterprise:latest

# Switch to root to update system certificates
USER root

# Copy the custom Root CA certificate
COPY my-root-ca.crt /usr/local/share/ca-certificates/

# Install the ca-certificates package and update the trust store
RUN apk --no-cache add ca-certificates && \
    update-ca-certificates

# Revert to the vault user for security
USER vault
