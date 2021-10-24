#!/bin/bash
# echo "Hello ${1}"

all=($(ls ./models))

# cmd="node ${1}"


# migra='.migration.log'

date=`date +"%Y-%m-%d"`
# touch ./migrations/${date}`ls file* | wc -l`.js
touch ./migrations/$date.js
echo $date
mkdir ./migrations/migrated-$date
cp ./models/mongoose.js ./migrations/$date.js
for file in ${all[@]}
do
    if [ $file != "mongoose.js" ] ; then
        mv ./models/$file ./migrations/migrated-$date
        path="await require('../migrations/migrated-$date/${file}');"
        sed -i "19i $path" ./migrations/$date.js 
    fi
done

#ESTO SE HACE AL FINAL, se agregan los respectivos requires y se corre el archivo
cmd="node ./migrations/$date.js"
echo $cmd
$cmd
