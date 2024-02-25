# AAD-BruteForce-Simulator
# This script fails to login '$max_attempts' times, and then successfully logs in once

# Authenticate user against Azure AD
$tenantId = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx" # Azure Tenant ID
$username = "User@mmunr44gmail.onmicrosoft.com" # Legit user in AAD
$correct_password = "Cyberlab123!" # Enter the correct password for the above user
$wrong_password = "BOGUS PASSWORD" # This is used to generate failure attempts
$max_attempts = 11 # This is the number of times to fail the login before successful authentication

# Disconnect from AAD if already connected; we want to try to authenticate
if ((Get-AzContext) -eq $true) {
    Disconnect-AzAccount
}

# This section will fail '$max_attempts' logon attempts against Azure AD user
$count = 0

while ($count -le $max_attempts) {
    Start-Sleep -Seconds 1
    $count++
    try {
        $securePassword = ConvertTo-SecureString $wrong_password -AsPlainText -Force
        $cred = New-Object System.Management.Automation.PSCredential ($username, $securePassword)
        Connect-AzAccount -TenantId $tenantId -Credential $cred -ErrorAction SilentlyContinue
        Write-Host "Login attempt: ($($count))"
    }
    catch {
        Write-Host "Login Failure. ($($count))"
        $Error[0].Exception.Message
    }
}

# This section will successfully authenticate against AAD, simulating a successful brute force attack
$securePassword = ConvertTo-SecureString $correct_password -AsPlainText -Force
$cred = New-Object System.Management.Automation.PSCredential ($username, $securePassword)
Connect-AzAccount -TenantId $tenantId -Credential $cred -ErrorAction SilentlyContinue