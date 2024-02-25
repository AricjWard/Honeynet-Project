# CloudHoneynet

In this project, I personally crafted and brought to life an Azure Cloud Honeynet environment. It's a virtual space that mimics real vulnerable systems, allowing me to actively engage with and learn from live malicious activity. My main goal? To truly grasp the ins and outs of cybersecurity threats and how to handle them in real-time situations. Along the way, I made sure to compare the metrics before and after implementing security measures. This way, I could see firsthand how effective these enhancements were in keeping things safe and secure.
---

<img src='https://github.com/AricjWard/Honeynet-Project/blob/main/Img%20sources/Cloud%20Honeynet.png'>

---

# Methodology 
- <ins>**Azure Infrastructure Setup:**</ins> Deployed an Azure environment consisting of virtual machines, SQL Server, Azure Active Directory, storage accounts, Key Vault, and more.
  
- <ins>**SIEM Integration with Azure Sentinel:**</ins> Utilized Sentinel (SIEM) to monitor and analyze the captured data from various sources and respond to the incidents, all within a central hub.
  
- <ins>**Analytic Rules and Alerts:**</ins> I crafted custom analytic rules using *Kusto Query Language* to detect and trigger specific attack patterns like brute force attempts, manipulation of firewall, identification of malicious files and other potential threats.
  
- <ins>**Threat Mapping with Workbooks:**</ins> Using Azure Sentinel's workbooks, I transformed threat data into maps that outline the origin of attacks. This provides a comprehensive overview of the threat landscape.

- <ins>**Incident Response Simulation:**</ins> Simulated incident response for triggered alerts by analyzing the collected data, identifying attack vectors, and applying appropriate mitigation strategies by developing a sample Playbook based around ***NIST 800-61 - Incident Response*** guidelines.
  
- <ins>**Baseline and Remediation Metric Comparison:**</ins> Observed the environment in its vulnerable state for 24 hours, capturing essential security metrics as a baseline for comparison against the 24-hour metrics of the environment after implementing remediation measures.
    
- <ins>**Regulatory Compliance:**</ins> Ensured regulatory compliance by enabling ***NIST 800-53*** security policy alongside hardening the environment's security posture.

--- 

# Architecture Before Implementing Security Measures

<img src="https://github.com/AricjWard/Honeynet-Project/blob/main/Img%20sources/Public%20INT.jpg" alt = "Initial Architecture diagram" width="480" height="465">  

  
> Initially, resources were intentionally set up for public exposure to attract potential threat actors and stimulate malicious activity. This deployment involved VMs with open Network Security Groups (NSGs) and disabled built-in firewalls, which allowed unrestricted access from any source.  In addition, resources like key vaults and storage accounts were also made publicly accessible, lacking appropriate restrictions or private endpoint security controls.

---  

# Architecture After Implementation of Security Measures

<img src="https://github.com/AricjWard/Honeynet-Project/blob/main/Img%20sources/Public%20INT%202.png" alt = "Initial Architecture diagram" width="510" height="565">

> Here, I enhanced security by implementing strict Network Security Group (NSG) configurations, allowing only authorized traffic from trusted IP addresses. I optimized the built-in firewalls on virtual machines and replaced public endpoints with Private Endpoints for sensitive resources like Key Vaults and Storage Accounts, ensuring limited access within the virtual network.  
> Additionally, I implemented *'SC-7: Boundary Protection controls from NIST 800-53'* to further enhance protection against other threats and adhere to regulatory compliance.

---  

# Visualizing Attacks: Mapping the Source of Attacks
<img src= "https://github.com/AricjWard/Honeynet-Project/blob/main/Img%20sources/(before)%20nsg-malicious-allowed-in.png">

<details>
<summary><h1>🚩Toggle for more maps</h1></summary>
  
 <img src= "https://github.com/AricjWard/Honeynet-Project/blob/main/Img%20sources/(before)%20linx-ssh-auth-fail.png">

<img src= "https://github.com/AricjWard/Honeynet-Project/blob/main/Img%20sources/(before)%20mssql-auth-fail.png">

<img src = "https://github.com/AricjWard/Honeynet-Project/blob/main/Img%20sources/(before)%20windows-rdp-auth-fail.png">

</details>

These maps were crafted by ingesting IP Geolocation databases into Sentinel's watchlist. This data was then used in KQL queries to build custom workbooks, which would ultimately showcase the maps highlighting the countries from which attacks originated.
> Note: The above maps were generated while the environment was in a vulnerable state. 

