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
%token JNZ
%token DCR
%token LDAX
%token STAX
%token JZ
%token JMP
%token DAD
%token SUI
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
					proc.mem[OTD($1)] = (machine_get_code_of_reg($4) << 3) | 3;
					proc.hashs[OTD($1)] = INX_H;
				};
				
|	NUM ':' DCR REG ';'
				{
					proc.mem[OTD($1)] = (machine_get_code_of_reg($4) << 3) | 5;
					proc.hashs[OTD($1)] = DCR_H;
				};
				
|	NUM ':' HLT ';'
				{
					proc.mem[OTD($1)] = (1<<6) | (6<<3) | (6<<0);
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
					proc.mem[OTD($6)] = OTD($8);
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
				
|	NUM ':' SUI ';' NUM ':' NUM ';'
				{
					proc.mem[OTD($1)] = (3 << 6) | (2 << 3) | 6;
					proc.mem[OTD($5)] = OTD($7); 
					proc.hashs[OTD($1)] = SUI_H;	
				};


|	NUM ':' DAA ';'
				{	
					proc.mem[OTD($1)] = (0<<6) | (4<<3) | (7<<0);
					proc.hashs[OTD($1)] = DAA_H;
					
				};
|	NUM ':' ADC REG';'
				{
					proc.mem[OTD($1)] = (2 << 6) | (1 << 3) | machine_get_code_of_reg($4);
					proc.hashs[OTD($1)] = ADC_H;
				};
|	NUM ':' LDA	';' NUM ':' NUM ';' NUM ':' NUM ';'
				{
					proc.mem[OTD($1)] = (0 << 6) | (7 << 3) | 2;
					proc.mem[OTD($5)] = OTD($7);
					proc.mem[OTD($9)] = OTD($11);
					proc.hashs[OTD($1)] = LDA_H;
				};
|	NUM ':' SBB REG ';'
				{
					proc.mem[OTD($1)] = (2 << 6) | (3 << 3) | machine_get_code_of_reg($4);
					proc.hashs[OTD($1)] = SBB_H;
				};
				
|	NUM ':' JNZ ';'  NUM ':' NUM ';' NUM ':' NUM ';'
				{
					proc.mem[OTD($1)] = (3 << 6) | (0 << 3) | 2;
					proc.mem[OTD($5)] = OTD($7);
					proc.mem[OTD($9)] = OTD($11);
					proc.hashs[OTD($1)] = JNZ_H;
					
				};
				
|	NUM ':' JZ	';' NUM ':' NUM ';' NUM ':' NUM ';'
				{
					proc.mem[OTD($1)] = (3 << 6) | (1 << 3) | 2;
					proc.mem[OTD($5)] = OTD($7);
					proc.mem[OTD($9)] = OTD($11);
					proc.hashs[OTD($1)] = JZ_H;
					
				};
				
|	NUM ':' JMP	';' NUM ':' NUM ';' NUM ':' NUM ';'
				{
					proc.mem[OTD($1)] = (3 << 6) | (0 << 3) | 3;
					proc.mem[OTD($5)] = OTD($7);
					proc.mem[OTD($9)] = OTD($11);
					proc.hashs[OTD($1)] = JMP_H;
					
				};

|	NUM ':' LDAX  REG ';'
				{
					proc.mem[OTD($1)] = (0 << 6) | ((1+machine_get_code_of_reg($4)) << 3) | 2;
					proc.hashs[OTD($1)] = LDAX_H;
				
				};

|	NUM ':' STAX  REG ';'
				{
					proc.mem[OTD($1)] = (0 << 6) | (machine_get_code_of_reg($4) << 3) | 2;
					proc.hashs[OTD($1)] = STAX_H;
				
				};

|	NUM ':' DAD REG	';'
				{
					proc.mem[OTD($1)] = (0 << 6) | ((1+machine_get_code_of_reg($4)) << 3) | 1;
					proc.hashs[OTD($1)] = DAD_H;
				
				};
				
|	NUM ':' NUM ';'
				{
					proc.mem[OTD($1)] = OTD($3);
				};

				
			
%%


