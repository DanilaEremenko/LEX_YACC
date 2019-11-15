#$2 - addres of directory containing files: lex, yacc, zz.cm and test.in
#$1 - mode
#The following modes are available:
#       -r	remove all output files
#
#       -c	compile files in directory into a.out
#
#       -e  execute a.out <*.in >*.out and print contents of *.in & *.out files into terminal sequentially
#
#		-t  test on *.test files in 8080_emulator/tests directory

die(){
	printf "ERROR: $*\n"
	exit 1
}



#------------ BUILD PARAMS ---------------
MODE=$1;

#------------ BUILD PARAMS ---------------
CC="gcc";
CCFLAGS="-g -O0";
LEXFLAGS="-s";
YACCFLAGS="-vtd";




if [[ $# != 1 ]];then die "Illegal number of arguments";fi


# -------------- clean -----------
if [[ $MODE == "-r" ]];then
	rm -f out.* y.* *.out lex.yy.c
	rm -f tests/*.out

# -------------- compile ---------
elif [[ $MODE == "-c" ]];then
	# --------------- CHECK BUILDING REQUIREMENTS ----------------------------
	ERR_FLAG=0;

	# ----------- check flex ----------------------
	flex --version > /dev/null
	if [[ $? == 0 ]];then
	        echo -e "flex... OK\n";
	else
	        echo -e "error : flex is not installed, exiting...\n"
	        ERR_FLAG = 1;
	fi

	# ----------- check yacc -----------------------
	yacc --version > /dev/null
	if [[ $? == 0 ]];then
	        echo -e "yacc... OK\n";
	else
	        echo -e "error : yacc is not installed, exiting...\n"
	        ERR_FLAG = 1;
	fi

	# ----------- compile if ERR_FLAG == 0 -----------
	if [[ $ERR_FLAG == 0 ]];then
		rm -f out.* y.* *.out lex.yy.c
		yacc $YACCFLAGS *.y
		#lex: option -s to supress default action ECHO
		lex $LEXFLAGS *.l
		$CC $CCFLAGS -g *.c
	fi

# ------------ execute ---------------
elif [[ $MODE = "-e" ]];then
		echo -e "execute mode does't realized\n"
		echo -e "\n______________________________\n\t$testOut\n"

# ------------ tests ----------------
elif [[ $MODE = "-t" ]];then
	echo -e "\n______________________TEST MODE________________________\n";
	cd tests;
	for test_name in $(cat 'test_names.cfg' | grep -v '\#');do
		echo -e "$test_name\n"
		../a.out < $test_name.pas > $test_name-res.py

	done

	echo -e "\n________________________________________________________\n";

else
	echo "Illegal input argument"
fi
