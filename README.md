# Powershell
Trying my best with powershell using the docs and other resources, any critisism is necessary

# Recon
    Nmap: a tool for network discovery and security scanning. It can be used to identify open ports and services, detect operating systems, and perform vulnerability assessments.
    ExploitDB: a database of known exploits and vulnerabilities. It can be searched to find exploits targeting specific ports or platforms.
    GoSpider: a tool for web crawling and scanning. It can be used to find links and vulnerabilities on a website, as well as to find related sites and content.
    S3Scanner: a tool for scanning Amazon S3 buckets for vulnerabilities and misconfigurations. It can be used to find sensitive data and to identify potential security issues.
    VNC Scanner: a tool for identifying open Virtual Network Computing (VNC) connections. It can be used to find and connect to VNC servers on a network.
    XSS Scanner: a tool for detecting and verifying cross-site scripting (XSS) vulnerabilities. It can be used to test web applications for security weaknesses.
    CMS Scanner: a tool for identifying the content management system (CMS) used by a website. It can be used to determine the technology stack and potential vulnerabilities of a site.
    Metasploit: a tool for exploiting vulnerabilities and testing security defenses. It includes a large library of exploits and payloads, and can be used to perform penetration testing and vulnerability assessments.

# Remote Code Execution and Injection through PHP to XLS/XSS
Refer to xls_php_vuln.ps1 

This script searches through all .php files in a given directory (and its subdirectories) for certain patterns of code that might indicate a vulnerability related to XSL (eXtensible Stylesheet Language).

First, it gets a list of all .php files in the specified directory by using the Get-ChildItem cmdlet, which returns all child items (in this case, files) in a specified location. The -Recurse flag tells it to search through subdirectories as well, and the -Filter flag specifies that it should only return files with the .php extension. These files are stored in the $php_files variable.

Next, the script loops through each file in $php_files using a foreach loop. For each file, it reads the contents into the $contents variable using the Get-Content cmdlet. It then sets a $vulnerable variable to $false, which will be used to track whether any vulnerable code has been found in the file.

The script then checks for several different patterns in the contents of the file. If it finds any of these patterns, it sets the $vulnerable variable to $true and outputs a message indicating which pattern was found and in which file. The script also looks for the presence of certain XSL elements or functions that might be whitelisted (allowed even if a vulnerability is present).

At the end of the loop, if $vulnerable is still $false, the script outputs a message indicating that no vulnerabilities were found in the file. If $vulnerable is $true, it outputs a message indicating that a possible XSL vulnerability was found in the file.

