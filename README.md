# GE-Proton-bash-auto-installer
A script that allows you to easily update GE-Proton without doing unnecessary steps. =)
To run the script automatically, you will need a utility to run the scripts when the PC starts, or systemd if you use it.
For example, let's take cron:

# Crontab
Enter the command to edit crontab:
./bash
crontab -e
@reboot /path/to/protonGE_Updater.sh

# Systemd
./bash
sudo nano /etc/systemd/system/protonGE_Updater.service

Example file for Systemd:
[Unit]
Description=protonGE_Updater
[Service]
ExecStart=/path/to/protonGE_Updater.sh
Restart=always
User=LimonTH
[Install]
WantedBy=multi-user.target
