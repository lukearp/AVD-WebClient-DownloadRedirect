# What is this for?

This is to work around a compatability issue with the Azure Virtual Desktop Web Client File Sharing:

[Copy and paste from the Remote Desktop web client](https://learn.microsoft.com/en-us/windows-server/remote/remote-desktop-services/clients/remote-desktop-web-client#transfer-files-with-the-web-client):

    The web client currently supports copying and pasting text only. Files can't be copied or pasted to and from the web client. Additionally, you can only use Ctrl+C and Ctrl+V to copy and paste text.

Saving files directly to the Downloads folder redirect isn't supported.  This can be an issue from remote apps not having access to a full file explorer to copy and paste files.

# What does this do?

LogonScript-Folder-Move.ps1 would be configured as a Logon Script on the session hosts.  Once users login to the host, it attempts to map the RDWebClient Redirect download directory to a PSDrive and creates a folder within the users profile.  The script runs a check on that created folder every five seconds.  If a file is written to the directory, the script moves the file to the mapped PSDrive.  This triggers the download on the remote browser.  

# Setup

Set the variables for Source and Target in the LogonScript-Folder-Move.ps1

```powershell
# Variables to Set #
$dest = "X:\"
$sourcePath = "$($env:USERPROFILE)\Downloads\WebClient"
$credUserName = "localadmin"
# End to Variables to Set #
```
You will want your $sourcePath to be located within the users writeable profile.  

Create a password.txt file to save your password for a Local Admin account:

```powershell
$password = ConvertTo-SecureString -String "MYPASSWORD" -AsPlainText -Force
$password | ConvertFrom-SecureString | Out-File password.txt
```

The password.txt file much be generated per server and needs to be in the same directory as the LogonScript-Folder-Move.ps1

# Future Features

Integrate with Azure Key Vault to eliminate the need for the password.txt