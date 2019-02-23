%token LXI
%token MOV
%token INX
%token HLT
%token<text>REG
%token<ival>NUM
%token COMMENTS
%token PRINT_ALL


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

lines:	lines line 				{};
	|	lines COMMENTS			{};
	|	lines PRINT_ALL			{
								machine_print_all_reg();
								int indexes[] = {0,1,2,3,4,5,6,7,8,200,201,202};
								machine_print_mem_by_indexes(indexes,sizeof(indexes)/4);
								};
	|	line 					{};
	|	COMMENTS 				{};



line:	NUM ':' LXI REG ';' NUM ':' NUM ';' NUM ':' NUM ';'		
				{
				proc.mem[$1] =  (machine_get_code_of_reg($4) << 3) + machine_get_opcode_of_mnem("LXI");
				proc.mem[$6] = $8;
				proc.mem[$10] = $12;
				
				machine_set_reg_pair($4,$8,$12);
				
				};

|	NUM ':' MOV REG ',' REG ';'
				{
				if(!strcmp($4,"M")){
					proc.mem[$1] = machine_get_opcode_of_mnem("MOV") << 6 + 
								   machine_get_code_of_reg($4) << 3+
								   machine_get_code_of_reg($6);
					proc.mem[(proc.l << 3) + proc.h] = machine_get_reg($6);	
				}
				else{
						printf("mov reg reg isn't working\n");
					}
				};
|	NUM ':' INX REG ';'
				{
				machine_add_reg($4,1);
				};

%%


