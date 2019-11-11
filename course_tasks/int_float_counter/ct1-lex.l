%{
#include "y.tab.h"
%}
	
%%


[0-9]+			{return NUM;}

 	
[ \t]+      	;


.|\n           { return  yytext[0];}


				
%%

#ifndef yywrap
int yywrap () { return 1; }
#endif
