-- ===========================================
-- Snowflake Terraform Setup Script
-- Creates a dedicated user and role for Terraform automation
-- Grants minimal required privileges for managing Snowflake resources
-- ===========================================

-- Step 1: Create a custom role for Terraform
CREATE ROLE IF NOT EXISTS TERRAFORM_ADMIN;

-- Step 2: Create a service user for Terraform
-- Note: Replace 'terraform_user' with your desired username
CREATE USER IF NOT EXISTS terraform_user
  DEFAULT_ROLE = TERRAFORM_ADMIN
  MUST_CHANGE_PASSWORD = FALSE
  COMMENT = 'Service account for Terraform automation';

-- Step 3: Grant the custom role to the Terraform user
GRANT ROLE TERRAFORM_ADMIN TO USER terraform_user;

-- Step 4: Assign the role required privileges at the account level

-- Allow creating and managing databases
GRANT CREATE DATABASE ON ACCOUNT TO ROLE TERRAFORM_ADMIN;


-- Allow creating and managing warehouses
GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE TERRAFORM_ADMIN;

-- Allow creating and managing users
GRANT CREATE USER ON ACCOUNT TO ROLE TERRAFORM_ADMIN;

-- Allow creating and managing roles
GRANT CREATE ROLE ON ACCOUNT TO ROLE TERRAFORM_ADMIN;

-- Allow the role to manage grants
GRANT MANAGE GRANTS ON ACCOUNT TO ROLE TERRAFORM_ADMIN;


-- Optional: Allow the role to create integrations (for storage, external stages, etc.)
GRANT CREATE INTEGRATION ON ACCOUNT TO ROLE TERRAFORM_ADMIN;

-- Step 5: [Manual] Set the RSA public key for private key authentication
-- Replace the value below with the actual public key content (no BEGIN/END lines)
-- Example only; you must replace 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A...' with your key.

ALTER USER terraform_user
  SET RSA_PUBLIC_KEY = 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAsYkTesPRe34wsmUZiR10
m4QfkJKD23PeMGE2pjqjKz9MKAdZs/wd+w8ladjltWgEaYw+5WhtgybTe3p/wf0l
gI8hEtjjXQ/AAxziASFnnOcaHCn9e91K5LhKlrn19FlKrUYm9Ztkp9uEPYblqLMV
FCi94ufNtpvWuvHD4gzfaUtTxTzTGkMZm/7xy2gdfg4mOE1u+AV06w47L0PIBjGk
hVkWi2rgsosEKO+t46ircTyQVSks1rRZv3ZMfOLWDLHX5HW5mXSF4Nz7jRgCblUP
pXlR78r7nA9nilVBMqLzFLeaMhVWJVDc+PK6wwvd7DXBAwJon4mWqiQ/PJoZ20i6
OwIDAQAB
';

-- ===========================================
-- Terraform user and role setup complete
-- You can now authenticate using the RSA private key
-- ===========================================
