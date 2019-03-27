#$2 - addres of directory containing files: lex, yacc, zz.cm and test.in
#$1 - options
#The following options are available:
#       -r	remove all output files 
#
#       -c	compile files in directory into a.out
#
#       -e  execute a.out <*.in >*.out and print contents of *.in & *.out files into terminal sequentially
#
#		-t  test on *.test files in 8080_emulator/tests directory
CC="gcc";

if [[ $# != 2 ]]
then
	echo "Illegal number of arguments"
else
	cd $2;
	
	if [[ $1 == "-r" ]]
	then
		rm -f out.* y.* *.out lex.yy.c
		rm tests/*.out
	elif [[ $1 == "-c" ]]
	then	
		rm -f out.* y.* *.out lex.yy.c
		yacc -vtd *.y
		#lex: option -s to supress default action ECHO
		lex -s *.l
		$CC -g *.c
	elif [[ $1 = "-e" ]]
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
	elif [[ $1 = "-t" ]]
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
