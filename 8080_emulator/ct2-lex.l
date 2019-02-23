regs	(A|B|C|D|E|H|L|M|PWS|SP)

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
HLT							{return HLT;}


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

