$php_files = Get-ChildItem -Path <path_to_php_files> -Recurse -Filter "*.php"

foreach ($php_file in $php_files) {
  $contents = Get-Content -Path $php_file
  $vulnerable = $false

  # Check for use of XSLTProcessor class
  if ($contents -match "new XSLTProcessor") {
    $vulnerable = $true
    Write-Output "XSLTProcessor class found in $php_file"
  }

  # Check for use of loadXML with user-supplied input
  if ($contents -match "loadXML\(.*$_.*\)") {
    $vulnerable = $true
    Write-Output "loadXML with user-supplied input found in $php_file"
  }

  # Check for use of importStylesheet with user-supplied input
  if ($contents -match "importStylesheet\(.*$_.*\)") {
    $vulnerable = $true
    Write-Output "importStylesheet with user-supplied input found in $php_file"
  }

  # Check for use of sanitization functions
  if ($contents -match "htmlspecialchars\(.*$_.*\)") {
    Write-Output "htmlspecialchars function found in $php_file"
  }
  if ($contents -match "strip_tags\(.*$_.*\)") {
    Write-Output "strip_tags function found in $php_file"
  }

  # Check for presence of whitelisted XSL functions
  if ($contents -match "xsl:value-of") {
    Write-Output "xsl:value-of element found in $php_file"
  }
  if ($contents -match "xsl:apply-templates") {
    Write-Output "xsl:apply-templates element found in $php_file"
  }

  if ($vulnerable) {
    Write-Output "Possible XSL vulnerability found in $php_file"
  }
}