---

# Metric Comparison of Incidents: 

## Pre-Enhancement :

| **Event type**  | **Count** |
| ------------- | ------------- |
Security Events (Windows VMs) |	21,780
Syslog (Linux VMs) |	4,262
SecurityAlert (Microsoft Defender for Cloud) |	233
SecurityIncident (Sentinel Incidents) |	220
NSG Inbound Malicious Flows Allowed |	2906

## Post-Enhancement :

| **Event type**  | **Count** |
| ------------- | ------------- |
Security Events (Windows VMs) |	8432
Syslog (Linux VMs) |	1
SecurityAlert (Microsoft Defender for Cloud) |	0
SecurityIncident (Sentinel Incidents) |	0
NSG Inbound Malicious Flows Allowed |	0

- The comparison of metrics between the environment's pre- and post-security enhancements over a 24-hour period demonstrates the effectiveness of the implemented security controls, resulting in zero incidents after the  Security Enhancement.
- Some Security Events and Syslog  counts are identified as **false positives** originating from internal systems like NT-Authority.
- Note: The absence of active users on these systems reduces threat visibility. The presence of active users could potentially attract more threats.
---  
## <h1>🌟 Comprehensive Walkthrough</h1> ##
 
<details>
<summary><h1>Azure Components Utilized: </h1></summary>
  
- Virtual Machines (2x Windows, 1x Linux)
- Azure Network Security Group (NSG)
- Azure Virtual Network (VNet)
- Log Analytics Workspace with Kusto Query Language (KQL) Queries
- Azure Key Vault for Secure Secrets Management
- Azure Storage Account for Data Storage
- Microsoft Sentinel for Security Information and Event Management (SIEM)
- Microsoft Defender for Cloud to Protect Cloud Resources
- PowerShell for Automation
- NIST SP 800-61 Revision 2 for Incident Handling Guidance
- NIST SP 800-53 Revision 5 for Security Controls

---  

</details>

<details>
<summary><h1>Phase 1 : Initial Setup </h1></summary>
  
- Create Windows VM
  - Install SQL server and SQL Server Management Studio
  - Enable logs from SQL Server to be ingested to Windows' Event Viewer - [[Reference](https://learn.microsoft.com/en-us/sql/relational-databases/security/auditing/write-sql-server-audit-events-to-the-security-log?view=sql-server-ver16)]
- Create Linux VM
- Create Attacker Windows VM
- Create OPEN (insecure) Network Security Group (NSG) entries
  
<img src= "https://github.com/AricjWard/Honeynet-Project/blob/main/Img%20sources/NSG.png">

---

</details>

<details>
<summary><h1>Phase 2 : Setup Logging and Monitoring</h1></summary>
   
## Log Collection 
- Create Storage account
- Create Log Analytics Workspace (LAW)
- Enable MS Defender for Cloud
- Create flow logs for NSG - (Vnet Traffic analytics)
- Create and configure Data Collection Rule for Win and Linux VMs
- Create another custom rule for Win Firewall and Defender Logs
- Install Log Agents on VMs
- Setup Azure Tenant-level logging (Azure Active Directory logs)
- Setup Azure Subscription level logging (Azure Activity logs)
- Setup Azure Resource-level logging. (Azure Resource Manipulation logs)

