Function Scan-Xss {
  param(
    [Parameter(Mandatory=$true)]
    [string] $Url
  )

  try {
    # Send an HTTP request to the website with a payload designed to trigger an XSS flaw
    $html = Invoke-WebRequest -Uri "$Url?param=<script>alert('XSS')</script>" -ErrorAction Stop

    # Search the HTML source code for the payload
    if ($html.Content -match "<script>alert\('XSS'\)</script>") {
      "XSS flaw found"
    } else {
      "No XSS flaw found"
    }
  } catch {
    # If an error occurs while sending the HTTP request, return an error message
    "Error: $($_.Exception.Message)"
  }
}

Function Analyze-XssParameters {
  param(
    [Parameter(Mandatory=$true)]
    [string] $Url
  )

  try {
    # Send an HTTP request to the website and retrieve its HTML source code
    $html = Invoke-WebRequest -Uri $Url -ErrorAction Stop

    # Search the HTML source code for form parameters that may be vulnerable to XSS
    $params = @()
    $html.Forms | ForEach-Object {
      $formParams = @{}
      $_.Fields | ForEach-Object {
        $formParams[$_.Name] = $_.Value
      }
      $params += New-Object PSObject -Property $formParams
    }

    $params
  } catch {
    # If an error occurs while sending the HTTP request, return an error message
    "Error: $($_.Exception.Message)"
  }
}

Export-ModuleMember -Function Scan-Xss, Analyze-XssParameters
