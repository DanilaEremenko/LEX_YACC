#! /bin/bash


############################## USEFUL ##########################################
die(){
	printf "ERROR: $*\n"
	exit 1
}

pretty_print(){
	printf "\n--------------------\n$*\n-----------------------\n"
}


############################## MAIN LOGIC PART #################################
translate_file(){
	pas_file=$1
	py_file=$2
	rm -f $py_file
	touch $py_file

	tabs=""
	new_tabs=""
	old_tabs=""
	prev_func=""
	prev_if=""
	line_i=0
	#------------------------ TRANSLATE FILE LOOP ------------------------------
	while read line ;do
		target_line="$line"
		#-------------------- COMMENTS PROCESSING --------------------------------
		if [[ $(echo $line | sed 's/ *//' | cut -c1-2) == '//' ]];then
			pretty_print $line_i "COMMENT LINE:'$line' -> '$target_line'"

		#-------------------- IF PROCESSING --------------------------------------
		elif [[ $(echo $line | grep 'if') ]];then
			target_line=$(echo $target_line | sed 's/ then/:/')
			pretty_print $line_i "IF LINE:'$line' -> '$target_line'"

			if [[ $(echo $target_line | grep ';') ]];then prev_if=""
			else prev_if="true";new_tabs="$tabs\t";fi

		#-------------------- BEGIN PROCESSING -------------------------------------
		elif [[ $(echo $line | grep 'begin') ]];then
			target_line=$(echo $target_line | sed 's/begin//')
			pretty_print $line_i "BEGIN LINE:'$line' -> '$target_line'"

			if [[ $prev_func || $prev_if ]];then prev_func="";prev_if="";
			else new_tabs="$tabs\t";fi

		#-------------------- FUNCTION PROCESSING ----------------------------------
		elif [[ $(echo $line | grep 'function') ]];then
			target_line="$(echo $target_line | sed 	-e 's/function/def/'\
																							-e 's/).*;/)/'\
																							-e 's/:.*;/,/'\
																							-e 's/:.*)/)/'\
																							):"
			pretty_print $line_i "FUNCTION LINE:'$line' -> '$target_line'"

			new_tabs="$tabs\t"
			prev_func="true"

		#-------------------- PROCEDURE PROCESSING ---------------------------------
		elif [[ $(echo $line | grep 'procedure') ]];then
			target_line="$(echo $target_line | sed 	-e 's/procedure/def/'\
																							-e 's/).*;/)/'\
																							-e 's/:.*;/,/'\
																							-e 's/:.*)/)/'\
																							):"
			pretty_print $line_i "FUNCTION LINE:'$line' -> '$target_line'"

			new_tabs="$tabs\t"
			prev_func="true"
		#-------------------- VAR INT PROCESSING -----------------------------------
		elif [[ $(echo $line | grep ': integer') ]];then
			target_line="$(echo $target_line | sed 	-e 's/var //'\
																							-e 's/,/ =/g'\
																							-e 's/\: .*;/= 0/'\
																							)"
			pretty_print $line_i "VAR INT LINE:'$line' -> '$target_line'"

		#-------------------- VAR DOUBLE PROCESSING --------------------------------
		elif [[ $(echo $line | grep ': double') ]];then
			target_line="$(echo $target_line | sed 	-e 's/var //'\
																							-e 's/,/ =/g'\
																							-e 's/\: .*;/= 0.0/'\
																							)"
			pretty_print $line_i "VAR DOUBLE LINE:'$line' -> '$target_line'"

		#-------------------- VAR REAL PROCESSING ----------------------------------
		elif [[ $(echo $line | grep ': real') ]];then
			target_line="$(echo $target_line | sed 	-e 's/var //'\
																							-e 's/,/ =/g'\
																							-e 's/\: .*;/= 0.0/'\
																							)"
			pretty_print $line_i "VAR REAL LINE:'$line' -> '$target_line'"

		#-------------------- VAR REAL PROCESSING -------------------------------------
		elif [[ $(echo $line | grep ': array of') ]];then
			target_line="$(echo $target_line | sed 	-e 's/: array of .*/ = []/')"
			pretty_print $line_i "ARRAY DECL LINE:'$line' -> '$target_line'"



		#-------------------- END PROCESSING -------------------------------------
		elif [[ $(echo $line | grep 'end') ]];then
			target_line=$(echo $target_line | sed 's/end;//')
			pretty_print $line_i "END LINE:'$line' -> '$target_line'"

			new_tabs=$(echo $tabs | cut -c3-)


		#-------------------- REPEAT PROCESSING ----------------------------------
		elif [[ $(echo $line | grep 'repeat') ]];then
			target_line=$(echo $target_line | sed 's/repeat/while(True):/')
			pretty_print $line_i "REPEAT LINE:'$line' -> '$target_line'"

			new_tabs="$tabs\t"

		#-------------------- UNTILL PROCESSING ----------------------------------
		elif [[ $(echo $line | grep 'until') ]];then
			target_line=$(echo $target_line | sed -e 's/until/if/'\
																						-e 's/;/:/')
			target_line="$target_line\n$tabs\tbreak"
			pretty_print $line_i "UNTIL LINE:'$line' -> '$target_line'"
			new_tabs=$(echo $tabs | cut -c3-)

		#-------------------- CHECK  PREV IF -------------------------------------
		elif [[ $prev_if ]];then
			prev_if=""
			new_tabs=$(echo $tabs | cut -c3-)
		else
			pretty_print $line_i "LINE:'$line' -> '$target_line'"
		fi

		target_line=$(echo "$target_line" | sed -e 's/:=/=/' -e 's/;//' -e 's/\/\//#/')

		echo -e "$tabs$target_line"  >> $py_file

		old_tabs=$tabs
		tabs=$new_tabs
		((line_i++))
	done < $pas_file


}

############################## ARGS PARSING ####################################
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
	#------------------------ MAKE TESTS -----------------------------------------
	tpassed_num=0
	tpassed_list=""

	tfailed_num=0
	tfailed_list=""

	tfull_num=0

	rm -f $TEST_DIR/*-res.py

	for test_name in $TEST_LIST;do

		#------------------------ PREPARE FOR TRANSLATION --------------------------
		test_file="$TEST_DIR/$test_name"
    printf "$test_file\n"
		res_file="$TEST_DIR/$test_name-res.py"

		translate_file $test_file.pas $res_file


		#-------------------------- CHECK TEST ---------------------------------------
		diff_test=$(diff "$TEST_DIR/$test_name-exp.py" "$TEST_DIR/$test_name-res.py")

		if [[ $diff_test ]];then
			((tfailed_num++))
			tfailed_list="$tfailed_list $test_name,"
		else
			((tpassed_num++))
			tpassed_list="$tpassed_list $test_name,"
		fi
		((tfull_num++))
	done

	printf "\n\n#################### TEST RESULTS ############################\n\n"
	printf "PASSED_NUM = $tpassed_num\n"
	printf "PASSED_LIST = $tpassed_list\n\n"
	printf "FAILED_NUM = $tfailed_num\n"
	printf "FAILED_LIST = $tfailed_list\n\n"
fi
