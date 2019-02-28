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
	|	line 					{};
	|	COMMENTS 				{};



line:	NUM ':' LXI REG ';' NUM ':' NUM ';' NUM ':' NUM ';'		
				{
					proc.mem[OTD($1)] =  (machine_get_code_of_reg($4) << 3) | machine_get_opcode_of_mnem("LXI");
					proc.mem[OTD($6)] = OTD($8);
					proc.mem[OTD($10)] = OTD($12);
					machine_set_reg_pair($4,OTD($8),OTD($12));
					
					if(verbose)
						print_inf_8080($1);
				
				};

|	NUM ':' MOV REG ',' REG ';'
				{
					if(!strcmp($4,"M")){
						proc.mem[OTD($1)] = (MOV_OP << 6) | 
									   		(machine_get_code_of_reg($4) << 3) |
									   		machine_get_code_of_reg($6);
						proc.mem[(proc.h << 8) & proc.l] = machine_get_reg($6);	
					}
					else{
							printf("mov reg reg isn't working\n");
					}
					
					
					if(verbose)
						print_inf_8080($1);
				};
|	NUM ':' INX REG ';'
				{
					proc.mem[OTD($1)] = (machine_get_code_of_reg($4) << 3) | INX_OP;
					
					machine_update_reg_pair($4);
					proc.reg_pair[0]++;
					proc.reg_pair[1]++;
					machine_set_reg_pair($4,proc.reg_pair[0],proc.reg_pair[1]);
					
					
					if(verbose)
						print_inf_8080($1);
				};
				
|	NUM ':' HLT ';'
				{
					
					if(verbose)
						print_inf_8080($1);
					
					proc.mem[OTD($1)] = HLT_OP;
					
					printf("----------regs----------\n");
					machine_print_all_reg();
					
					
					/*must be defined manually*/
					int from[] = {OTD(0),OTD(160)};
					int to[] = {OTD(20),OTD(200)};
					
					if(sizeof(from)==sizeof(to))
						for(int i = 0; i < sizeof(from)/sizeof(int);i++){
							printf("----------mem(%o-%o)---------\n",from[i],to[i]);
							machine_print_mem(from[i],to[i]);
						}
					
					printf("----------flags---------\n");					
					
				};

|	NUM ':' PUSH REG ';'
				{
					proc.mem[OTD($1)] = (3<<6) | (machine_get_code_of_reg($4)<<3) |  5;
					
					machine_update_reg_pair($4);
					proc.mem[proc.sp-1]   = proc.reg_pair[0];
					proc.mem[proc.sp-2]   = proc.reg_pair[1];
					proc.sp-=2;
					
					if(verbose)
						print_inf_8080($1);
				};
				
|	NUM ':' POP REG ';'
				{
					if(proc.sp == proc.max_sp){
						printf("POP:stack is empty(line:%d)\n", $1);
					}else{
						proc.mem[OTD($1)] = (3<<6) | (machine_get_code_of_reg($4)<<3) |  1;
						machine_set_reg_pair($4, proc.mem[proc.sp+1], proc.mem[proc.sp]);
						proc.sp+=2;
					}
					
					if(verbose)
						print_inf_8080($1);
				};
|	NUM ':' MVI REG ';' NUM ':' NUM ';'
				{
					proc.mem[OTD($1)] = (machine_get_code_of_reg($4)<<3) | 6;
					proc.mem[OTD($6)]  = OTD($8);
					
					machine_set_reg($4,OTD($8));
					
					if(verbose)
						print_inf_8080($1);
				};
|	NUM ':' ADD REG ';'
				{
					if(!strcmp($4,"M")){
						proc.mem[OTD($1)] = (2 << 6) | machine_get_code_of_reg($4);
						
						
						proc.f |= ((proc.a & 0xf) + (proc.mem[(proc.h << 8) & proc.l] & 0xf) > 9)?
									AC_FLAG:0;				
						
						proc.a += proc.mem[(proc.h << 8) & proc.l];
						
					}
					else{
						
						proc.f |= ((proc.a & 0xf) + (machine_get_reg($4) & 0xf) > 9)?
									AC_FLAG:0;
											
						proc.a+=machine_get_reg($4);
					}
					
					proc.a &= MAX_VAL;
					
					if(verbose)
						print_inf_8080($1);
				
				};
|	NUM ':' SUB REG ';'
				{
					if(!strcmp($4,"M")){
						proc.mem[OTD($1)] = (2 << 6) | (2 << 3) | machine_get_code_of_reg($4);
						
						proc.a -= proc.mem[(proc.h << 8) & proc.l];	
					}
					else{
						proc.a-=machine_get_reg($4);
					}
					
					proc.a &= MAX_VAL;
					
					if(verbose)
						print_inf_8080($1);
				
				};
|	NUM ':' DAA ';'
				{	
					proc.mem[OTD($1)] = DAA_OP;
					
					if((proc.f>>4) & 1){
						printf("DAA:first if\n");
						proc.a+=0x6;
					}
					if((proc.a & 0xf) > 9){
						printf("DAA:second if\n");
						proc.a+=0x6;
					}
					if( proc.a > 255 | ((proc.a >> 4) & 0xf) > 9 ){
						printf("DAA:third if\n");	
						proc.a+=0x60;

					}
					proc.a &= 0xff;
					
				};
|	NUM ':' ADC REG';'
				{
					proc.mem[OTD($1)] = (2 << 6) & (1 << 3) & machine_get_code_of_reg($4);
				
					if(!strcmp($4,"M")){
						proc.a += proc.mem[(proc.h << 8) & proc.l]+((proc.f>>4) & 1);
						proc.a %= MAX_VAL+1;
					}else{
						machine_update_reg_pair($4);
						proc.a += (proc.reg_pair[0] << 8) + proc.reg_pair[1] + ((proc.f>>4) & 1);
						proc.a %= (MAX_VAL+1);
					}
					
					proc.a &= MAX_VAL;
						
				
				};
|	NUM ':' LDA	';' NUM ':' NUM ';' NUM ':' NUM ';'
				{
					proc.mem[OTD($1)] = (0 << 6) & (7 << 3) & 2;
					
					proc.a = (OTD($7) << 8) & OTD($11);
					
					proc.a &= MAX_VAL;
					
					
				};
|	NUM ':' SBB REG ';'
				{
				
					proc.mem[OTD($1)] = (2 << 6) & (3 << 3) & machine_get_code_of_reg($4);
					int pair;
					if(!strcmp($4,"M")){
					
						pair = proc.mem[(proc.h << 8) & proc.l]+((proc.f>>4) & 1);
						proc.a = ((proc.a - pair) > MAX_VAL || (proc.a - pair) < 0) ?
								 MAX_VAL + 1 - pair : proc.a - pair;
						
					}else{
						
						machine_update_reg_pair($4);
						pair = (proc.reg_pair[0] << 8) + proc.reg_pair[1] + ((proc.f>>4) & 1);
						proc.a = ((proc.a - pair) > MAX_VAL || (proc.a - pair) < 0) ? 
								MAX_VAL + 1 - pair : proc.a - pair;
					}
					
					if(proc.a >= 0)
						proc.a &= MAX_VAL;
					
					
				
				
				};

				
			
%%


