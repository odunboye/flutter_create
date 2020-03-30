#!/bin/bash
# flutter_create.sh
# echo "You provided $# arguments"
echo "Creating new flutter project - $1"
echo "using custom template - $2 ..."

if (($# == 2))
then
  NAME=$1
  URL=$2
  git clone $URL $NAME
  cd $NAME
  rename -t android -t ios --appname $NAME
else
  echo "Usage: flutter_create.sh [appname] [template url]"
fi