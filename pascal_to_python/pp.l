actions	(\+|\-|\=|\*|\/)

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
\n								{line_number++;}

[\/\/.+\n]				{return COMMENTS;}

function					{return FUNCTION;}
var								{return VAR;}
begin							{return BEGINT;}
end								{return ENDT;}


{actions}						{
										yylval.text = strdup(yytext);
										return ACTION;
									}

[0-9]+						{
										yylval.ival = atoi(yytext);
										return NUM;
									}

[a-zA-Z]_[a-zA-Z0-9]*	{
												yylval.text = strdup(yytext);
												printf("%s\n",yylval.text);
												return NAME;
											}

[a-zA-Z][a-zA-Z0-9]*	{
												yylval.text = strdup(yytext);
												printf("%s\n",yylval.text);
												return NAME;
											}

.									{ return yytext[0]; }


%%

/*-------------------------------------------------------*/
#ifndef yywrap
int yywrap () { return 1; }
#endif