## Setup SIEM :
- Download Geo-IP Databases - [[Ref](https://github.com/AndiDittrich/GeoIP-Country-Lists)]
- Create Container and upload Geo-Ip Databases
  
 <img src= "https://github.com/AricjWard/Honeynet-Project/blob/main/Img%20sources/Container.png">

- Create MS Sentinel Watchlists
  
  <img src= "https://github.com/AricjWard/Honeynet-Project/blob/main/Img%20sources/wacthlist.png">

- Create Workbooks to generate [Maps](#visualizing-attacks-mapping-the-source-of-attacks)

- Create MS Sentinel Analytics (Alert Rules)

  <img src= "https://github.com/AricjWard/Honeynet-Project/blob/main/Img%20sources/Analytics.png">

---

</details>

<details>
<summary><h1>Phase 3 : Simulate Attacks and Examine Logs</h1></summary> 
  
 ### Powershell Scripts
 - [AAD_Brute_Force_Simulator](https://github.com/AricjWard/Honeynet-Project/blob/main/PowerShell%20Scripts/AAD_Brute_Force_Simulator.ps1)
 - [SQL-Brute-Force-Simulator](https://github.com/AricjWard/Honeynet-Project/blob/main/PowerShell%20Scripts/SQL-Brute-Force-Simulator.ps1)
 - [EICAR-Malware-Generator](https://github.com/AricjWard/Honeynet-Project/blob/main/PowerShell%20Scripts/EICAR-Malware-Generator.ps1)
   > Note: It's not a malicious malware. EICAR is a test file used to check antivirus softwares. [Read more](https://www.eicar.org/download-anti-malware-testfile)

 ### KQL Query Cheat Sheet 
 > Verify simulated attack logs using KQL queries in Log Analytics Workspace
 - [Windows Security Event Log](https://github.com/AricjWard/Honeynet-Project/blob/main/KQL%20Query%20Cheat%20Sheet/Windows%20Security%20Event%20Log.md)
 - [Linux Syslog](https://github.com/AricjWard/Honeynet-Project/blob/main/KQL%20Query%20Cheat%20Sheet/Linux%20Syslog.md)
 - [Azure Active Directory](https://github.com/AricjWard/Honeynet-Project/blob/main/KQL%20Query%20Cheat%20Sheet/Azure%20Active%20Directory.md)
 - [Azure Storage Account](https://github.com/AricjWard/Honeynet-Project/blob/main/KQL%20Query%20Cheat%20Sheet/Azure%20Storage%20Account.md)
 - [Azure Key Vault](https://github.com/AricjWard/Honeynet-Project/blob/main/KQL%20Query%20Cheat%20Sheet/Azure%20Key%20Vault%20Queries.md)
 - [Network Security Groups](https://github.com/AricjWard/Honeynet-Project/blob/main/KQL%20Query%20Cheat%20Sheet/Network%20Security%20Groups.md)


> Note: AI and the internet were utilized to a moderate extent for the creation of above scripts and queries.

---

</details>

<details>
<summary><h1>Phase 4 :  Incident Response</h1></summary> 
 
<img src ="https://github.com/AricjWard/Honeynet-Project/blob/main/Img%20sources/NIST%20IRC.jpg">

- **Preparation :** Centralizing logs, crafting analytics by ingesting logs from varied systems.
- **Detection and Analysis :** Utilizing MS Sentinel to prompt alerts and initiate investigation.
- **Containment, Eradication, and Recovery :** Applying playbook-guided response as needed.
- **Post-Incident Activity :** Thoroughly documenting investigation findings for future reference.

---

## IR Sample Playbook :
<img src = "https://github.com/AricjWard/Honeynet-Project/blob/main/Img%20sources/IR%20Playbook%20TBC.png">
<img src = "https://github.com/AricjWard/Honeynet-Project/blob/main/Img%20sources/IR%20EXAMPLE.png" >
<img src = "https://github.com/AricjWard/Honeynet-Project/blob/main/Img%20sources/IR%20EXAMPLE%202.png">

## Triggered Alerts (Incidents) :
<img src = "https://github.com/AricjWard/Honeynet-Project/blob/main/Img%20sources/MS%20Incidents.png">  

---

</details>

<details>
<summary><h1>Phase 5 :  Security Enhancements</h1></summary> 

- Restrict public exposure of resources - [[IMG](#architecture-after-implementation-of-security-measures)]
  - Disable public access
  - Create Private endpoint access
- Implement secure NSG configuration
  - Delete wide open all traffic NSG entry
  - Allow RDP from specific host     
- Deploy NSG on subnet
- Fulfill *NIST 800-53 R5 - Boundary Protection*


---

</details>

</details>

### ↑ Toggle for Environment Setup, SIEM Configuration, KQL Queries, NIST-IR Utilization, and Other Details 

---

# Conclusion
The **CloudHoneynet project** project was a hands-on journey into the world of cybersecurity, offering real-world applications of protective techniques. Building an Azure-based environment that mimicked vulnerable systems, I delved into actual malicious traffic, gaining invaluable insights into vulnerabilities, threats, and how to respond to incidents. Working with tools like **Azure Sentinel** and crafting **Kusto Query Language** queries, while following **NIST** guidelines, not only honed my skills but also deepened my understanding of practical security measures. Every day, I push myself to learn more, and this project is just one example of my ongoing quest for knowledge and growth in this field.
