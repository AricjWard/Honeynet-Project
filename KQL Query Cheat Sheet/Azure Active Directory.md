# Azure Active Directory

```
// Azure Active Directory Brute Force Success 
let FailedLogons = SigninLogs
| where Status.failureReason == "Invalid username or password or Invalid on-premise username or password."
| where TimeGenerated > ago(1h)
| project TimeGenerated, Status = Status.failureReason, UserPrincipalName, UserId, UserDisplayName, AppDisplayName, AttackerIP = IPAddress, IPAddressFromResourceProvider, City = LocationDetails.city, State = LocationDetails.state, Country = LocationDetails.country, Latitude = LocationDetails.geoCoordinates.latitude, Longitude = LocationDetails.geoCoordinates.longitude
| summarize FailureCount = count() by AttackerIP, UserPrincipalName;
let SuccessfulLogons = SigninLogs
| where Status.errorCode == 0
| where TimeGenerated > ago(1h)
| project TimeGenerated, Status = Status.errorCode, UserPrincipalName, UserId, UserDisplayName, AppDisplayName, AttackerIP = IPAddress, IPAddressFromResourceProvider, City = LocationDetails.city, State = LocationDetails.state, Country = LocationDetails.country, Latitude = LocationDetails.geoCoordinates.latitude, Longitude = LocationDetails.geoCoordinates.longitude
| summarize SuccessCount = count() by AuthenticationSuccessTime = TimeGenerated, AttackerIP, UserPrincipalName, UserId, UserDisplayName;
let BruteForceSuccesses = SuccessfulLogons
| join kind = leftouter FailedLogons on AttackerIP, UserPrincipalName;
BruteForceSuccesses
| project AttackerIP, TargetAccount = UserPrincipalName, UserId, FailureCount, SuccessCount, AuthenticationSuccessTime
```

```
// Excessive password Resets: Possible Lateral Movement
AuditLogs
| where OperationName startswith "Change" or OperationName startswith "Reset"
| order by TimeGenerated
| summarize count() by tostring(InitiatedBy)
| project Count = count_, InitiatorId = parse_json(InitiatedBy).user.id, InitiatorUpn = parse_json(InitiatedBy).user.userPrincipalName, InitiatorIpAddress = parse_json(InitiatedBy).user.ipAddress
| where Count >= 10
```
