Function Get-OpenVncConnections {
  # Get a list of all running processes
  $processes = Get-Process

  # Filter the list to only include processes related to VNC
  $vncProcesses = $processes | Where-Object {
    $_.Name -match "vnc"
  }

  # Return the filtered list of VNC processes
  $vncProcesses
}

Export-ModuleMember -Function Get-OpenVncConnections
