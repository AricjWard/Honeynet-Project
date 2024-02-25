# Azure Storage Account

```
// Reading the files
StorageBlobLogs
| where OperationName == "GetBlob"
```

```
//Deleting the files
StorageBlobLogs | where OperationName == "DeleteBlob"
| where TimeGenerated > ago(24h)
```

```
//Uploading the files
StorageBlobLogs | where OperationName == "PutBlob"
| where TimeGenerated > ago(24h)
```

```
//Copying the files
StorageBlobLogs | where OperationName == "CopyBlob"
| where TimeGenerated > ago(24h)
```
