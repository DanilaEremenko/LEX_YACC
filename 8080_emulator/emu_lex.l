regs	(A|B|C|D|E|H|L|M|PSW|SP)

/*-------------------------------------------------------*/
%{

#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "machine.h"
extern int line_number;
extern YYSTYPE yylval;

//#define YY_USER_ACTION { fprintf(stderr, "<%d> %s\n",YYSTATE,yytext); }



%}
/*-------------------------------------------------------*/
	
%%
\n									{line_number++;}
[ \t]+ 		                		;

[/][*][^*]*[*]+([^/*][^*][*]+)*[/]	{	
										/*
										for(int i = 0;i<yyleng;i++) 
											if(yytext[i]=='\n')
												line_number++;
										printf("%s\n",yytext);
										return COMMENTS;
										*/
									}

LXI							{return LXI;}
MOV							{return MOV;}
INX							{return INX;}
INR							{return INR;}
HLT							{return HLT;}
PUSH						{return PUSH;}
POP							{return POP;}
MVI							{return MVI;}
ADD							{return ADD;}
SUB							{return SUB;}
DAA							{return DAA;}
ADC							{return ADC;}
LDA							{return LDA;}
SBB							{return SBB;}
EXEC;						{return EXEC;}
DCR							{return DCR;}
JNZ							{return JNZ;}
LDAX						{return LDAX;}
STAX						{return STAX;}
JZ							{return JZ;}
JMP							{return JMP;}
DAD							{return DAD;}
SUI							{return SUI;}
OUT							{return OUT;}
ANI 						{return ANI;}
ADI							{return ADI;}
RRC							{return RRC;}
RLC							{return RLC;}
CALL						{return CALL;}
RET							{return RET;}
FROM						{return FROM;}
TO							{return TO;}
ASSERT						{return ASSERT;}
T							{return T;}
TEST;						{return TEST;}

{regs}						{ yylval.text = strdup(yytext);return REG; }
							
[0-9]+						{	
								yylval.ival = atoi(yytext);
								return NUM;
							}

.                       	{ return yytext[0]; }
		
%%

/*-------------------------------------------------------*/
#ifndef yywrap
int yywrap () { return 1; }
#endif

