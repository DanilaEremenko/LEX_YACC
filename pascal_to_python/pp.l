actions	(\=\=|\+|\-|\=|\*|\/|\<|\>)

types		(double)
/*-------------------------------------------------------*/
%{

#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "constants.h"


extern int line_number;
extern char *currentAction;
extern YYSTYPE yylval;

//#define YY_USER_ACTION { fprintf(stderr, "<%d> %s\n",YYSTATE,yytext); }

%}
/*-------------------------------------------------------*/

%%
\n								{printf("\n");}

\/\/.+\n					{return COMMENTS;}
[ ]+							{}

function					{return FUNCTION;}

var								{return VAR;}
begin							{return BEGINT;}
end								{return ENDT;}
if								{return IF;}
then							{return THEN;}

:=								{
										return ASSIGN;
									}
{types}						{

										if (!strcmp(yytext,"double")){
											yylval.ival = T_DOUBLE;
										}
										else if (!strcmp(yytext,"int")){
											yylval.ival = T_INT;
										}
										else{
											fprintf(stderr,"UNDEFINED TYPE EXITING...");
											exit(1);
										}

										return TYPE;
									}

1e*.[0-9]					{
											fprintf(stderr,"\n\nNUM = %s\n\n",yytext);
											yylval.text = strdup(yytext);
											return NUM;
										}
-[0-9]+\.[0-9]			{
											fprintf(stderr,"\n\nNUM = %s\n\n",yytext);
											yylval.text = strdup(yytext);
											return NUM;
										}
[0-9]+\.[0-9]				{
											fprintf(stderr,"\n\nNUM = %s\n\n",yytext);
											yylval.text = strdup(yytext);
											return NUM;
										}
-[0-9]+							{
											fprintf(stderr,"\n\nNUM = %s\n\n",yytext);
											yylval.text = strdup(yytext);
											return NUM;
										}
[0-9]+							{
											fprintf(stderr,"\n\nNUM = %s\n\n",yytext);
											yylval.text = strdup(yytext);
											return NUM;
										}


[a-zA-Z]_[a-zA-Z0-9]*	{
												fprintf(stderr,"\n\nNAME = %s\n\n",yytext);
												yylval.text = strdup(yytext);
												return NAME;
											}

[a-zA-Z][a-zA-Z0-9]*	{
												fprintf(stderr,"\n\nNAME = %s\n\n",yytext);
												yylval.text = strdup(yytext);
												return NAME;
											}

{actions}							{
												yylval.ival = get_action_from_str(yytext);
												update_str_from_action(yylval.ival);
												fprintf(stderr,"\n\nACTION = %s\n\n", currentAction);
												free(currentAction);
												return ACTION;
											}


.											{
												return yytext[0];
											}


%%

/*-------------------------------------------------------*/
#ifndef yywrap
int yywrap () { return 1; }
#endif
