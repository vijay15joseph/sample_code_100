#!/bin/bash
#  Assumes "cleaned-up" directory created in the root folder in cloud storage bucket and populated with json files.
# repalce the BQ project name and data set name.
upload_bq () {
    shopt -s nullglob dotglob
	
    for pathname in "$1"/*; do
        if [ -d "$pathname" ]; then
		       if [[ "$pathname" =~ [0-9]+$ ]]; then #only numbers
	          myarray=(`find $pathname -maxdepth 1 -name "*.json"`)	  
              if [ ${#myarray[@]} -gt 0 ]; then 
	             printf '%s -- %s\n' "$table_name,$pathname"	
				 gspath=${pathname#./}
				 table_name=(`echo ${table_name//*.}`)	
				 # repalce the BQ project name and data set name. ********
				 bqloadcommands1="bq load --autodetect --noreplace --source_format NEWLINE_DELIMITED_JSON <projectname>:<bq_dataset>.$table_name gs://se4-pg/dev-branch/cleaned-up/$gspath/"
				 echo "$bqloadcommands1*.json">>bqloadcommands.sh
				 				 
	          fi
  	    	elif [[ !("$pathname" =~ [0-9]+$) ]]; then
 			  table_name="${pathname##*/}"	
			  printf 'table_name - %s\n' "$table_name"
           fi
			walk_dir "$pathname"
        fi
    done
	
}

gsutil -m cp -r gs://se4-pg/dev-branch/cleaned-up .
cd cleaned-up
upload_bq "."
echo $count >> bqloadcommands.sh
chmod 777 bqloadcommands.sh
./bqloadcommands.sh
cd ..
rm -rf cleaned-up