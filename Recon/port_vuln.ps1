# Set the desired options
$nmapOptions = @{
    'Verbose' = $true
    'TopPorts' = 1000
    'ServiceInfo' = $true
    'OSDetection' = $true
}

$exploitDBOptions = @{
    'Verbose' = $true
    'Output' = "csv"
}

# Set the target IP address
$ip = "192.168.1.100"

# Scan the target for open ports and service information
try {
    $ports = Invoke-NmapScan @nmapOptions -Target $ip
} catch {
    Write-Error "Error running Nmap: $($_.Exception.Message)"
}

# Check each open port for vulnerabilities
foreach ($port in $ports) {
    # Search the ExploitDB database for exploits targeting the current port
    try {
        $exploits = Search-ExploitDB @exploitDBOptions -Port $port.Number
    } catch {
        Write-Error "Error searching ExploitDB: $($_.Exception.Message)"
    }

    # Output the vulnerabilities found for the current port
    if ($exploits.Count -gt 0) {
        Write-Output "Vulnerabilities found for port $($port.Number) ($($port.ServiceName)):"
        foreach ($exploit in $exploits) {
            Write-Output "  - $($exploit.Description)"
        }
    }
}

# Output the detected operating system
Write-Output "Operating system detected: $($ports[0].OS.Name)"
