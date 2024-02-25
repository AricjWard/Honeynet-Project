# Azure Key Vault

```
// List out Secrets
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.KEYVAULT"
| where OperationName == "SecretList"
```

```
// Attempt to view passwords
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.KEYVAULT"
| where OperationName == "SecretGet"
```

```
// Viewing a specific user's password
let CRITICAL_PASSWORD_NAME = "Tenant-Global-Admin-Password";
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.KEYVAULT"
| where OperationName == "SecretGet"
| where id_s contains CRITICAL_PASSWORD_NAME
```

```
// Successfully updating a specific user's password 
let CRITICAL_PASSWORD_NAME = "Tenant-Global-Admin-Password";
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.KEYVAULT"
| where OperationName == "SecretSet"
| where id_s endswith CRITICAL_PASSWORD_NAME
| where TimeGenerated > ago(2h)
```

```
// Updating a specific user's secret in Key Vault
let CRITICAL_PASSWORD_NAME = "Tenant-Global-Admin-Password";
AzureDiagnostics
| where ResourceProvider == "MICROSOFT.KEYVAULT"
| where OperationName == "SecretSet"
| where id_s endswith CRITICAL_PASSWORD_NAME
```
