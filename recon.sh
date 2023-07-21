#!/bin/bash

echo 'usage:  ./recon.sh 10.10.10.10'
#scanning ports
echo 'Scanning all ports...'
rustscan -a $1 --ulimit 5000 -r 1-65534 -- -sC -sV -Pn > scan.txt

#Checking http ports and creating a file to store them
cat scan.txt | grep 'http ' | grep '[0-9]' | cut -d/ -f1 >> http-port.txt

#http port variables
httpfile='http-port.txt'
ports=$(cat $httpfile)

#Fuzzing for directories in every http port found
echo 'Fuzzing directories...'
for port in $ports
	do ffuf -w /usr/share/wordlists/SecLists/Discovery/Web-Content/raft-medium-directories-lowercase.txt -u http://$1:$port/FUZZ >> $port-dir.txt
done

#Fuzzing for files in every http port found
echo 'Fuzzing files...'
for port in $ports  
        do ffuf -w /usr/share/wordlists/SecLists/Discovery/Web-Content/raft-medium-files-lowercase.txt -u http://$1:$port/FUZZ >> $port-files.txt 
done

#printing everything
echo 'Open-Ports:' >> output.txt
cat scan.txt | grep 'Open '| cut -d: -f2 >> output.txt
echo '' >> output.txt

echo 'HTTP-Ports open:' >> output.txt
cat http-port.txt >> output.txt
echo '' >> output.txt

echo 'Directories found:' >> output.txt
for port in $ports
do
  echo "Port $port:" >> output.txt
  cat $port-dir.txt | grep 'Z: ' | cut -d: -f2 | tr -d ' ' >> output.txt
  echo '' >> output.txt
done

echo 'Files found:' >> output.txt
for port in $ports
do
  echo "Port $port:" >> output.txt
  cat $port-files.txt | grep 'Z: ' | cut -d: -f2 | tr -d ' ' >> output.txt
  echo '' >> output.txt
done

rm scan.txt
rm http-port.txt
rm *dir.txt
rm *files.txt

cat output.txt
