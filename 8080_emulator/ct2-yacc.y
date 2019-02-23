%token LXI
%token MOV
%token INX
%token HLT
%token PUSH
%token POP
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

lines:	lines line 				{};
	|	lines COMMENTS			{};
	|	line 					{};
	|	COMMENTS 				{};



line:	NUM ':' LXI REG ';' NUM ':' NUM ';' NUM ':' NUM ';'		
				{
				proc.mem[OTD($1)] =  (machine_get_code_of_reg($4) << 3) + machine_get_opcode_of_mnem("LXI");
				proc.mem[OTD($6)] = OTD($8);
				proc.mem[OTD($10)] = OTD($12);
				machine_set_reg_pair($4,OTD($8),OTD($12));
				
				};

|	NUM ':' MOV REG ',' REG ';'
				{
				if(!strcmp($4,"M")){
					proc.mem[OTD($1)] = (machine_get_opcode_of_mnem("MOV") << 6) + 
								   (machine_get_code_of_reg($4) << 3)+
								   machine_get_code_of_reg($6);
					proc.mem[(proc.l << 3) + proc.h] = machine_get_reg($6);	
				}
				else{
						printf("mov reg reg isn't working\n");
					}
				};
|	NUM ':' INX REG ';'
				{
				proc.mem[OTD($1)] = (machine_get_code_of_reg($4) << 3)+ INX_OP;
				machine_add_reg($4,1);
				};
				
|	NUM ':' HLT ';'
				{
				proc.mem[OTD($1)] = HLT_OP;
				
				printf("----------regs----------\n");
				machine_print_all_reg();
				
				printf("----------mem---------\n");
				int indexes[] = {0,1,2,3,4,5,6,7,10,11,129,130};//must be defined manually
				machine_print_mem_by_indexes(indexes,sizeof(indexes)/4);
				//machine_print_mem(0,200);
				};

|	NUM ':' PUSH REG ';'
				{
				proc.mem[OTD($1)] = (3<<6) + (machine_get_code_of_reg($4)<<3) +  5;
				
				int *reg_pair = malloc(sizeof(int)*2);
				*reg_pair = machine_get_reg_pair($4);
				printf("pair = %d %d\n",reg_pair[0],reg_pair[1]);
				printf("addrs = %d %d\n",proc.sp,proc.sp-1);
				proc.mem[proc.sp] = reg_pair[0];
				proc.mem[proc.sp-1] = reg_pair[1];
				proc.sp-=2;
				};
				
|	NUM ':' POP REG ';'
				{
				proc.mem[OTD($1)] = (3<<6) + (machine_get_code_of_reg($4)<<3) +  1;
				machine_set_reg_pair($4, proc.mem[OTD(proc.sp+1)], proc.mem[OTD(proc.sp+2)]);
				proc.sp+=2;
				};
%%


