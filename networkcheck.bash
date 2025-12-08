#!/bin/bash

myIP=$(bash myIP.bash)

# Todo-1: Create a helpmenu function that prints help for the script
function helpmenu(){
  echo "HELP MENU"
  echo "--------------"
  echo "-n: Add -n as an argument for this script to use nmap"
  echo "-n external: External NMAP scan"
  echo "-n internal: Internal NMAP scan"
  echo "-s: Add -s as an argument for this script to use ss"
  echo "-s external: External ss(Netstat) scan"
  echo "-s internal: Internal ss(Netstat) scan"
  echo ""
  echo "Usage: bash networkchecker.bash -n/-s external/internal"
  echo "--------------"
}

# Return ports that are serving to the network
function ExternalNmap(){
  rex=$(nmap "${myIP}" | awk -F"[/[:space:]]+" '/open/ {print $1,$4}' )
  echo "$rex"
}

# Return ports that are serving to localhost
function InternalNmap(){
  rin=$(nmap localhost | awk -F"[/[:space:]]+" '/open/ {print $1,$4}' )
  echo "$rin"
}

# Only IPv4 ports listening from network
function ExternalListeningPorts(){
# Todo-2: Complete the ExternalListeningPorts that will print the port and application
# that is listening on that port from network (using ss utility)
elpo=$(ss -ltpn | awk -F"[[:space:]:(),]+" '!/127.0.0./ && /LISTEN/ {print $5,$9}' | tr -d "\"")
echo "$elpo"
}

# Only IPv4 ports listening from localhost
function InternalListeningPorts(){
ilpo=$(ss -ltpn | awk  -F"[[:space:]:(),]+" '/127.0.0./ {print $5,$9}' | tr -d "\"")
echo "$ilpo"
}

# Todo-3: If the program is not taking exactly 2 arguments, print helpmenu
[ $# -ne 2 ] && helpmenu && exit 1

# Todo-4: Use getopts to accept options -n and -s (both will have an argument)
while getopts "n:s:" option; do
  case "$option" in
    n)
      [ "$OPTARG" == "internal" ] && InternalNmap && exit 0
      [ "$OPTARG" == "external" ] && ExternalNmap && exit 0
      helpmenu && exit 1
      ;;
    s)
      [ "$OPTARG" == "internal" ] && InternalListeningPorts && exit 0
      [ "$OPTARG" == "external" ] && ExternalListeningPorts && exit 0
      helpmenu && exit 1
      ;;
    *)
      helpmenu && exit 1
      ;;
  esac
done
