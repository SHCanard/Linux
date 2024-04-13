#!/bin/bash

# Define usage function
usage() {
  echo "Usage: $0 --host REMOTE_HOST --ips EXPECTED_IPS [--help]"
  echo "  --host REMOTE_HOST: hostname of remote host"
  echo "  --ips EXPECTED_IPS: comma-separated list of expected IP addresses for the hostname"
  echo "  --help: display this help message"
  echo ""
  echo "Example:"
  echo " $0 --host alias-to-prod --ips 10.0.0.1,10.0.0.2
  exit 1
}

# Parse command line arguments
while [[ $# -gt 0 ]]; do
  key="$1"
  case $key in
    --host)
      REMOTE_HOST="$2"
      shift
      shift
      ;;
    --ips)
      EXPECTED_IPS="$2"
      shift
      shift
      ;;
    --help)
      usage
      shift
      # ;;
    *)
      echo "Unknown option: $key"
      usage
      exit 1
      ;;
  esac
done

# Check if REMOTE_HOST is set
if [ -z "$REMOTE_HOST" ]; then
  usage
  exit 1
fi

# Check if EXPECTED_IPS is set
if [ -z "$EXPECTED_IPS" ]; then
  usage
  exit 1
fi

# Convert comma-separated list of IPs to an array
IFS=',' read -ra EXPECTED_IPS_ARRAY <<< "$EXPECTED_IPS"

# Use the REMOTE_HOST variable in subsequent commands
echo "Host specified is ${REMOTE_HOST}"

# Use the EXPECTED_IPS variable in subsequent commands
echo "IPs specified are ${EXPECTED_IPS_ARRAY[@]}"

remoteIP=$(nslookup "${REMOTE_HOST}" | grep "Address" | awk 'FNR==2{print ($2)}')

IPmatch=false

for ip in ${EXPECTED_IPS_ARRAY[@]}; do
    if [[ "${ip}" == "${remoteIP}" ]]; then
        echo "IP address ${remoteIP} is expected for ${REMOTE_HOST} :)"
        IPmatch=true
        break
    else
        echo "IP address ${remoteIP} is not expected for ${REMOTE_HOST}!!!"
    fi
done

if [[ "${IPmatch}" == true ]]; then
    curKey=$(ssh-keyscan -t ecdsa "${REMOTE_HOST}" 2> /dev/null | awk '{print ($3)}')
    regKey=$(cat .ssh/known_hosts | grep "${REMOTE_HOST}" | awk '{print ($3)}')
    if [[ "${curKey}" != "${regKey}" ]]; then
        echo "Updating known_hosts file for ${REMOTE_HOST}"
        ssh-keygen -R "${REMOTE_HOST}" >/dev/null 2>&1
        ssh-keyscan -t ecdsa "${REMOTE_HOST}" 2> /dev/null >> ~/.ssh/known_hosts
    else
        echo "Both EDSA keys match, nothing to do..."
    fi
fi
