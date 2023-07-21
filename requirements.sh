#!/bin/bash

#If you have Kali Linux, chances are that you already have a bunch of these tools installed, like nmap and ffuf. 
#Check this list and install only what you need... or just run this script :)

#installing rustscan
wget https://github.com/RustScan/RustScan/releases/download/2.0.1/rustscan_2.0.1_amd64.deb
sudo dpkg -i rustscan_2.0.1_amd64.deb
rm rustscan_2.0.1_amd64.deb

#installing ffuf
sudo apt install golang
go get -u github.com/ffuf/ffuf

#copying lists in the specified path
sudo mkdir -p /usr/share/wordlists/SecLists/Discovery/Web-Content/
sudo wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/raft-medium-directories-lowercase.txt -o /usr/share/wordlists/SecLists/Discovery/Web-Content/raft-medium-directories-lowercase.txt
sudo wget https://raw.githubusercontent.com/danielmiessler/SecLists/master/Discovery/Web-Content/raft-medium-files-lowercase.txt -o /usr/share/wordlists/SecLists/Discovery/Web-Content/raft-medium-files-lowercase.txt
