#! /bin/bash

#Color Outputs
RED='\033[0;31m'
NC='\033[0m' # No Color

#Check DMARC Function
function checkDMARC() {
	dig -t txt +short _dmarc."$1" | sed 's;\(rua\).*;;' | cut -c 2-
}

#Parsing Arguments
while [ -n "$1" ]
	do
	case "$1" in
	# -l argument for list parameter
	-l)
		#Build out an array from the list given
		mapfile -t list < "$2"
		echo -e "-------------\nScanning List\n-------------"

		#Iterate through list and run our function
		for domain in "${list[@]}"; do

			result=$(checkDMARC $domain)

			#Check if output is null and print to screen
			if [ -z "$result" ]; then
				echo -e "${RED}$domain - !!!!!NOT FOUND!!!!!! ${NC}"
			else
				echo "$domain - $result"
			fi
		done
	shift ;;
	# wildcard case statement for single domain
	*)
		result=$(checkDMARC "$1")
		#Check if output is null and print to screen
		if [ -z "$result" ]; then
			echo -e "${RED}$1 - !!!!!NOT FOUND!!!!!! ${NC}"
		else
			echo "$1 - $result"
		fi
	esac
	shift
done
