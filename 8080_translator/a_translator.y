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
%token JZ
%token JNC
%token JC
%token JPO
%token JPE
%token JP
%token JM
%token JMP
%token CALL
%token RET
%token RST
%token STAX
%token LDAX
%token DAD
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
				printf("%.3o:%.3o\n",OTD($1),(3<<6) | (machine_get_code_of_reg($4)<<3) |  (5 << 0));
			};
				
|	NUM ':' POP REG ';'
			{
				printf("%.3o:%.3o\n",OTD($1),(3<<6) | (machine_get_code_of_reg($4)<<3) |  (1 << 0));
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
|	NUM ':' SUB ';'
			{	
				printf("%.3o:%.3o\n",OTD($1),(3 << 6) | (2 << 3) | (6 << 0));
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
					printf("%.3o:%.3o\n", OTD($1), (3 << 6) | (0 << 3) | (2 << 0));
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
				
|	NUM ':' JZ	';' NUM ':' NUM ';' NUM ':' NUM ';'
				{
					printf("%.3o:%.3o\n", OTD($1), (3 << 6) | (1 << 3) | (2 << 0));
					printf("%.3o:%.3o\n",OTD($5),OTD($7));
					printf("%.3o:%.3o\n",OTD($9),OTD($11));
					
				};
|	NUM ':' JNC	';' NUM ':' NUM ';' NUM ':' NUM ';'
				{
					printf("%.3o:%.3o\n", OTD($1), (3 << 6) | (2 << 3) | (2 << 0));
					printf("%.3o:%.3o\n",OTD($5),OTD($7));
					printf("%.3o:%.3o\n",OTD($9),OTD($11));
					
				};
|	NUM ':' JC	';' NUM ':' NUM ';' NUM ':' NUM ';'
				{
					printf("%.3o:%.3o\n", OTD($1), (3 << 6) | (3 << 3) | (2 << 0));
					printf("%.3o:%.3o\n",OTD($5),OTD($7));
					printf("%.3o:%.3o\n",OTD($9),OTD($11));
					
				};

|	NUM ':' JPO	';' NUM ':' NUM ';' NUM ':' NUM ';'
				{
					printf("%.3o:%.3o\n", OTD($1), (3 << 6) | (4 << 3) | (2 << 0));
					printf("%.3o:%.3o\n",OTD($5),OTD($7));
					printf("%.3o:%.3o\n",OTD($9),OTD($11));
					
				};
|	NUM ':' JPE	';' NUM ':' NUM ';' NUM ':' NUM ';'
				{
					printf("%.3o:%.3o\n", OTD($1), (3 << 6) | (5 << 3) | (2 << 0));
					printf("%.3o:%.3o\n",OTD($5),OTD($7));
					printf("%.3o:%.3o\n",OTD($9),OTD($11));
					
				};
|	NUM ':' JP	';' NUM ':' NUM ';' NUM ':' NUM ';'
				{
					printf("%.3o:%.3o\n", OTD($1), (3 << 6) | (6 << 3) | (2 << 0));
					printf("%.3o:%.3o\n",OTD($5),OTD($7));
					printf("%.3o:%.3o\n",OTD($9),OTD($11));
					
				};
|	NUM ':' JM	';' NUM ':' NUM ';' NUM ':' NUM ';'
				{
					printf("%.3o:%.3o\n", OTD($1), (3 << 6) | (7 << 3) | (2 << 0));
					printf("%.3o:%.3o\n",OTD($5),OTD($7));
					printf("%.3o:%.3o\n",OTD($9),OTD($11));
					
				};
|	NUM ':' JMP	';' NUM ':' NUM ';' NUM ':' NUM ';'
				{
					printf("%.3o:%.3o\n", OTD($1), (3 << 6) | (0 << 3) | (3 << 0));
					printf("%.3o:%.3o\n",OTD($5),OTD($7));
					printf("%.3o:%.3o\n",OTD($9),OTD($11));
					
				};
				
|	NUM ':' CALL ';' NUM ':' NUM ';' NUM ':' NUM ';'
				{
					printf("%.3o:%.3o\n", OTD($1), (3 << 6) | (1 << 3) | (5 << 0));
					printf("%.3o:%.3o\n",OTD($5),OTD($7));
					printf("%.3o:%.3o\n",OTD($9),OTD($11));
				};
|	NUM ':' RET ';'	
				{
					printf("%.3o:%.3o\n", OTD($1), (3 << 6) | (1 << 3) | (1 << 0));
				};
|	NUM ':' RST NUM ';'
				{
					printf("%.3o:%.3o\n", OTD($1), (3 << 6) | ($4 << 3) | (7 << 0));
				}
|	NUM ':'	LDAX REG ';'
				{
					printf("%.3o:%.3o\n", OTD($1), (0 << 6) | (1 + (machine_get_code_of_reg($4))) << 3 | (2 << 0));
				}
|	NUM ':'	STAX REG ';'
				{
					printf("%.3o:%.3o\n", OTD($1), (0 << 6) | (machine_get_code_of_reg($4) << 3) | (2 << 0));
				}
|	NUM ':'	DAD REG ';'
				{
					printf("%.3o:%.3o\n", OTD($1), (0 << 6) | (1 + machine_get_code_of_reg($4)) << 3 | (1 << 0));
				}
			
%%


