Add-Type -AssemblyName System.Windows.Forms

# Define function to convert file to specified format
function ConvertToFileFormat {
    param (
        [string]$inputFilePath,
        [string]$outputFilePath,
        [string]$outputFileFormat
    )

    try {
        # Check if the input file exists
        if (-not (Test-Path $inputFilePath)) {
            throw "Input file not found: $inputFilePath"
        }

        # Check if the output file path already exists
        if (Test-Path $outputFilePath) {
            throw "Output file already exists: $outputFilePath"
        }

        # Replace the following line with the appropriate command or code to convert the file to the specified format
        # For simplicity, we'll just copy the file for this script.
        Copy-Item -Path $inputFilePath -Destination $outputFilePath -Force

        $message = "File converted successfully to $outputFileFormat: $outputFilePath"
        [System.Windows.Forms.MessageBox]::Show($message, "Conversion Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
    catch {
        $errorMessage = $_.Exception.Message
        $message = "Error occurred during conversion: $errorMessage"
        [System.Windows.Forms.MessageBox]::Show($message, "Conversion Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return 1
    }

    return 0
}

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
$outputFormatDropdown.Items.AddRange(@("pdf", "docx", "txt"))
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
    $outputFileFormat = $outputFormatDropdown.SelectedValue

    if (-not (Test-Path $input)) {
        $message = "Input path not found: $input"
        [System.Windows.Forms.MessageBox]::Show($message, "Input Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    # Validate the output file format
    if ([string]::IsNullOrEmpty($outputFileFormat)) {
        $message = "Output file format cannot be empty. Please provide a valid format."
        [System.Windows.Forms.MessageBox]::Show($message, "Output Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    # Check if the output file format is valid
    $validFormats = @("pdf", "docx", "txt")
    if (-not $validFormats.Contains($outputFileFormat.ToLower())) {
        $message = "Invalid output file format: $outputFileFormat. Please select a valid format from the dropdown."
        [System.Windows.Forms.MessageBox]::Show($message, "Output Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        return
    }

    # Check if the input is a directory and convert all files in it
    if (Test-Path $input -PathType Container) {
        $files = Get-ChildItem $input -Recurse -File
        foreach ($file in $files) {
            # Generate the output file path with the appropriate extension
            $outputFilePath = $file.FullName -replace "\..+$", ".$outputFileFormat"

            # Perform the conversion
            $result = ConvertToFileFormat -inputFilePath $file.FullName -outputFilePath $outputFilePath -outputFileFormat $outputFileFormat
            if ($result -ne 0) {
                $message = "Error occurred during conversion of $($file.FullName)"
                [System.Windows.Forms.MessageBox]::Show($message, "Conversion Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
            }
        }

        $message = "All files converted successfully to $outputFileFormat"
        [System.Windows.Forms.MessageBox]::Show($message, "Conversion Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
    }
    # If not a directory, convert a single file
    else {
        # Generate the output file path with the appropriate extension
        $outputFilePath = $input -replace "\..+$", ".$outputFileFormat"

        # Perform the conversion
        $result = ConvertToFileFormat -inputFilePath $input -outputFilePath $outputFilePath -outputFileFormat $outputFileFormat
        if ($result -ne 0) {
            $message = "Error occurred during conversion."
            [System.Windows.Forms.MessageBox]::Show($message, "Conversion Error", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Error)
        }
        else {
            $message = "File converted successfully to $outputFileFormat: $outputFilePath"
            [System.Windows.Forms.MessageBox]::Show($message, "Conversion Complete", [System.Windows.Forms.MessageBoxButtons]::OK, [System.Windows.Forms.MessageBoxIcon]::Information)
        }
    }
})

# Show the form
$form.ShowDialog() | Out-Null
