# Author: Kris Tomplait
# this was just a test script to see how it would work... 
# only used it once, not sure why I made it originally, but there it is
# As always use at your own risk

import os
import sys
import subprocess
import tkinter as tk
from tkinter import messagebox, filedialog

# Function to install the tkinter library
def install_tkinter_library():
    try:
        subprocess.check_call([sys.executable, "-m", "pip", "install", "tkinter"])
        messagebox.showinfo("Library Installed", "The tkinter library has been installed successfully. Please restart the script.")
        sys.exit(0)
    except subprocess.CalledProcessError:
        messagebox.showerror("Installation Error", "Failed to install the tkinter library. Please install it manually.")
        sys.exit(1)

# Check if tkinter library is available
tkinter_available = True
try:
    import tkinter as tk
except ImportError:
    tkinter_available = False

# If tkinter library is not available, ask the user if they want to install it
if not tkinter_available:
    response = messagebox.askquestion("tkinter Library Not Found", "The tkinter library is required for this script. Do you want to install it?")
    if response == "yes":
        install_tkinter_library()
    else:
        messagebox.showwarning("Feature Deactivated", "The tkinter library is not available. The script will continue without GUI functionality.")

# Function to convert the file
def convert_file(input_file, output_file, output_format):
    try:
        # Check if the input file exists
        if not os.path.exists(input_file):
            raise FileNotFoundError(f"Input file not found: {input_file}")

        # Check if the output file already exists
        if os.path.exists(output_file):
            raise FileExistsError(f"Output file already exists: {output_file}")

        # Replace the following line with the appropriate conversion logic
        # For simplicity, we'll just copy the file
        with open(input_file, 'rb') as source_file, open(output_file, 'wb') as dest_file:
            dest_file.write(source_file.read())

        message = f"File converted successfully to {output_format}: {output_file}"
        messagebox.showinfo("Conversion Complete", message)
    except FileNotFoundError as e:
        messagebox.showerror("File Not Found", str(e))
    except FileExistsError as e:
        messagebox.showerror("File Already Exists", str(e))
    except Exception as e:
        error_message = f"Error occurred during conversion: {str(e)}"
        messagebox.showerror("Conversion Error", error_message)

# Function to handle the Convert button click
def on_convert_click():
    input_file = input_text.get()
    output_format = format_dropdown.get()

    if not os.path.exists(input_file):
        messagebox.showerror("Input Error", f"Input file not found: {input_file}")
        return

    if not output_format:
        messagebox.showerror("Output Error", "Output format cannot be empty. Please provide a valid format.")
        return

    output_file = filedialog.asksaveasfilename(defaultextension=f".{output_format}")

    if output_file:
        convert_file(input_file, output_file, output_format)


# Create the GUI window if tkinter library is available
if tkinter_available:
    window = tk.Tk()
    window.title("File Converter")

    # Create the input file label and textbox
    input_label = tk.Label(window, text="Input Path:")
    input_label.grid(row=0, column=0, padx=10, pady=10)
    input_text = tk.Entry(window)
    input_text.grid(row=0, column=1, padx=10, pady=10)

    # Create the output format label and dropdown
    output_format_label = tk.Label(window, text="Output Format:")
    output_format_label.grid(row=1, column=0, padx=10, pady=10)
    format_dropdown = tk.StringVar()
    format_dropdown.set("pdf")  # Set default format
    output_format_dropdown = tk.OptionMenu(window, format_dropdown, "pdf", "docx", "txt")
    output_format_dropdown.grid(row=1, column=1, padx=10, pady=10)

    # Create the Convert button
    convert_button = tk.Button(window, text="Convert", command=on_convert_click)
    convert_button.grid(row=2, columnspan=2, padx=10, pady=10)

    # Start the GUI event loop
    window.mainloop()
