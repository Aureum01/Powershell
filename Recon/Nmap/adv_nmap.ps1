# Check if an IP address was passed as an argument
if ([string]::IsNullOrEmpty($args[0])) {
    Write-Output "Usage: .\recon.ps1 <IP>"
    exit 1
}

$ip = $args[0]

# Create the results file
New-Item -ItemType File -Path results -Force | Out-Null

# Run Nmap and append the results to the results file
try {
    Write-Output "Running Nmap..."
    & nmap $ip | Select-Object -Skip 4 | Select-Object -SkipLast 2 | Out-File -Append results
} catch {
    Write-Error "Error running Nmap: $($_.Exception.Message)"
    exit 1
}

# Read the results file line by line
Get-Content results | ForEach-Object {
    # If the line indicates an open HTTP port, run Gobuster and WhatWeb
    if ($_ -like "*open*" -and $_ -like "*http*") {
        # Run Gobuster
        try {
            Write-Output "Running Gobuster..."
            & gobuster dir -u $ip -w '/usr/share/wordlists/dirb/common.txt' -qz > temp1
        } catch {
            Write-Error "Error running Gobuster: $($_.Exception.Message)"
            exit 1
        }

        # Run WhatWeb
        try {
            Write-Output "Running WhatWeb..."
            & whatweb $ip -v > temp2
        } catch {
            Write-Error "Error running WhatWeb: $($_.Exception.Message)"
            exit 1
        }
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
