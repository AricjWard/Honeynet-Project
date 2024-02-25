# Linux Syslog

```
// Linux Brute Force Attempt 
let IpAddress_REGEX_PATTERN = @"\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b";
Syslog
| where Facility == "auth" and SyslogMessage startswith "Failed password for"
| where TimeGenerated > ago(1h)
| project TimeGenerated, AttackerIP = extract(IpAddress_REGEX_PATTERN, 0, SyslogMessage), DestinationHostName = HostName, DestinationIP = HostIP, Facility, SyslogMessage, ProcessName, SeverityLevel, Type
| summarize FailureCount = count() by AttackerIP, DestinationHostName, DestinationIP
| where FailureCount >= 5
```

```
// Linux Brute Force Success 
let FailedLogons = Syslog
| where Facility == "auth" and SyslogMessage startswith "Failed password for"
| where TimeGenerated > ago(1h)
| project TimeGenerated, SourceIP = extract(@"\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b", 0, SyslogMessage), DestinationHostName = HostName, DestinationIP = HostIP, Facility, SyslogMessage, ProcessName, SeverityLevel, Type
| summarize FailureCount = count() by AttackerIP = SourceIP, DestinationHostName
| where FailureCount >= 5;
let SuccessfulLogons = Syslog
| where Facility == "auth" and SyslogMessage startswith "Accepted password for"
| where TimeGenerated > ago(1h)
| project TimeGenerated, SourceIP = extract(@"\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b", 0, SyslogMessage), DestinationHostName = HostName, DestinationIP = HostIP, Facility, SyslogMessage, ProcessName, SeverityLevel, Type
| summarize SuccessfulCount = count() by SuccessTime = TimeGenerated, AttackerIP = SourceIP, DestinationHostName
| where SuccessfulCount >= 1
| project DestinationHostName, SuccessfulCount, AttackerIP, SuccessTime;
let BruteForceSuccesses = SuccessfulLogons
| join kind = leftouter FailedLogons on AttackerIP, DestinationHostName;
BruteForceSuccesses
```

```
// Queries the linux syslog for any user accounts created
Syslog
| where Facility == "authpriv" and SeverityLevel == "info"
| where SyslogMessage contains "new user" and SyslogMessage contains "shell=/bin/bash"
| project TimeGenerated, HostIP, HostName, ProcessID, SyslogMessage
```

```
// Queries for any users given sudo privileges
Syslog
| where Facility == "authpriv" and SeverityLevel == "info"
| where SyslogMessage contains "to group 'sudo'"
| project TimeGenerated, HostIP, Computer, ProcessID, SyslogMessage
```
