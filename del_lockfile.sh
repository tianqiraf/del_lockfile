#!/bin/bash
function getdir(){
    for element in `ls $1`
    do  
        dir_or_file=$1"/"$element
        if [ -d $dir_or_file ]
        then 
            getdir $dir_or_file
        else
			if [[ ${dir_or_file##*/} =~ ".oa.cdslck" ]] || [[ ${dir_or_file##*/} = "CDS.log.cdslck" ]];
			then
				lock_files[${#lock_files[*]}]=$dir_or_file
			fi
        fi
    done
}
echo -e "Searching lck file in your workspace. Please wait...\n"
lock_files=()
root_dir="."
getdir $root_dir $lock_files

if [ ${#lock_files[*]} -eq 0 ]; then
	echo "There is no lck file in your workspace~"
	echo "Exting..."
else
	for var in ${lock_files[@]}
	do
	   echo $var
	done
	echo ""
	read -r -p "Are you sure to delete these files? [Y/n] " input
	echo ""
	case $input in
		[yY][eE][sS]|[yY])
			for var in ${lock_files[@]}
			do
			   rm -f $var
			   echo $var
			   echo "File has been delete!"
			done
			;;
		*)
			echo "Operation cancelled!"
			exit 1
			;;
	esac
fi


