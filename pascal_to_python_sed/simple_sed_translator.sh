#! /bin/bash


die(){
	printf "ERROR: $*\n"
	exit 1
}

INPUT_FILE=""
OUTPUT_FILE=""
TEST_LIST=""
TEST_DIR="tests"

while getopts "i:o:t" opt; do
    case "$opt" in
    i)  INPUT_FILE=$OPTARG
        ;;
    o)  OUTPUT_FILE=$OPTARG
        ;;
    t)  TEST_LIST=$(cat $TEST_DIR/test_names.cfg | grep -v '\#')
        ;;
    \?) die "illegal option: $OPTARG" >&2
       ;;
    esac
done
if [[ $TEST_LIST ]];then
  printf "TEST MODE\n\n"
elif [[ $INPUT_FILE == "" ]];then
  die "INPUT_FILE isn't passed";
elif [[ $OUTPUT_FILE == "" ]];then
  die "OUTPUT_FILE isn't passed";
else
  touch -f $OUTPUT_FILE
fi

if [[ $TEST_LIST ]];then
  for test_name in $TEST_LIST;do
		rm -f *-res.py

		test_file="$TEST_DIR/$test_name"
    printf "$test_file\n"

		while read line ;do
			res_file="$TEST_DIR/$test_name-res.py"
			touch $res_file
			echo -e $line  >> $res_file

		done < $test_file.pas
  done
fi
