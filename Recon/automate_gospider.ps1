# Set the desired options
$options = @{
    'FastCrawling' = $true
    'BruteForceSitemap' = $true
    'ParseRobots' = $true
    'LinkFinder' = $true
    'AWS' = $true
    'Subdomains' = $true
    'Wayback' = $true
    'CommonCrawl' = $true
    'VirusTotal' = $true
    'AlienVault' = $true
    'Grep' = $true
    'BurpInput' = $true
    'Parallel' = $true
    'RandomAgent' = $true
    'Verbose' = $true
    'UserAgent' = "MyCustomUserAgent"
    'Output' = "csv"
    'Wordlist' = "C:\wordlist.txt"
}

# Set the target URL
$url = "http://example.com"

# Run GoSpider with the specified options
try {
    & GoSpider @options -u $url
} catch {
    Write-Error "Error running GoSpider: $($_.Exception.Message)"
}
