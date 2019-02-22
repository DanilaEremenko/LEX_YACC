%token<text>LXI
%token<text>MOV
%token<text>INX
%token<text>HLT
%token<text>REG
%token<ival>NUM
%token COMMENTS


%start lines 



/*-------------------------------------------------------*/

%union
{
    int ival;
    char *text;
};

%{
#include <stdio.h>
#include "machine.h"

int line_number = 0;
extern processor_8086 proc;

%}
	

/*-------------------------------------------------------*/
%%

lines:	lines line 				{printf("UNDEFINED\n");};
	|	lines COMMENTS			{printf("UNDEFINED\n");};
//	|	lines err				{printf("UNDEFINED\n");};
	|	line 					{printf("UNDEFINED\n");};
	|	COMMENTS 				{printf("UNDEFINED\n");};
//	| 	err						{printf("UNDEFINED\n");};




line:	NUM ':' NUM ';'			{machine_init_processor_8086();proc.mem[$1] = $3;machine_print_mem($1,$1+10);};



%%


