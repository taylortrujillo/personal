list=()
for d in */ ; do
    cd $d
    git stash
    git checkout master
    git pull
    if [[ ! -z $(cat build.gradle | grep "lang3") ]] ; then
        list+=( $d )
    fi
    cd ..
done
printf '%s\n' "${list[@]}"
