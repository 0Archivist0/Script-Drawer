Add-Type -AssemblyName System.Windows.Forms

# Check if the user has administrative privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (!$isAdmin) {
    [System.Windows.Forms.MessageBox]::Show("This script requires administrative privileges. Please run the script as an administrator.", "Python Installer", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
    exit 1
}

# Create a form to prompt the user for the installation path
$form = New-Object System.Windows.Forms.Form
$form.Text = "Python Installer"
$form.ClientSize = New-Object System.Drawing.Size(400, 200)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

$label = New-Object System.Windows.Forms.Label
$label.Text = "Enter the installation path for Python:"
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(20, 20)
$form.Controls.Add($label)

$pathTextBox = New-Object System.Windows.Forms.TextBox
$pathTextBox.Location = New-Object System.Drawing.Point(20, 50)
$pathTextBox.Size = New-Object System.Drawing.Size(300, 20)
$form.Controls.Add($pathTextBox)

$browseButton = New-Object System.Windows.Forms.Button
$browseButton.Text = "Browse..."
$browseButton.Location = New-Object System.Drawing.Point(330, 50)
$browseButton.Size = New-Object System.Drawing.Size(50, 20)
$browseButton.Add_Click({
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.ShowDialog() | Out-Null
    $pathTextBox.Text = $dialog.SelectedPath
})
$form.Controls.Add($browseButton)

$okButton = New-Object System.Windows.Forms.Button
$okButton.Text = "OK"
$okButton.Location = New-Object System.Drawing.Point(100, 100)
$okButton.Size = New-Object System.Drawing.Size(75, 23)
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = "Cancel"
$cancelButton.Location = New-Object System.Drawing.Point(220, 100)
$cancelButton.Size = New-Object System.Drawing.Size(75, 23)
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$formResult = $form.ShowDialog()

if ($formResult -eq [System.Windows.Forms.DialogResult]::OK) {
    $InstallPath = $pathTextBox.Text
} else {
    exit 0
}

# Define the Python installation parameters
$DownloadUrl = "https://www.python.org/ftp/python"

# Set up error handling and logging
$ErrorActionPreference = "Stop"
$LogFile = Join-Path $env:TEMP "install_python.log"
$LogFileStream = [System.IO.StreamWriter]::new($LogFile, $true)

