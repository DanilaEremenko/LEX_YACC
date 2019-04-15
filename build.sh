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


#------------ BUILD PARAMS ---------------
MODE=$1;
DIR=$2;

#------------ BUILD PARAMS ---------------
CC="gcc";
CCFLAGS="-g -O0";
LEXFLAGS="-s";
YACCFLAGS="-vtd";




if [[ $# != 2 ]]
then
	echo "Illegal number of arguments"
else
	cd $DIR;
	
	# -------------- clean -----------
	if [[ $MODE == "-r" ]]
	then
		rm -f out.* y.* *.out lex.yy.c
		rm tests/*.out
	
	# -------------- compile ---------
	elif [[ $MODE == "-c" ]]
	then	
		# --------------- CHECK BUILDING REQUIREMENTS ----------------------------
		ERR_FLAG=0;
		
		# ----------- check flex ----------------------
		flex --version > /dev/null
		if [[ $? == 0 ]] 
		then
		        echo -e "flex... OK\n";
		else
		        echo -e "error : flex is not installed, exiting...\n"
		        ERR_FLAG = 1;
		fi
		
		# ----------- check yacc -----------------------
		yacc --version > /dev/null
		if [[ $? == 0 ]] 
		then
		        echo -e "yacc... OK\n";
		else
		        echo -e "error : yacc is not installed, exiting...\n"
		        ERR_FLAG = 1;
		fi
		
		# ----------- compile if ERR_FLAG == 0 -----------
		if [[ $ERR_FLAG == 0 ]]
		then
			rm -f out.* y.* *.out lex.yy.c
			yacc $YACCFLAGS *.y
			#lex: option -s to supress default action ECHO
			lex $LEXFLAGS *.l
			$CC $CCFLAGS -g *.c
		fi
	
	# ------------ execute ---------------
	elif [[ $MODE = "-e" ]]
	then
		for testIn in $(ls | grep "\.in" )
		do
			testOut=$( echo $testIn | cut -d . -f1 )".out"
			./a.out <$testIn >$testOut
			# echo -e "\n_________________________________________________________________\n\t$testIn\n"
			# cat $testIn
			echo -e "\n______________________________\n\t$testOut\n"
			cat $testOut
			
		done
	
	# ------------ tests ----------------
	elif [[ $MODE = "-t" ]]
	then
		echo -e "\n______________________TEST MODE________________________\n";
		cd tests;
		for testIn in $(ls | grep "\.test" )
		do
			testOut=$( echo $testIn | cut -d . -f1 )".out"
			../a.out <$testIn >$testOut
		
			if [[ $? == 0 ]]
			then		
				echo "$testIn passed";
			else
				echo "$testIn failed with code $?";
				cat $testOut | tail -n1;
			fi
			
			
			
			echo -e "\n________________________________________________________\n";
			
		done
	else
		echo "Illegal input argument"
	fi

fi

	
	