Function Scan-Cms {
  param(
    [Parameter(Mandatory=$true)]
    [string] $Url
  )

  try {
    # Send an HTTP request to the website and retrieve its HTML source code
    $html = Invoke-WebRequest -Uri $Url -ErrorAction Stop

    # Search the HTML source code for clues about the CMS
    if ($html.Content -match "WordPress") {
      "WordPress"
    } elseif ($html.Content -match "Joomla") {
      "Joomla"
    } elseif ($html.Content -match "Drupal") {
      "Drupal"
    } else {
      "Unknown CMS"
    }
  } catch {
    # If an error occurs while sending the HTTP request, return an error message
    "Error: $($_.Exception.Message)"
  }
}

Function Get-CmsVersion {
  param(
    [Parameter(Mandatory=$true)]
    [string] $Url
  )

  try {
    # Send an HTTP request to the website and retrieve its HTML source code
    $html = Invoke-WebRequest -Uri $Url -ErrorAction Stop

    # Search the HTML source code for clues about the CMS version
    if ($html.Content -match "WordPress") {
      # Search for the WordPress version number in the HTML source code
      if ($html.Content -match "content='WordPress ([0-9.]+)'") {
        $matches[1]
      } else {
        "Unknown version"
      }
    } elseif ($html.Content -match "Joomla") {
      # Search for the Joomla version number in the HTML source code
      if ($html.Content -match "meta name='generator' content='Joomla! ([0-9.]+)'") {
        $matches[1]
      } else {
        "Unknown version"
      }
    } elseif ($html.Content -match "Drupal") {
      # Search for the Drupal version number in the HTML source code
      if ($html.Content -match "Drupal ([0-9.]+)") {
        $matches[1]
      } else {
        "Unknown version"
      }
    } else {
      "Unknown CMS"
    }
  } catch {
    # If an error occurs while sending the HTTP request, return an error message
    "Error: $($_.Exception.Message)"
  }
}

Export-ModuleMember -Function Scan-Cms, Get-CmsVersion
