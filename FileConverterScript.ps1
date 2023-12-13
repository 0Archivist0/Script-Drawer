# Define the form
$form = New-Object System.Windows.Forms.Form
$form.Text = "File Converter"
$form.Size = New-Object System.Drawing.Size(400, 200)
$form.StartPosition = "CenterScreen"

# Define the input label and textbox
$inputLabel = New-Object System.Windows.Forms.Label
$inputLabel.Location = New-Object System.Drawing.Point(20, 20)
$inputLabel.Size = New-Object System.Drawing.Size(100, 20)
$inputLabel.Text = "Input Path:"
$form.Controls.Add($inputLabel)

$inputTextbox = New-Object System.Windows.Forms.TextBox
$inputTextbox.Location = New-Object System.Drawing.Point(120, 20)
$inputTextbox.Size = New-Object System.Drawing.Size(200, 20)
$inputTextbox.AllowDrop = $true  # Enable drag-and-drop
$inputTextbox.Add_DragDrop({
    $inputTextbox.Text = $_.Data.GetData('FileDrop')
})
$form.Controls.Add($inputTextbox)

# Define the output format label and dropdown
$outputFormatLabel = New-Object System.Windows.Forms.Label
$outputFormatLabel.Location = New-Object System.Drawing.Point(20, 60)
$outputFormatLabel.Size = New-Object System.Drawing.Size(100, 20)
$outputFormatLabel.Text = "Output Format:"
$form.Controls.Add($outputFormatLabel)

$outputFormatDropdown = New-Object System.Windows.Forms.ComboBox
$outputFormatDropdown.Location = New-Object System.Drawing.Point(120, 60)
$outputFormatDropdown.Size = New-Object System.Drawing.Size(200, 20)
$outputFormatDropdown.DropDownStyle = [System.Windows.Forms.ComboBoxStyle]::DropDownList
$outputFormatDropdown.Items.AddRange(@("PDF", "DOCX", "JPG"))  # Pre-configured output formats
$form.Controls.Add($outputFormatDropdown)

# Define the convert button
$convertButton = New-Object System.Windows.Forms.Button
$convertButton.Location = New-Object System.Drawing.Point(150, 100)
$convertButton.Size = New-Object System.Drawing.Size(100, 30)
$convertButton.Text = "Convert"
$form.Controls.Add($convertButton)

# Define the convert button click event
$convertButton.Add_Click({
    $input = $inputTextbox.Text
    $outputFileFormat = $outputFormatDropdown.SelectedItem.ToString().ToLower()

    # Validate the input path
    if (-not (Test-Path $input)) {
        $message = "Input path not found: $input"
        [System.Windows.Forms.MessageBox]::Show($message, "Input Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    # Generate the output file path with the appropriate extension
    $outputFilePath = $input -replace "\..+$", ".$outputFileFormat"

    # Check and install required modules (if not already installed)
    $requiredModules = @('SomeLibrary', 'AnotherLibrary')  # Add your required module names here
    foreach ($module in $requiredModules) {
        if (-not (Get-Module -Name $module -ListAvailable)) {
            try {
                Install-Module -Name $module -Force -Scope CurrentUser -ErrorAction Stop
            }
            catch {
                $message = "Error installing required module: $module"
                [System.Windows.Forms.MessageBox]::Show($message, "Module Installation Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                return
            }
        }
    }

    # Handle conversion based on format
    switch ($outputFileFormat) {
        "pdf" {
            try {
                # Use the relevant command for PDF conversion
                Convert-FileToPdf -InputPath $input -OutputPath $outputFilePath
            }
            catch {
                $message = "Error during PDF conversion: $_"
                [System.Windows.Forms.MessageBox]::Show($message, "Conversion Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                return
            }
        }
        "docx" {
            try {
                # Use the relevant command for DOCX conversion
                Convert-FileToDocx -InputPath $input -OutputPath $outputFilePath
            }
            catch {
                $message = "Error during DOCX conversion: $_"
                [System.Windows.Forms.MessageBox]::Show($message, "Conversion Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                return
            }
        }
        "jpg" {
            try {
                # Use the relevant command for JPG conversion
                Convert-FileToJpg -InputPath $input -OutputPath $outputFilePath
            }
            catch {
                $message = "Error during JPG conversion: $_"
                [System.Windows.Forms.MessageBox]::Show($message, "Conversion Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
                return
            }
        }
        # Add similar logic for other output formats
    }

    # Write log entry for successful conversion
    Write-Host "Converted $input to $outputFilePath in format $outputFileFormat" >> conversion_log.txt

    $message = "File converted successfully to $outputFileFormat: $outputFilePath"
    [System.Windows.Forms.MessageBox]::Show($message, "Conversion Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
})

# Show the form
$form.ShowDialog() | Out-Null