try {
    # Check if Python is already installed
    if (Test-Path "$InstallPath\python.exe") {
        [System.Windows.Forms.MessageBox]::Show("Python is already installed.", "Python Installer", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        exit 0
    }

    # Get the latest version of Python
    Write-Output "Checking for the latest version of Python..."
    $LatestVersionUrl = Join-Path $DownloadUrl "latest"
    $LatestVersion = Invoke-WebRequest -Uri $LatestVersionUrl -Method Get | Select-Object -ExpandProperty Content

    if ([string]::IsNullOrEmpty($LatestVersion)) {
        throw "Unable to determine the latest version of Python."
    }

    $PythonVersion = $LatestVersion.Trim()

    # Download the Python installer
    $InstallerUrl = "$DownloadUrl/$PythonVersion/python-$PythonVersion-amd64.exe"
    $InstallerPath = Join-Path $env:TEMP "python-$PythonVersion-amd64.exe"

    Write-Output "Downloading Python $PythonVersion..."
    $downloadProgress = New-Object System.Windows.Forms.ProgressBar
    $downloadProgress.Minimum = 0
    $downloadProgress.Maximum = 100
    $downloadProgress.Value = 0
    $downloadProgress.Location = New-Object System.Drawing.Point(20, 80)
    $downloadProgress.Size = New-Object System.Drawing.Size(360, 20)
    $form.Controls.Add($downloadProgress)
    $form.Refresh()

    Invoke-WebRequest -Uri $InstallerThanks for highlighting that, it seems like part of the script got cut off in my previous response. Here's the complete updated version of the script that includes the download progress bar:

```PowerShell
Add-Type -AssemblyName System.Windows.Forms

# Check if the user has administrative privileges
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)
if (!$isAdmin) {
    [System.Windows.Forms.MessageBox]::Show("This script requires administrative privileges. Please run the script as an administrator.", "Python Installer", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Warning)
    exit 1
}

# Create a form to prompt the user for the installation path
$form = New-Object System.Windows.Forms.Form
$form.Text = "Python Installer"
$form.ClientSize = New-Object System.Drawing.Size(400, 200)
$form.FormBorderStyle = [System.Windows.Forms.FormBorderStyle]::Fixed3D
$form.StartPosition = [System.Windows.Forms.FormStartPosition]::CenterScreen

$label = New-Object System.Windows.Forms.Label
$label.Text = "Enter the installation path for Python:"
$label.AutoSize = $true
$label.Location = New-Object System.Drawing.Point(20, 20)
$form.Controls.Add($label)

$pathTextBox = New-Object System.Windows.Forms.TextBox
$pathTextBox.Location = New-Object System.Drawing.Point(20, 50)
$pathTextBox.Size = New-Object System.Drawing.Size(300, 20)
$form.Controls.Add($pathTextBox)

$browseButton = New-Object System.Windows.Forms.Button
$browseButton.Text = "Browse..."
$browseButton.Location = New-Object System.Drawing.Point(330, 50)
$browseButton.Size = New-Object System.Drawing.Size(50, 20)
$browseButton.Add_Click({
    $dialog = New-Object System.Windows.Forms.FolderBrowserDialog
    $dialog.ShowDialog() | Out-Null
    $pathTextBox.Text = $dialog.SelectedPath
})
$form.Controls.Add($browseButton)

$okButton = New-Object System.Windows.Forms.Button
$okButton.Text = "OK"
$okButton.Location = New-Object System.Drawing.Point(100, 100)
$okButton.Size = New-Object System.Drawing.Size(75, 23)
$okButton.DialogResult = [System.Windows.Forms.DialogResult]::OK
$form.AcceptButton = $okButton
$form.Controls.Add($okButton)

$cancelButton = New-Object System.Windows.Forms.Button
$cancelButton.Text = "Cancel"
$cancelButton.Location = New-Object System.Drawing.Point(220, 100)
$cancelButton.Size = New-Object System.Drawing.Size(75, 23)
$cancelButton.DialogResult = [System.Windows.Forms.DialogResult]::Cancel
$form.CancelButton = $cancelButton
$form.Controls.Add($cancelButton)

$formResult = $form.ShowDialog()

if ($formResult -eq [System.Windows.Forms.DialogResult]::OK) {
    $InstallPath = $pathTextBox.Text
} else {
    exit 0
}

# Define the Python installation parameters
$DownloadUrl = "https://www.python.org/ftp/python"

# Set up error handling and logging
$ErrorActionPreference = "Stop"
$LogFile = Join-Path $env:TEMP "install_python.log"
$LogFileStream = [System.IO.StreamWriter]::new($LogFile, $true)

try {
    # Check if Python is already installed
    if (Test-Path "$InstallPath\python.exe") {
        [System.Windows.Forms.MessageBox]::Show("Python is already installed.", "Python Installer", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        exit 0
    }

    # Get the latest version of Python
    Write-Output "Checking for the latest version of Python..."
    $LatestVersionUrl = Join-Path $DownloadUrl "latest"
    $LatestVersion = Invoke-WebRequest -Uri $LatestVersionUrl -Method Get | Select-Object -ExpandProperty Content

    if ([string]::IsNullOrEmpty($LatestVersion)) {
        throw "Unable to determine the latest version of Python."
    }

    $PythonVersion = $LatestVersion.Trim()

    # Download the Python installer
    $InstallerUrl = "$DownloadUrl/$PythonVersion/python-$PythonVersion-amd64.exe"
    $InstallerPath = Join-Path $env:TEMP "python-$PythonVersion-amd64.exe"

    Write-Output "Downloading Python $PythonVersion..."
    $downloadProgress = New-Object System.Windows.Forms.ProgressBar
    $downloadProgress.Minimum = 0
    $downloadProgress.Maximum = 100
    $downloadProgress.Value = 0
    $downloadProgress.Location = New-Object System.Drawing.Point(20, 80)
    $downloadProgress.Size = New-Object System.Drawing.Size(360, 20)
    $form.Controls.Add($downloadProgress)
