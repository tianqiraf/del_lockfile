#!/bin/bash
function getdir(){
    for element in `ls $1 --ignore={"simulation","logs_*"}`
    do  
        dir_or_file=$1"/"$element
        if [ -d $dir_or_file ]
        then 
            getdir $dir_or_file
        else
			if [[ ${dir_or_file##*/} =~ $lck_list ]];
			then
				lock_files[${#lock_files[*]}]=$dir_or_file
			fi
			let percent=$i*100/$file_count
			let i++
			printf "[%-50s][%s]\r" "$bar" "$percent"'%'
			[ $[percent/2] -gt ${#bar} ] && bar+='#'
        fi
    done
}

echo -e "Searching lck file in your workspace. Please wait..."
i=1
bar=''
percent=0
file_count=$(ls -gRU --ignore={"simulation","logs_*"} | grep "^-" | wc -l)
lock_files=()
root_dir="."
lck_list="(log|oa|cfg|sdb)\.cdslck"
getdir $root_dir $lock_files $lck_list
echo -e '\nDone!'

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


# 增加后缀expand.cfg.cdslck
# data.sdb.cdslck