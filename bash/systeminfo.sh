#!bin/bash
#This is the Mid-Term assignment
#MY name is Anmol Singh
#Student ID - 200350454

#Define command line help.
function help {
  cat <<EOF
  Usage: $0
  [-h | --help ]
  [-n | --netinfo]
  [-i | --ipinfo]
  [-o | --osinfo]
  [-c | --cpuinfo]
  [-m | --memoinfo]
  [-d | --diskinfo]
  [-p | --printinfo]
  [-s | --software]
EOF
}

function errormessage {
  echo "$@" >&2

}

rdefault="yes"
while [ $# -gt 0 ]; do
  case "$1" in
    -h| --help )
      displayhelp
      rdefault="no";;
   -n| --netinfo)
      netinfo="yes"
      rdefault="no"
      export netinfo ;;
      -i| --ipinfo)
        ipinfo="yes"
        rdefault="no" export ipinfo
      ;;
      -o| --osinfo)
        osinfo="yes"
        rdefault="no"
        ;;
        -c| --cpuinfo)
          cpuinfo="yes"
          rdefault="no"
          ;;
          -m| --meminfo)
            meminfo="yes"
            rdefault="no"
            export meminfo ;;
            -d| --diskinfo)
              diskinfo="yes"
              rdefault="no"
              ;;
              -p| --printinfo)
                printinfo="yes"
                rdefault="no"
                export printinfo

                ;;
                -s| --software)
                  software="yes"
                  rdefault="no"
export software and rdefault;;
                  *)
                errormessage "Case '$1' not recognised."
                errormessage "$(displayhelp)" exit 1 ;;
              esac
            shift
          done
osinfo="$(grep PRETTY /etc/os-release |sed -e 's/.*=//' -e 's/"//g')"
# following shows System and domain name
if [[ "$rdefault" = "yes" || "$netinfo" = "yes" ]]; then
  myhostname="$(hostname)"
  domainname="$(hostname -d)"


cat <<EOF
# using variables for output
========================= Net Info =========================

  Hostname: $myhostname
  Domain: $domainname
EOF
fi

# IP addresses for the host Info
if [[ "$rdefault" = "yes" || "$ipinfo" = "yes" ]]; then
echo "========================= IP Info =========================="
  interfaces=(`ifconfig |grep '^[A-Za-z]'|awk '{print $1}'`) # an array of interface names configured on this machine
  numinterfaces=${#interfaces[@]}
  declare -A ips # will be a hash with ip addresses, keyed using interface name
  intfindex=0 # will be used to iterate over the interfaces array

  while [ $intfindex -lt $numinterfaces ]; do
  # get the name from the interfaces array
    intfname="${interfaces[$intfindex]}"
  # extract the assigned ip address using ifconfig and store that in the ips hash
    ips[$intfname]="`ifconfig $intfname|grep 'inet '|sed -e 's/.*addr://' -e 's/ .*//'`"

  # FOllowing displays the interface and its ip addresses
    if [ -n "${ips[$intfname]}" ]; then
      echo "  Interface $intfname has the address ${ips[$intfname]}"
    else
      echo "  Interface $intfname has no ip address"
    fi
  # increment the index and move on to the next interfaces array value
    intfindex+=1
  done
  echo ""
fi

domainname="$(grep PRETTY /etc/os-release |sed -e 's/.*=//' -e 's/"//g')"
export domainname
# OS name and version
if [[ "$rdefault" = "yes" || "$osinfo" = "yes" ]]; then
  osinformation="$(grep PRETTY /etc/os-release | sed -e 's/.*=//' -e 's/\"//g')"

cat <<EOF
========================= OS Info =========================
  OS Info: $osinformation
EOF
fi

# Central Processing Unit description of the system
if [[ "$rdefault" = "yes" || "$cpuinfo" = "yes" ]]; then
  echo "========================= CPU Details ========================="
  lscpu | grep "Model name:"
  echo ""
fi

# Installed Memory on the system
if [[ "$rdefault" = "yes" || "$meminfo" = "yes" ]]; then
echo "========================= Total Memory ========================="
  cat /proc/meminfo | grep MemTotal
echo ""
fi

# Available Disk Space on current system
if [[ "$rdefault" = "yes" || "$diskinfo" = "yes" ]]; then
  echo "=========================Disk Space ========================="
  df -h
  echo ""
fi

# List of Printers on the system
if [[ "$rdefault" = "yes" || "$printinfo" = "yes" ]]; then
  echo "=========================Printers =========================="
  lpstat -p
  echo ""
fi

# following Softwares are installed on the system
if [[ "$rdefault" = "yes" || "$software" = "yes" ]]; then
  echo "========================= Installed Software ========================="
  apt list --installed
  echo ""
fi

#*************END***************S
