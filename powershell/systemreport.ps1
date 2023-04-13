# Function to retrieve computer system information
function Get-ComputerSystem {
    $computerSystem = Get-WmiObject Win32_ComputerSystem
    $props = @{
        Manufacturer = $computerSystem.Manufacturer
        Model = $computerSystem.Model
        SerialNumber = $computerSystem.SerialNumber
        SystemType = $computerSystem.SystemType
        TotalPhysicalMemory = "{0:N2} GB" -f ($computerSystem.TotalPhysicalMemory/1GB)
    }
    New-Object PSObject -Property $props
}

# Function to retrieve operating system information
function Get-OperatingSystem {
    $operatingSystem = Get-WmiObject Win32_OperatingSystem
    $props = @{
        Name = $operatingSystem.Caption
        Version = $operatingSystem.Version
    }
    New-Object PSObject -Property $props
}

# Function to retrieve processor information
function Get-Processor {
    $processor = Get-WmiObject Win32_Processor
    $props = @{
        Description = $processor.Description
        Cores = $processor.NumberOfCores
        L1Cache = "{0:N0} KB" -f $processor.L1CacheSize
        L2Cache = "{0:N0} KB" -f $processor.L2CacheSize
        L3Cache = if ($processor.L3CacheSize -eq $null) {"N/A"} else {"{0:N0} KB" -f $processor.L3CacheSize}
    }
    New-Object PSObject -Property $props
}

# Function to retrieve memory information
function Get-Memory {
    $memory = Get-WmiObject Win32_PhysicalMemory
    $props = @{
        Bank = $memory.BankLabel
        Slot = $memory.DeviceLocator
        Size = "{0:N2} GB" -f ($memory.Capacity/1GB)
        Speed = $memory.Speed
        Vendor = $memory.Manufacturer
        PartNumber = $memory.PartNumber
    }
    $memory | Select-Object $props | Sort-Object Bank, Slot
}

# Function to retrieve disk information
function Get-Disk {
    $disks = Get-WmiObject Win32_DiskDrive
    foreach ($disk in $disks) {
        $diskProps = @{
            Vendor = $disk.Manufacturer
            Model = $disk.Model
            Size = "{0:N2} GB" -f ($disk.Size/1GB)
        }
        $diskPartitions = $disk | Get-WmiObject -Class Win32_DiskPartition
        foreach ($partition in $diskPartitions) {
            $diskProps["DriveLetter"] = $partition.DriveLetter
            $logicalDisks = $partition | Get-WmiObject -Class Win32_LogicalDisk
            foreach ($logicalDisk in $logicalDisks) {
                $diskProps["FileSystem"] = $logicalDisk.FileSystem
                $diskProps["TotalSpace"] = "{0:N2} GB" -f ($logicalDisk.Size/1GB)
                $diskProps["FreeSpace"] = "{0:N2} GB" -f ($logicalDisk.FreeSpace/1GB)
                $diskProps["PercentFree"] = "{0:P2}" -f ($logicalDisk.FreeSpace/$logicalDisk.Size)
                New-Object PSObject -Property $diskProps
            }
        }
    }
}

# Function to retrieve network adapter configuration information
function Get-NetworkAdapterConfiguration {
    # Get a collection of network adapter configuration objects
    $adapters = Get-CimInstance Win32_NetworkAdapterConfiguration

    # Filter out non-enabled adapters
    $adapters = $adapters | Where-Object { $_.IPEnabled }

    # Define the properties we want to display
    $properties = 'Description', 'Index', 'IPAddress', 'IPSubnet', 'DNSDomain', 'DNSServerSearchOrder'

    # Format the output as a table
    $adapters | Select-Object $properties | Format-Table -AutoSize
}

# Function to retrieve video controller information
function Get-VideoController {
    $videoController = Get-WmiObject Win32_VideoController
    $props = @{
        Vendor = $videoController.VideoProcessor
        Description = $videoController.Description
        CurrentResolution = "{0} x {1}" -f $videoController.CurrentHorizontalResolution, $videoController.CurrentVerticalResolution
    }
    New-Object PSObject -Property $props
}

# Output the system hardware description
Write-Host "System Hardware Description" -ForegroundColor Green
Get-ComputerSystem

# Output the operating system name and version number
Write-Host "Operating System" -ForegroundColor Green
Get-OperatingSystem

# Output the processor information
Write-Host "Processor Information" -ForegroundColor Green
Get-Processor

# Output the RAM information
Write-Host "RAM Information" -ForegroundColor Green
Get-Memory

# Output the disk drive information
Write-Host "Disk Drive Information" -ForegroundColor Green
Get-Disk

# Output the network adapter configuration
Write-Host "Network Adapter Configuration" -ForegroundColor Green
Get-NetworkAdapterConfiguration

# Output the video controller information
Write-Host "Video Controller Information" -ForegroundColor Green
Get-VideoController
