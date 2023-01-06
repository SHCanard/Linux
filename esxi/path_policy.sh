#Setting Round Robin path policy  on VMWare ESXi to avoid queuing on a single path. (https://kb.vmware.com/s/article/1017760)

for type in VMW_SATP_SYMM VMW_SATP_DEFAULT_AA VMW_SATP_ALUA_CX VMW_SATP_ALUA VMW_SATP_SVC; do esxcli storage nmp satp set --default-psp=VMW_PSP_RR --satp=$type; done

#Adjust the IOPS parameter from the default 1000 to 1 (https://kb.vmware.com/s/article/2069356):

for i in `esxcfg-scsidevs -c |awk '{print $1}' | grep naa.xxxx`; do esxcli storage nmp psp roundrobin deviceconfig set --type=iops --iops=1 --device=$i; done
