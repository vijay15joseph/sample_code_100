#!/bin/bash
# This script download the script from Cloudstorage bucket 
#Pre-requisite:
#   -- create "cleaned-up" folder in the cloud storage location after downloading the files from playfab first time.#
unzip_trasnform_json () {
    shopt -s nullglob dotglob

    for pathname in "$1"/*; do
        if [ -d "$pathname" ]; then
			echo $pathname
            walk_dir "$pathname"
        elif [[ $pathname =~ \.gz$ ]]; then
            printf '%s\n' "$pathname"
            newfilename=${pathname//"jsonstream.gz"/"json"}
            newlinejsonfile=${newfilename//".json"/"-bq.json"}
            printf '%s\n' "$newfilename"
            printf '%s\n' "$newlinejsonfile"
            gunzip -c  $pathname > $newfilename #unzip
            jq -c . $newfilename  > $newlinejsonfile # remove new line delimiter
            rm $newfilename # remove old file
            newlinejsondir=$(echo $newlinejsonfile | sed 's|\(.*\)/.*|\1|') 
            echo $newlinejsondir 
        fi
    done
}


sudo apt-get update -y # install jq dependency.
sudo apt-get install -y jq
gsutil -m cp -r gs://se4-pg/dev-branch/4d9f3 . # download the .gz files from cloud storage
cd 4d9f3
unzip_trasnform_json "."  # call the function to unzip and remove new line character.
find . -name "*.gz" -type f -delete # delete the zip files
gsutil -m cp -r ./  gs://se4-pg/dev-branch/cleaned-up  #upload the json files to cleaned-up folder in 
cd ..
rm -rf 4d9f3