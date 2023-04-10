## Rust

Install rustup.install in choco

## Setting a static ip address

Chose an ip address outside of router ip address, the ip address will still work if it sin the DHCP range if it's unassigned.
The DHCP range starts (for most routers) at 192.168.1.0
For example: 192.168.1.99 is likely to be unassigned but is still in the DHCP range.
For example: 192.168.1.1 is likely to be assigned to a device already.

ipconfig
set Subnet Mask and Default Gateway the same
set preferred dns server the same as default gateway
## Installing ssh

## Enable SMB and connect from Mac

Windows Features : Enable SMB 1.0 CIFS File Sharing Support
Restart

Run in Powershell with Admin Rights:
Get-SmbServerConfiguration | Select EnableSMB2Protocol

Shift + Cmd + C in Finder. Should show up under network Tab, connect as username of Pc computer.

You need to enable the folders you want to share. Right click on a folder > Sharing > Advanced Sharing> Enable sharing

## Enable OpenSSH and connect from Mac

Optional Features: Make sure OpenSSH client & server is installed.

Step 1: Enable the SSH server: 
# Set the sshd service to be started automatically
Get-Service -Name sshd | Set-Service -StartupType Automatic

# Now start the sshd service
Start-Service sshd

Step 2: Generate a key on the server

ssh-keygen -t ed25519
choose a password

Step 3: Connect from mac

ssh <pc_username>@<pc_ip_address>
enter same password


