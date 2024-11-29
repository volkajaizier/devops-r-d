1. Installing Nginx through the official repository:
- sudo apt update
- sudo apt install nginx
- sudo systemctl status nginx
vagrant@vagrant:~$ sudo systemctl status nginx
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; preset: enabled)
     Active: active (running) since Tue 2024-09-17 15:25:52 UTC; 16s ago
       Docs: man:nginx(8)
    Process: 2277 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
    Process: 2284 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (code=exited, status=0/SUCCESS)
   Main PID: 2286 (nginx)
      Tasks: 3 (limit: 2275)
     Memory: 2.3M (peak: 2.4M)
        CPU: 24ms

2.Adding the PPA repository for Nginx
-sudo apt install software-properties-common
-sudo add-apt-repository ppa:nginx/stable  ()
get next error which point that there is no PPA available for the "noble" release of Ubuntu. (Description:Ubuntu 24.04 LTS; Release:24.04;Codename:noble)

'
Description:
This PPA contains the latest Stable Release version of the nginx web server software.

**Only Non-End-of-Life Ubuntu Releases are supported in this PPA**

**Development releases of Ubuntu are not officially supported by this PPA, and uploads for those will not be available until actual final releases for those versions**
More info: https://launchpad.net/~nginx/+archive/ubuntu/stable
Adding repository.
Press [ENTER] to continue or Ctrl-c to cancel.
Hit:1 http://security.ubuntu.com/ubuntu noble-security InRelease
Hit:2 http://archive.ubuntu.com/ubuntu noble InRelease
Hit:3 http://archive.ubuntu.com/ubuntu noble-updates InRelease
Hit:4 http://archive.ubuntu.com/ubuntu noble-backports InRelease
Ign:5 https://ppa.launchpadcontent.net/nginx/stable/ubuntu noble InRelease
Err:6 https://ppa.launchpadcontent.net/nginx/stable/ubuntu noble Release
  404  Not Found [IP: 185.125.190.80 443]
Reading package lists... Done
E: The repository 'https://ppa.launchpadcontent.net/nginx/stable/ubuntu noble Release' does not have a Release file.
N: Updating from such a repository can't be done securely, and is therefore disabled by default.
N: See apt-secure(8) manpage for repository creation and user configuration details.


and indeed I haven`t found any available ppa for this distor by the link below
https://ppa.launchpadcontent.net/nginx/stable/ubuntu/dists/

3.Removing the PPA repository and reverting to the official version of Nginx
sudo apt install ppa-purge
sudo ppa-purge ppa:nginx/stable
(because for my distro ppa solution is not working this command return below error)

do ppa-purge ppa:nginx/stable
Updating packages lists
E: The repository 'https://ppa.launchpadcontent.net/nginx/stable/ubuntu jammy Release' does not have a Release file.
E: The repository 'https://ppa.launchpadcontent.net/nginx/stable/ubuntu noble Release' does not have a Release file.
Warning:  apt-get update failed for some reason


4.Write and configure your own systemd service to run a simple script (for example, a script that writes "I'm a super cool script" to a file).
- create a script 
sudo nano /usr/local/bin/cool_script.sh
- script itself:
cat /usr/local/bin/cool_script.sh 
#!/bin/bash
echo "I'm a super cool script" >> /var/log/cool_script.log

-make script executable
sudo chmod +x /usr/local/bin/cool_script.sh
- create a service file
sudo nano /etc/systemd/system/cool_script.service
- content of service file:
[Unit]
Description=A service that writes "I'm a super cool script" to a log file

[Service]
ExecStart=/usr/local/bin/cool_script.sh

[Install]
WantedBy=multi-user.target

-reload systemd to recongnise new service
sudo systemctl daemon-reload
-start service
sudo systemctl start cool_script.service
- check service status
sudo systemctl status cool_script.service
○ cool_script.service - A service that writes "I'm a super cool script" to a log file
     Loaded: loaded (/etc/systemd/system/cool_script.service; enabled; preset: enabled)
     Active: inactive (dead) since Tue 2024-09-17 16:37:48 UTC; 1min 29s ago
   Duration: 9ms
    Process: 3651 ExecStart=/usr/local/bin/cool_script.sh (code=exited, status=0/SUCCESS)
   Main PID: 3651 (code=exited, status=0/SUCCESS)
        CPU: 7ms

Sep 17 16:37:48 vagrant systemd[1]: Started cool_script.service - A service that writes "I'm a super cool script" to a log file.
Sep 17 16:37:48 vagrant systemd[1]: cool_script.service: Deactivated successfully.


5. Configure UFW

- enable UFW

sudo ufw enable
Command may disrupt existing ssh connections. Proceed with operation (y|n)? y
Firewall is active and enabled on system startup

- adding rules

sudo ufw allow from 192.168.1.10 to any port 22
Rule added
vagrant@vagrant:~$ sudo ufw deny from 192.168.1.20 to any port 22
Rule added

- reload of UFW
vagrant@vagrant:~$ sudo ufw reload
Firewall reloaded
- check rules
vagrant@vagrant:~$ sudo ufw status numbered
Status: active

     To                         Action      From
     --                         ------      ----
[ 1] 22                         ALLOW IN    192.168.1.10
[ 2] 22                         DENY IN     192.168.1.20

6. Configure Fail2Ban to Protect Against SSH Password Guessing

- install fail2ban
sudo apt update
sudo apt install fail2ban

- change conf file
sudo nano /etc/fail2ban/jail.conf
- add below config 
[sshd]
enabled = true
port = ssh
logpath = %(sshd_log)s
maxretry = 5
bantime = 10m
- start and enable fail2ban
sudo systemctl start fail2ban
sudo systemctl enable fail2ban
- check status
vagrant@vagrant:~$ sudo fail2ban-client status sshd
Status for the jail: sshd
|- Filter
|  |- Currently failed: 0
|  |- Total failed:     0
|  `- Journal matches:  _SYSTEMD_UNIT=sshd.service + _COMM=sshd
`- Actions
   |- Currently banned: 0
   |- Total banned:     0
   `- Banned IP list:

