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
%token<text>REG
%token<ival>NUM
%token COMMENTS
%token END

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
int verbose = 1;
extern processor_8086 proc;



%}
	

/*-------------------------------------------------------*/
%%

lines:	lines line 				{};
	|	lines COMMENTS			{};
	|	lines END				{execute_all();}
	|	line 					{};
	|	COMMENTS 				{};
	|	END						{};



line:	NUM ':' LXI REG ';' NUM ':' NUM ';' NUM ':' NUM ';'		
				{
					proc.mem[OTD($1)] =  (0<<6) | (machine_get_code_of_reg($4) << 3) | 1;
					proc.mem[OTD($6)] = OTD($8);
					proc.mem[OTD($10)] = OTD($12);
					proc.hashs[OTD($1)] = LXI_H;
				};

|	NUM ':' MOV REG ',' REG ';'
				{
						proc.mem[OTD($1)] = (1 << 6) | 
									   		(machine_get_code_of_reg($4) << 3) |
									   		machine_get_code_of_reg($6);
						proc.hashs[OTD($1)] = MOV_H;
					
				};
|	NUM ':' INX REG ';'
				{
					proc.mem[OTD($1)] = (machine_get_code_of_reg($4) << 3) | INX_OP;
					proc.hashs[OTD($1)] = INX_H;
				};
				
|	NUM ':' HLT ';'
				{
					proc.mem[OTD($1)] = HLT_OP;
					proc.hashs[OTD($1)] = HLT_H;		
				};

|	NUM ':' PUSH REG ';'
				{
					proc.mem[OTD($1)] = (3<<6) | (machine_get_code_of_reg($4)<<3) |  5;
					proc.hashs[OTD($1)] = PUSH_H;
				};
				
|	NUM ':' POP REG ';'
				{
					proc.mem[OTD($1)] = (3<<6) | (machine_get_code_of_reg($4)<<3) |  1;
					proc.hashs[OTD($1)] = POP_H;
				};
|	NUM ':' MVI REG ';' NUM ':' NUM ';'
				{
					proc.mem[OTD($1)] = (machine_get_code_of_reg($4)<<3) | 6;
					proc.hashs[OTD($1)] = MVI_H;
				};
|	NUM ':' ADD REG ';'
				{
					proc.mem[OTD($1)] = (2 << 6) | machine_get_code_of_reg($4);
					proc.hashs[OTD($1)] = ADD_H;	
					
				};
|	NUM ':' SUB REG ';'
				{
					proc.mem[OTD($1)] = (2 << 6) | (2 << 3) | machine_get_code_of_reg($4);
					proc.hashs[OTD($1)] = SUB_H;	
				};
|	NUM ':' DAA ';'
				{	
					proc.mem[OTD($1)] = DAA_OP;
					proc.hashs[OTD($1)] = DAA_H;
					
				};
|	NUM ':' ADC REG';'
				{
					proc.mem[OTD($1)] = (2 << 6) & (1 << 3) & machine_get_code_of_reg($4);
					proc.hashs[OTD($1)] = ADC_H;
				};
|	NUM ':' LDA	';' NUM ':' NUM ';' NUM ':' NUM ';'
				{
					proc.mem[OTD($1)] = (0 << 6) & (7 << 3) & 2;
					proc.hashs[OTD($1)] = LDA_H;
				};
|	NUM ':' SBB REG ';'
				{
					proc.mem[OTD($1)] = (2 << 6) & (3 << 3) & machine_get_code_of_reg($4);
					proc.hashs[OTD($1)] = SBB_H;
				};

				
			
%%


