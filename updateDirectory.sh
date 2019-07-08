if [[ "$1" == "d" ]] ; then 
  for d in */ ; do
    cd $d
    git stash
    git checkout master
    git pull
    git branch -D $2
    cd ..
  done
elif [[ "$1" == "b" ]] ; then
  for d in */ ; do
    cd $d
    git stash
    git checkout master
    git pull
    git checkout -b "$2"
    cd ..
  done
elif [[ "$1" == "p" ]] ; then
   for d in */ ; do
    cd $d
    git checkout master
    git pull
    cd ..
  done
else
  echo
  echo "This script: creates a new branch, deletes a branch, or pulls from master"
  echo
  echo "To delete a branch, argument 1 is 'd' and argument 2 is the branch name."
  echo "To create a branch, argument 1 is 'b' and argument 2 is the branch name."
  echo "To pull from master, argument 1 is 'p'."
  echo 
fi	

