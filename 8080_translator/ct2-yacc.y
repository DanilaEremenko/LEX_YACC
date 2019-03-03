%token LXI
%token MOV
%token INX
%token HLT
%token PUSH
%token POP
%token MVI
%token ADD
%token SUB
%token DAA
%token ADC
%token LDA
%token SBB
%token DCR
%token JNZ
%token XRA
%token RAL
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
#include "macr_8080.h"

int line_number = 0;



%}
	

/*-------------------------------------------------------*/
%%

lines:	lines line 				{};
	|	lines COMMENTS			{};
	|	line 					{};
	|	COMMENTS 				{};



line:	NUM ':' LXI REG ';' NUM ':' NUM ';' NUM ':' NUM ';'		
			{		
				printf("%.3o:%.3o\n",OTD($1),(machine_get_code_of_reg($4) << 3) | 1);
				printf("%.3o:%.3o\n",OTD($6),OTD($8));
				printf("%.3o:%.3o\n",OTD($10),OTD($12));
			};
			
|	NUM ':' NUM ';'
			{
				printf("%.3o:%.3o\n",OTD($1),OTD($3)); 
			};
				

|	NUM ':' MOV REG ',' REG ';'
			{
				printf("%.3o:%.3o\n",OTD($1),(1 << 6) | 
								   		(machine_get_code_of_reg($4) << 3) |
								   		machine_get_code_of_reg($6));
			};
|	NUM ':' INX REG ';'
			{
				printf("%.3o:%.3o\n",OTD($1),(machine_get_code_of_reg($4) << 3) | 1);
			};
				
|	NUM ':' HLT ';'
			{
				printf("%.3o:%.3o\n",OTD($1),HLT_OP);
			};

|	NUM ':' PUSH REG ';'
			{
				printf("%.3o:%.3o\n",OTD($1),(3<<6) | (machine_get_code_of_reg($4)<<3) |  5);
			};
				
|	NUM ':' POP REG ';'
			{
				printf("%.3o:%.3o\n",OTD($1),(3<<6) | (machine_get_code_of_reg($4)<<3) |  5);
			};
|	NUM ':' MVI REG ';' NUM ':' NUM ';'
			{
				printf("%.3o:%.3o\n",OTD($1),(machine_get_code_of_reg($4)<<3) | 6);
				printf("%.3o:%.3o\n",OTD($6),OTD($8));
				
			};
|	NUM ':' ADD REG ';'
			{
				printf("%.3o:%.3o\n",OTD($1),(2 << 6) | machine_get_code_of_reg($4));
			};
|	NUM ':' SUB REG ';'
			{	
				printf("%.3o:%.3o\n",OTD($1),(2 << 6) | (2 << 3) | machine_get_code_of_reg($4));
			};
|	NUM ':' DAA ';'
				{	
					printf("%.3o:%.3o\n",OTD($1),DAA_OP);
				};
|	NUM ':' ADC REG';'
				{
					printf("%.3o:%.3o\n",OTD($1),(2 << 6) | (1 << 3) & machine_get_code_of_reg($4));		
				};
|	NUM ':' LDA	';' NUM ':' NUM ';' NUM ':' NUM ';'
				{
					printf("%.3o:%.3o\n",OTD($1),(0 << 6) | (7 << 3) & 2);
					printf("%.3o:%.3o\n",OTD($5),OTD($7));
					printf("%.3o:%.3o\n",OTD($9),OTD($11));
					
				};
|	NUM ':' SBB REG ';'
				{
					printf("%.3o:%.3o\n", OTD($1),(2 << 6) | (3 << 3) & machine_get_code_of_reg($4));
				};
|	NUM ':' DCR REG ';'
				{
					printf("%.3o:%.3o\n",OTD($1), (0 << 6) | machine_get_code_of_reg($4) | (5 << 0) ) ;
				};			
|	NUM ':' JNZ	';' NUM ':' NUM ';' NUM ':' NUM ';'
				{
					printf("%.3o:%.3o\n", OTD($1), (3 << 6) | (0 << 0) | (2 << 0));
					printf("%.3o:%.3o\n",OTD($5),OTD($7));
					printf("%.3o:%.3o\n",OTD($9),OTD($11));
					
				};				
|	NUM ':' XRA REG ';'
				{
					printf("%.3o:%.3o\n", OTD($1), (2 << 6) | (5 << 3) | machine_get_code_of_reg($4));
				}
|	NUM ':'	RAL ';'
				{
					printf("%.3o:%.3o\n", OTD($1), (0 << 6) | (2 << 3) | (7 << 0));
				}
%%


