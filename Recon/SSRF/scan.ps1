# Check if ffuf is installed
if (!(Test-Path "$env:ProgramFiles\ffuf\ffuf.exe")) {
    # Download ffuf from GitHub releases if it is not installed
    $url = "https://github.com/ffuf/ffuf/releases/download/v1.3.1/ffuf_1.3.1_windows_amd64.zip"
    $output = "$env:TEMP\ffuf.zip"
    Invoke-WebRequest -Uri $url -OutFile $output
    # Extract ffuf to Program Files
    $shell = New-Object -ComObject Shell.Application
    $zip = $shell.NameSpace($output)
    $destination = $shell.NameSpace("$env:ProgramFiles\ffuf")
    foreach($item in $zip.Items()) {
      $destination.CopyHere($item)
    }
  }
  
  # Read the list of URLs
  $urls = Get-Content -Path 'C:\path\to\urls.txt'
  
  # Scan each URL
  foreach ($url in $urls) {
    # Create a batch file with the ffuf command
    $batchFile = "$env:TEMP\ssrf-scan.bat"
    "ffuf -u '$url' -H 'X-Forwarded-For: FUZZ' -H 'X-Forwarded-Host: FUZZ' -H 'X-Forwarded-Server: FUZZ' -w 'C:\path\to\wordlist.txt' -o 'C:\path\to\output-$($url.Replace('/','')).txt' -t 20 > nul" | Out-File $batchFile
  
    # Run the batch file
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c `"$batchFile`"" -Wait
  
    # Read the output file and search for SSRF vulnerabilities
    $output = Get-Content -Path "C:\path\to\output-$($url.Replace('/','')).txt"
    $vulnerabilities = Select-String -InputObject $output -Pattern 'ssrf' -AllMatches
  
    # Print the vulnerabilities
    $vulnerabilities.Matches | Select-Object -ExpandProperty Value
  }
  
