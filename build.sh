#$2 - addres of directory containing files: lex, yacc, zz.cm and test.in
#$1 - options
#The following options are available:
#       -r	remove all output files 
#
#       -c	compile files in directory into a.out
#
#       -e   	execute a.out <test.in> test.out and print them contents in terminal

if [[ $# != 2 ]]
then
	echo "Illegal number of arguments"
else
	cd $2;
	
	if [[ $1 == "-r" ]]
	then
		rm -f out.* y.* *.out lex.yy.c
	elif [[ $1 == "-c" ]]
	then	
		rm -f out.* y.* *.out lex.yy.c
		yacc -vtd *.y
		#lex: option -s to supress default action ECHO
		lex -s *.l
		cc *.c
	elif [[ $1 = "-e" ]]
	then
		for testIn in $(ls | grep "\.in" )
		do
			testOut=$( echo $testIn | cut -d . -f1 )".out"
			./a.out <$testIn >$testOut
			echo -e "\n----------------------\n\t$testIn\n"
			cat $testIn
			echo -e "\n----------------------\n\t$testOut\n"
			cat $testOut
			
		done
	else
		echo "Illegal input argument"
	fi

fi
