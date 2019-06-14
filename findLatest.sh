

if [[ "$2" == "back" ]] ; then
	GROUP_ID=3689
elif [[ "$2" == "transformers" ]] ; then
	GROUP_ID=3850
fi

if [[ -z $1 ]] ; then
	printf "Usage for group: bash findLatest.sh -g <group> \n"
	printf "Usage for single service: bash findLatest.sh <service> \n"
	exit 1
fi

if [[ "$1" == "-g" ]] ; then
	mapfile -t REPO_NAMES < <(curl --request GET --header "PRIVATE-TOKEN:$GITLABTOKEN" https://gitlab.devops.geointservices.io/api/v4/groups/$GROUP_ID?per_page=100?simple=true | tr , '\n' | grep name | grep -v $2 | grep -v id | tr : '\n' | grep -v name | tr -d '"')
	printf "%s\n" "${REPO_NAMES[@]}"

	for SERVICENAME in "${REPO_NAMES[@]}" ; do
		echo "in the for loop"
		VERSION=$(curl -s -u bodhi:bodhi -X GET "http://hawk-trunk-dkr1:8081/service/rest/v1/search?name=bodhi/$SERVICENAME" | grep version | tail -1 | cut -c 18- | rev | cut -c 3- | rev)
		
		echo "SERVICE:VERSION is $SERVICENAME:$VERSION"

		echo "Docker pull starting..."
		docker pull hawk-trunk-dkr1:5000/bodhi/$SERVICENAME:$VERSION
		echo ""

		echo "Docker save starting..."
		docker save hawk-trunk-dkr1:5000/bodhi/$SERVICENAME:$VERSION > $SERVICENAME-$VERSION.tar.gz
		echo ""

		chmod 777 $SERVICENAME-$VERSION.tar.gz
		mv $SERVICENAME-$VERSION.tar.gz /data/bodhi/latestImages

		echo "Latest $SERVICENAME:$VERSION image is packaged in $SERVICE-$VERSION.tar"
	done	
	
	exit 0
fi	

SERVICENAME=$1
VERSION=$(curl -s -u bodhi:bodhi -X GET "http://hawk-trunk-dkr1:8081/service/rest/v1/search?name=bodhi/$SERVICENAME" | grep version | tail -1 | cut -c 18- | rev | cut -c 3- | rev)

echo "SERVICE:VERSION is $SERVICENAME:$VERSION"

docker pull hawk-trunk-dkr1:5000/bodhi/$SERVICENAME:$VERSION
docker save hawk-trunk-dkr1:5000/bodhi/$SERVICENAME:$VERSION > $SERVICENAME-$VERSION.tar.gz
chmod 777 $SERVICENAME-$VERSION.tar.gz
mv $SERVICENAME-$VERSION.tar.gz /data/bodhi/latestImages

echo "Latest $SERVICENAME:$VERSION image is packaged in $SERVICE-$VERSION.tar"
