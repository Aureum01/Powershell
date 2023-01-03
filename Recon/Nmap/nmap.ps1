# Check if an IP address was passed as an argument
if ([string]::IsNullOrEmpty($args[0])) {
    Write-Output "Usage: .\recon.ps1 <IP>"
    exit 1
}

$ip = $args[0]

# Run Nmap and append the results to the results file
Write-Output "Running Nmap..."
& nmap $ip | Select-Object -Skip 4 | Select-Object -SkipLast 2 | Out-File -Append results

# Read the results file line by line
Get-Content results | ForEach-Object {
    # If the line indicates an open HTTP port, run Gobuster and WhatWeb
    if ($_ -like "*open*" -and $_ -like "*http*") {
        Write-Output "Running Gobuster..."
        & gobuster dir -u $ip -w '/usr/share/wordlists/dirb/common.txt' -qz > temp1

        Write-Output "Running WhatWeb..."
        & whatweb $ip -v > temp2
    }
}

# If the Gobuster results file exists, append it to the results file
if (Test-Path temp1) {
    Write-Output "----- DIRS -----" | Out-File -Append results
    Get-Content temp1 | Out-File -Append results
    Remove-Item temp1
}

# If the WhatWeb results file exists, append it to the results file
if (Test-Path temp2) {
    Write-Output "----- WEB -----" | Out-File -Append results
    Get-Content temp2 | Out-File -Append results
    Remove-Item temp2
}

# Output the final results
Get-Content results
