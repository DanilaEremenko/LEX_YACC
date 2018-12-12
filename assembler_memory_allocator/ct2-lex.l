types	(char|int|float|long|double)

/*-------------------------------------------------------*/
%{

#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
extern int line_number;
extern YYSTYPE yylval;

//#define YY_USER_ACTION { fprintf(stderr, "<%d> %s\n",YYSTATE,yytext); }



%}
/*-------------------------------------------------------*/
	
%%
\n									{line_number++;}
[ \t]+ 		                		;

[/][*][^*]*[*]+([^/*][^*][*]+)*[/]	{	
										for(int i = 0;i<yyleng;i++) 
											if(yytext[i]=='\n')
												line_number++;
										printf("%s\n",yytext);
										return COMMENTS;
										
									}

{types}						{
								switch(yytext[0]){
									case 'c':
										yylval.ival = 1; 
										break;
									case 'i':
										yylval.ival = 2; 
										break;
									case 'f':
										yylval.ival = 4; 
										break;
									case 'l':
										yylval.ival = 4; 
										break;
									case 'd':
										yylval.ival = 8; 
										break;
									default:
										printf("Illegal argument in lex switch = %s",yytext);
										yylval.ival = 0; 
										break;
								}

								return TYPE;
							}

[a-zA-Z][a-zA-Z0-9_-]+		{	
								yylval.text = strdup(yytext);
								return IDENT;								
							}
							
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

