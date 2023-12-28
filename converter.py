import sys
import os
import subprocess
import tkinter as tk
from tkinter import messagebox
from tkinter import ttk
from pydub import AudioSegment

def convert_to_mp3(input_path, output_path):
    audio = AudioSegment.from_file(input_path)
    audio.export(output_path, format='mp3')

def convert_to_wav(input_path, output_path):
    audio = AudioSegment.from_file(input_path)
    audio.export(output_path, format='wav')

def convert_file():
    input_path = input_textbox.get()
    output_format = output_format_dropdown.get().lower()

    # Validate the input path
    if not os.path.exists(input_path):
        messagebox.showerror("Input Error", f"Input path not found: {input_path}")
        return

    # Generate the output file path with the appropriate extension
    output_file_path = os.path.splitext(input_path)[0] + '.' + output_format

    try:
        if output_format == 'mp3':
            convert_to_mp3(input_path, output_file_path)
        elif output_format == 'wav':
            convert_to_wav(input_path, output_file_path)
        # Add similar logic for other output formats
        else:
            messagebox.showerror("Conversion Error", "Invalid output format.")
            return

        # Write log entry for successful conversion
        with open('conversion_log.txt', 'a') as log_file:
            log_file.write(f"Converted {input_path} to {output_file_path} in format {output_format}\n")

        messagebox.showinfo("Conversion Complete", f"File converted successfully to {output_format}: {output_file_path}")

    except Exception as e:
        messagebox.showerror("Conversion Error", f"Error during conversion: {e}")


# Create the main window
window = tk.Tk()
window.title("File Converter")
window.geometry("400x200")
window.resizable(False, False)
window.configure(background='white')

# Input path label and textbox
input_label = tk.Label(window, text="Input Path:")
input_label.place(x=20, y=20)

input_textbox = tk.Entry(window, width=30)
input_textbox.place(x=120, y=20)

# Output format label and dropdown
output_format_label = tk.Label(window, text="Output Format:")
output_format_label.place(x=20, y=60)

output_format_dropdown = ttk.Combobox(window, values=["MP3", "WAV"], state="readonly")
output_format_dropdown.current(0)
output_format_dropdown.place(x=120, y=60)

# Convert button
convert_button = tk.Button(window, text="Convert", width=10, command=convert_file)
convert_button.place(x=150, y=100)

# Start the GUI event loop
window.mainloop()
