import os
import urllib.request
import subprocess

def check_if_python_is_installed():
    """
    Check if Python is installed and install it if not.
    """
    python_path = r"C:\Python39\python.exe"
    if not os.path.exists(python_path):
        print("Python is not installed. Installing Python...")

        # Download the Python installer from the official website
        url = "https://www.python.org/ftp/python/3.9.7/python-3.9.7-amd64.exe"
        output = r"C:\python-3.9.7-amd64.exe"

        try:
            urllib.request.urlretrieve(url, output)
        except urllib.error.URLError as e:
            print(e)
            print("Failed to download Python installer.")
            return

        # Install Python with default settings
        try:
            subprocess.run([output, "/quiet", "InstallAllUsers=1", "PrependPath=1"], check=True)
        except subprocess.CalledProcessError as e:
            print(e)
            print("Failed to install Python.")
            return

        print("Python has been installed successfully.")
    else:
        print("Python is already installed.")

if __name__ == "__main__":
    check_if_python_is_installed()
