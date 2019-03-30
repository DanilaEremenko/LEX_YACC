%token LXI
%token MOV
%token INX
%token INR
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
%token OUT
%token ANI
%token ADI
%token RRC
%token RLC
%token CALL
%token RET
%token<text>REG
%token<ival>NUM
%token COMMENTS
%token EXEC
%token FROM
%token TO
%token ASSERT
%token T
%token TEST


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
#include "y.tab.h"

extern processor_8086 proc;
extern int test_mem[];

int line_number = 0;

#define MAX_MEM_AREAS_NUM 10

int from[MAX_MEM_AREAS_NUM];
int to[MAX_MEM_AREAS_NUM];

int ft_size = 0;

int tfrom[MAX_MEM_AREAS_NUM];
int tto[MAX_MEM_AREAS_NUM];

int tft_size = 0;






%}
	

/*-------------------------------------------------------*/
%%

lines:	lines line 				{};
	|	lines COMMENTS			{};
	|	lines EXEC				{execute_all(&from[0],&to[0],ft_size);}
	|	lines TEST				{execute_all(&from[0],&to[0],ft_size); test_all(&tfrom[0],&tto[0],tft_size);}
	|	line 					{};
	|	COMMENTS 				{};
	|	EXEC					{};



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
				
|	NUM ':' INR REG ';'
				{
					proc.mem[OTD($1)] = (machine_get_code_of_reg($4) << 3) | 4;
					proc.hashs[OTD($1)] = INR_H;
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
				
|	NUM ':' CALL ';' NUM ':' NUM ';' NUM ':' NUM ';'
				{
					proc.mem[OTD($1)] = (3 << 6) | (1 << 3) | 5;
					proc.mem[OTD($5)] = OTD($7);
					proc.mem[OTD($9)] = OTD($11);
					proc.hashs[OTD($1)] = CALL_H;
					
				};
				
|	NUM ':' RET ';'
				{
					proc.mem[OTD($1)] = (3 << 6) | (1 << 3) | 1;
					proc.hashs[OTD($1)] = RET_H;
					
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

|	NUM	':'	OUT ';' NUM ':' NUM ';'
				{
					proc.mem[OTD($1)] = (3<<6) | (2<<3) | 3;
					proc.mem[OTD($5)] = OTD($7);
					proc.hashs[OTD($1)] = OUT_H;
				
				};
				
|	NUM ':' ANI ';' NUM ':' NUM ';'
				{
					proc.mem[OTD($1)] = (3<<6) | (4<<3) | 6;
					proc.mem[OTD($5)] = OTD($7);
					proc.hashs[OTD($1)] = ANI_H;
				};
				
|	NUM ':' ADI ';' NUM ':' NUM ';'
				{
					proc.mem[OTD($1)] = (3<<6) | (0<<3) | 6;
					proc.mem[OTD($5)] = OTD($7);
					proc.hashs[OTD($1)] = ADI_H;
				};
|	NUM ':' RRC ';'
				{				
					proc.mem[OTD($1)] = (0<<6) | (1<<3) | 7;
					proc.hashs[OTD($1)] = RRC_H;
				};
				
|	NUM ':' RLC ';'
				{				
					proc.mem[OTD($1)] = (0<<6) | (0<<3) | 7;
					proc.hashs[OTD($1)] = RLC_H;
				};
				
				
|	NUM ':' NUM ';'
				{
					proc.mem[OTD($1)] = OTD($3);
				};
|	FROM NUM TO NUM ';'
				{
					if(ft_size < MAX_MEM_AREAS_NUM){
						from[ft_size] 	= OTD($2);
						to[ft_size] 	= OTD($4);
						ft_size++;
					}else
						printf("error:trying to print more mem areas that allowed\n");
				};

|	ASSERT NUM NUM ';'
				{
				
					if(ft_size < MAX_MEM_AREAS_NUM){
						tfrom[tft_size] 	= OTD($2);
						tto[tft_size] 		= OTD($3);
						tft_size++;
					}else
						printf("error:trying to print more mem areas that allowed\n");
				
				
				};


|	T ':' NUM ':' NUM ';'
				{	
					test_mem[OTD($3)] = OTD($5);
				};


		
		
		
			
%%


