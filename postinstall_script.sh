#!/bin/bash
#
#Encoding Unicode (UTF-8)
#
#Author
#   Vivek Bhagat
#GNU General Public Licence v3.0
#Copyright (c) 2017 Vivek Bhagat


##Adding user to wheel group (sudo)
su -c 'usermod -aG wheel your-username'
su - your-username


##Changing default hostname
hostnamectl set-hostname your-hostname


##Changing ip address to static and configuring network adapter (according to your network)
sudo sed -i '/BOOTPROTO=dhcp/ c\BOOTPROTO=none' /etc/sysconfig/network-scripts/ifcfg-enp0s25
sudo sed -i '/PEERDNS=yes/ c\#PEERDNS=yes' /etc/sysconfig/network-scripts/ifcfg-enp0s25
sudo sed -i '/PEERROUTES=yes c\#PEERROUTES=yes' /etc/sysconfig/network-scripts/ifcfg-enp0s25
sudo sed -i '$ a MACADDR=00:00:00:00:00:00' /etc/sysconfig/network-scripts/ifcfg-enp0s25
sudo sed -i '$ a IPADDR=192.168.1.10' /etc/sysconfig/network-scripts/ifcfg-enp0s25
sudo sed -i '$ a PREFIX=24' /etc/sysconfig/network-scripts/ifcfg-enp0s25
sudo sed -i '$ a GATEWAY=192.168.1.1' /etc/sysconfig/network-scripts/ifcfg-enp0s25
sudo sed -i '$ a DNS1=8.8.8.8' /etc/sysconfig/network-scripts/ifcfg-enp0s25
sudo sed -i '$ a DNS1=8.8.4.4' /etc/sysconfig/network-scripts/ifcfg-enp0s25
sudo sed -i '$ a DNS3=2001:4860:4860::8888' /etc/sysconfig/network-scripts/ifcfg-enp0s25
sudo sed -i '$ a DNS4=2001:4860:4860::8844' /etc/sysconfig/network-scripts/ifcfg-enp0s25
sudo sed -i '$ a IPV6_PEERDNS=no' /etc/sysconfig/network-scripts/ifcfg-enp0s25
sudo sed -i '$ a IPV6_PEERROUTES=yes' /etc/sysconfig/network-scripts/ifcfg-enp0s25
systemctl restart network.service


##Creating rpmfusion (free and non-free) repo
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm


##Creating paper (gtk and icon) theme repo
sudo dnf config-manager --add-repo http://download.opensuse.org/repositories/home:snwh:paper/Fedora_25/home:snwh:paper.repo


##Creating genome shell extension repo
sudo dnf copr enable region51/chrome-gnome-shell


##Creating gnome pomodoro repo
cd /etc/yum.repos.d/
sudo wget http://download.opensuse.org/repositories/home:kamilprusko/Fedora_25/home:kamilprusko.repo
cd ~


##Creating docker repo
sudo dnf config-manager --add-repo https://download.docker.com/linux/fedora/docker-ce.repo
sudo dnf makecache fast


##Creating cert forensic repo
cd ~/Downloads
sudo wget https://forensics.cert.org/cert-forensics-tools-release-25.rpm
sudo dnf install cert-forensics-tools-release-25.rpm
cd ~


##Updating system to the latest version
sudo dnf -y update


##Changing the no of installed kernel parameter
sudo sed -i '/installonly_limit=3/ c\installonly_limit=2' /etc/dnf/dnf.conf
#Removing old kernels
#rpm -q kernel
#sudo dnf -y install yum-utils
#package-cleanup --oldkernels --count=2


##Installing applications
sudo dnf -y install vim
sudo dnf -y install terminator
sudo dnf -y install gnome-tweak-tool
sudo dnf -y install chrome-gnome-shell
sudo dnf -y install dconf-editor
sudo dnf -y install flash-plugin
sudo dnf -y install vlc
sudo dnf -y install tomahawk
sudo dnf -y install youtube-dl
sudo dnf -y install bleachbit
sudo dnf -y install paper-gtk-theme
sudo dnf -y install paper-icon-theme
sudo dnf -y install ffmpeg
sudo dnf -y install google-authenticator
sudo dnf -y install libcurl
sudo dnf -y install wget
sudo dnf -y install gnome-pomodoro
sudo dnf -i install docker-ce
sudo dnf -y install ~/downloads/adobe-release-x86_64-1.0-1.noarch.rpm
sudo dnf -y install ~/Downloads/atom.x86_64.rpm
sudo dnf -y install ~/Downloads/google-chrome-stable_current_x86_64.rpm
sudo dnf -y install zlib.i686 ncurses-libs.i686 bzip2-libs.i686 compat-libstdc++-296 compat-libstdc++-33 glibc libgcc nss-softokn-freebl libstdc++ ant
/usr/local/android-studio/bin/./studio.sh
#sudo dnf -y install winehq


##Configuring google two factor authentication and pam.d/gdm-password
google-authenticator
sudo sed -i '$ a auth required pam_google_authenticator.so' /etc/pam.d/gdm-password


##Configuring ssh for two factor authentication
systemctl start sshd
systemctl enable sshd
sudo sed -i '$ a auth required pam_google_authenticator.so' /etc/pam.d/sshd
sudo sed -i '/ChallengeResponseAuthentication no/ c\#ChallengeResponseAuthentication no' /etc/ssh/sshd_config
sudo sed -i '/#ChallengeResponseAuthentication yes/ c\ChallengeResponseAuthentication yes' /etc/ssh/sshd_config
sudo sed -i '/PermitRootLogin yes/ c\PermitRootLogin no' /etc/ssh/sshd_config


##Git configuring (generate personal access token)
git config --global user.email "email@gmail.com"
git config --global user.name "username"

# Set git to use the credential memory cache
#git config --global credential.helper cache

# Set the cache to timeout after 1 hour (setting is in seconds)
#git config --global credential.helper 'cache --timeout=3600'

#Set git to use the credential memory store
#Default location of stored credential is ~/.git-credentials
git config --global credential.helper store

#To store credential with a custom file name and location
#git config --global credential.helper 'store --file ~/.my-credentials'

#.gitconfig (~/.gitconfig) would look like if you had a credentials file on a thumb drive, but wanted to use the in-memory cache to save some typing if the drive isn’t plugged in:
#[credential]
#    helper = store --file /mnt/thumbdrive/.git-credentials
#    helper = cache --timeout 36000


#Installing kernel for Atom Hydrogan package
python3 -m pip install ipykernel
python3 -m ipykernel install --user
