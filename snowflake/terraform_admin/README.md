### Generating RSA Key Pair for Snowflake Authentication

This section explains how to generate an RSA private key and its corresponding public key for use in Snowflake authentication. The RSA key pair is required to enable secure, key-based authentication for the `terraform_user` created in the Snowflake setup script.

---

### **Steps to Generate the RSA Key Pair**

#### **Step 1: Generate the RSA Private Key**
Run the following command to generate a 2048-bit RSA private key in PKCS#8 format:

```bash
openssl genrsa 2048 | openssl pkcs8 -topk8 -inform PEM -out sf_tf_user_private_key.p8 -nocrypt
```

- **`openssl genrsa 2048`**: Generates a 2048-bit RSA private key.
- **`|`**: Pipes the output of the private key generation to the next command.
- **`openssl pkcs8 -topk8 -inform PEM -out sf_tf_user_private_key.p8 -nocrypt`**:
  - Converts the RSA private key to PKCS#8 format, which is required by Snowflake.
  - **`-inform PEM`**: Specifies that the input format is PEM (Privacy-Enhanced Mail).
  - **`-out sf_tf_user_private_key.p8`**: Saves the private key to a file named `sf_tf_user_private_key.p8`.
  - **`-nocrypt`**: Ensures the private key is not encrypted with a passphrase, which is necessary for automation.

This command creates the private key file `sf_tf_user_private_key.p8`.

---

#### **Step 2: Generate the RSA Public Key**
Run the following command to extract the public key from the private key:

```bash
openssl rsa -in sf_tf_user_private_key.p8 -pubout -out sf_tf_user_public_key.pub
```

- **`openssl rsa -in sf_tf_user_private_key.p8`**: Reads the private key from the file `sf_tf_user_private_key.p8`.
- **`-pubout`**: Extracts the public key from the private key.
- **`-out sf_tf_user_public_key.pub`**: Saves the public key to a file named `sf_tf_user_public_key.pub`.

This command creates the public key file `sf_tf_user_public_key.pub`.

---

### **Next Steps**

#### **Step 3: Set the RSA Public Key in Snowflake**
1. Open the `sf_tf_user_public_key.pub` file and copy its contents (excluding the `BEGIN` and `END` lines).
2. Replace the placeholder in the SQL script with the actual public key:
   ```sql
   ALTER USER terraform_user
     SET RSA_PUBLIC_KEY = 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A...';
   ```

#### **Step 4: Secure the Private Key**
1. Ensure the private key file `sf_tf_user_private_key.p8` is stored securely and accessible only to authorized users or processes.
2. Set appropriate file permissions:
   ```bash
   chmod 600 sf_tf_user_private_key.p8
   ```

#### **Step 5: Test Authentication**
1. Use the private key to authenticate the `terraform_user` in Snowflake.
2. Verify that Terraform can manage Snowflake resources using the configured user and role.

---

### **Key Notes**
- The private key (`sf_tf_user_private_key.p8`) must remain confidential and should not be shared.
- The public key (`sf_tf_user_public_key.pub`) is safe to share and is used to configure the Snowflake user.
- This setup ensures secure, key-based authentication for Terraform automation in Snowflake.


### Overview of the Snowflake Terraform Setup Script

This SQL script is designed to set up a dedicated user and role in Snowflake for Terraform automation. It ensures that Terraform has the necessary permissions to manage Snowflake resources while adhering to the principle of least privilege. Below is a detailed breakdown of the script:

---

### **Purpose**
- **Automate Snowflake Resource Management**: The script creates a service account and role specifically for Terraform, enabling it to manage Snowflake resources programmatically.
- **Minimal Privileges**: Grants only the required permissions to the Terraform role to ensure security and compliance.

---

### **Steps in the Script**

#### **Step 1: Create a Custom Role**
```sql
CREATE ROLE IF NOT EXISTS TERRAFORM_ADMIN;
```
- Creates a custom role named `TERRAFORM_ADMIN` if it does not already exist.
- This role will be used to manage Snowflake resources on behalf of Terraform.

---

#### **Step 2: Create a Service User**
```sql
CREATE USER IF NOT EXISTS terraform_user
  DEFAULT_ROLE = TERRAFORM_ADMIN
  MUST_CHANGE_PASSWORD = FALSE
  COMMENT = 'Service account for Terraform automation';
```
- Creates a service user named `terraform_user` if it does not already exist.
- Assigns the `TERRAFORM_ADMIN` role as the default role for this user.
- Disables the requirement to change the password, as this user will authenticate using an RSA key.
- Adds a comment for documentation purposes.

---

#### **Step 3: Grant the Role to the User**
```sql
GRANT ROLE TERRAFORM_ADMIN TO USER terraform_user;
```
- Assigns the `TERRAFORM_ADMIN` role to the `terraform_user`.
- This allows the user to perform actions permitted by the role.

---

#### **Step 4: Assign Privileges to the Role**
The script grants the following account-level privileges to the `TERRAFORM_ADMIN` role:

1. **Database Management**:
   ```sql
   GRANT CREATE DATABASE ON ACCOUNT TO ROLE TERRAFORM_ADMIN;
   ```
   - Allows the role to create and manage databases.

2. **Warehouse Management**:
   ```sql
   GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE TERRAFORM_ADMIN;
   ```
   - Allows the role to create and manage warehouses.

3. **User Management**:
   ```sql
   GRANT CREATE USER ON ACCOUNT TO ROLE TERRAFORM_ADMIN;
   ```
   - Allows the role to create and manage users.

4. **Role Management**:
   ```sql
   GRANT CREATE ROLE ON ACCOUNT TO ROLE TERRAFORM_ADMIN;
   ```
   - Allows the role to create and manage roles.

5. **Grant Management**:
   ```sql
   GRANT MANAGE GRANTS ON ACCOUNT TO ROLE TERRAFORM_ADMIN;
   ```
   - Allows the role to manage grants on the account.

6. **Integration Creation (Optional)**:
   ```sql
   GRANT CREATE INTEGRATION ON ACCOUNT TO ROLE TERRAFORM_ADMIN;
   ```
   - Optionally allows the role to create integrations, such as storage integrations or external stages.

---

#### **Step 5: Set RSA Public Key for Authentication**
```sql
ALTER USER terraform_user
  SET RSA_PUBLIC_KEY = 'MIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8A...';
```
- Configures the `terraform_user` to use RSA private key authentication.
- The public key must be provided here, replacing the placeholder (`'...'`).
- This step is manual and requires the actual RSA public key content (without `BEGIN/END` lines).

---

### **Completion**
```sql
-- Terraform user and role setup complete
-- You can now authenticate using the RSA private key
```
- After completing the script, the `terraform_user` can authenticate using the corresponding RSA private key.
- Terraform can now use this user and role to manage Snowflake resources programmatically.

---

### **Key Benefits**
1. **Automation-Ready**: Prepares Snowflake for Terraform automation with minimal manual intervention.
2. **Security**: Uses RSA key-based authentication for secure access.
3. **Granular Permissions**: Grants only the necessary privileges to the `TERRAFORM_ADMIN` role, reducing the risk of over-permissioning.
4. **Reusability**: The script can be reused in other environments with minimal modifications.

---

### **Next Steps**
1. Replace the placeholder RSA public key with the actual public key.
2. Test the setup by authenticating with the `terraform_user` and running Terraform scripts to manage Snowflake resources.