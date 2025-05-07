#!/bin/bash
function list_mac {
	lsusb | sort | uniq
}
list_mac | tee mac_block_list.txt
while true
do
	NEW_MAC_LIST=`lsusb | sort | uniq | grep -v -F -f mac_block_list.txt`
	RETCODE=$?
	if [ ${RETCODE} -ne 0 ]
	then
		echo "not found"
	else
		echo "found"
        echo "${NEW_MAC_LIST}" | xargs -I {} -- bash -c 'echo {} && FNAME="$(echo {} | base32 -w 0).txt" && echo $FNAME && lsusb -v -s $(echo {} | cut -d " " -f 2,4 | sed -e "s/://" -e "s/ /:/") > $FNAME && echo "{}" >> mac_block_list.txt'
	fi
	sleep 1
done
