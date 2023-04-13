# Get a collection of network adapter configuration objects
$adapters = Get-CimInstance Win32_NetworkAdapterConfiguration

# Filter out non-enabled adapters
$adapters = $adapters | Where-Object { $_.IPEnabled }

# Define the properties we want to display
$properties = 'Description', 'Index', 'IPAddress', 'IPSubnet', 'DNSDomain', 'DNSServerSearchOrder'

# Format the output as a table
$adapters | Select-Object $properties | Format-Table -AutoSize
