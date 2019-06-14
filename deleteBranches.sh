
for d in */ ; do
	cd $d
	git checkout master
	git pull
	git branch -D "$1"
	if [[ !(-z $2) ]] ; then
		git branch -D "$2"
	fi
	if [[ !( -z $3 ) ]] ; then
		git branch -D "$2"
	fi
	if [[ !( -z $4 ) ]] ; then
		git branch -D "$2"
	fi
	if [[ !( -z $5 ) ]] ; then
		git branch -D "$2"
	fi
	if [[ !( -z $6 ) ]] ; then
		git branch -D "$2"
	fi
	cd ..
done