7. Add a New Virtual Disk
-add virtual disk
Select the VM
Go to Storage.
Under Controller: SATA, click the + button to add a hard disk.
create new disk and specify the size (e.g., 2GB).
Set the disk type to VDI (VirtualBox Disk Image) and choose Dynamically allocated.
Save the changes.
- up the machine
lsblk
NAME                      MAJ:MIN RM SIZE RO TYPE MOUNTPOINTS
sda                         8:0    0  64G  0 disk
├─sda1                      8:1    0   1M  0 part
├─sda2                      8:2    0   2G  0 part /boot
└─sda3                      8:3    0  62G  0 part
  └─ubuntu--vg-ubuntu--lv 252:0    0  31G  0 lvm  /
sdb                         8:16   0   2G  0 disk

sdb - new disk

-cerate new partition
sudo fdisk /dev/sdb 

n option
p - primary disk
enter
enter
enter
w - write changes

- format partition
sudo mkfs.ext4 /dev/sdb1

- create place to mount, mount and check result
vagrant@vagrant:~$ sudo mkdir /mnt/mydisk
vagrant@vagrant:~$ sudo mount /dev/sdb1 /mnt/mydisk
mount: (hint) your fstab has been modified, but systemd still uses
       the old version; use 'systemctl daemon-reload' to reload.
vagrant@vagrant:~$ df -h
Filesystem                         Size  Used Avail Use% Mounted on
tmpfs                              197M 1012K  196M   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv   31G  3.4G   26G  12% /
tmpfs                              984M     0  984M   0% /dev/shm
tmpfs                              5.0M     0  5.0M   0% /run/lock
/dev/sda2                          2.0G   96M  1.7G   6% /boot
vagrant                            952G  422G  530G  45% /vagrant
vagrant_shared2                    952G  422G  530G  45% /vagrant_shared2
tmpfs                              197M   12K  197M   1% /run/user/1000
/dev/sdb1                          2.0G   24K  1.9G   1% /mnt/mydisk

automatic mount

-check UUID of new partition
sudo blkid /dev/sdb1
- edit fstab
sudo nano /etc/fstab
- add line
UUID=1fcba435-d014-44e4-8ad2-ed66d23915b4 /mnt/mydisk ext4 defaults 0 0
- save and exit


after reboot
Last login: Thu Sep 19 15:30:22 2024 from 10.0.2.2
vagrant@vagrant:~$ df -h
Filesystem                         Size  Used Avail Use% Mounted on
tmpfs                              197M 1012K  196M   1% /run
/dev/mapper/ubuntu--vg-ubuntu--lv   31G  3.5G   26G  12% /
tmpfs                              984M     0  984M   0% /dev/shm
tmpfs                              5.0M     0  5.0M   0% /run/lock
/dev/sdb1                          2.0G   24K  1.9G   1% /mnt/mydisk
/dev/sda2                          2.0G   96M  1.7G   6% /boot
vagrant                            952G  422G  530G  45% /vagrant
vagrant_shared2                    952G  422G  530G  45% /vagrant_shared2
tmpfs                              197M   12K  197M   1% /run/user/1000

Working!!!