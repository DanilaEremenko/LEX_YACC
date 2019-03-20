regs	(A|B|C|D|E|H|L|M|PSW|SP)

/*-------------------------------------------------------*/
%{

#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "macr_8080.h"
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
DCR							{return DCR;}
JNZ							{return JNZ;}
XRA							{return XRA;}
RAL							{return RAL;}
JZ							{return JZ;}
JNC							{return JNC;}
JC							{return JC;}
JPO							{return JPO;}
JPE							{return JPE;}
JP							{return JP;}
JM							{return JM;}
JMP							{return JMP;}
CALL						{return CALL;}
RET							{return RET;}
RST							{return RST;}
LDAX						{return LDAX;}
STAX						{return STAX;}
DAD							{return DAD;}

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
