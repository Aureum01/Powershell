# Install sqlmap if it is not already installed
$sqlmapPath = "$env:LOCALAPPDATA\sqlmap\sqlmap.py"
if (!(Test-Path $sqlmapPath)) {
  # Download and extract sqlmap
  $url = "https://github.com/sqlmapproject/sqlmap/archive/1.4.7.zip"
  $zip = "$env:TEMP\sqlmap.zip"
  $destination = "$env:LOCALAPPDATA\sqlmap"
  Invoke-WebRequest -Uri $url -OutFile $zip
  Expand-Archive -Path $zip -DestinationPath $destination
}

# Set the URL to test
$url = 'http://example.com/vulnerable-page?id=1'

# Set the POST data (if any)
$data = 'param1=value1&param2=value2'

# Build the sqlmap command
$command = "$sqlmapPath -u $url --batch --dbs --threads=10"
if ($data) {
  $command += " --data='$data'"
}

# Run the sqlmap command
$output = & python $command

# Check if the output indicates a SQL injection vulnerability was found
if ($output -match 'possible') {
  Write-Output "SQL injection vulnerability found!"
}
elseif ($output -match 'unable') {
  Write-Error "Error: unable to connect to the target URL"
}
else {
  Write-Output "No SQL injection vulnerability found"
}
