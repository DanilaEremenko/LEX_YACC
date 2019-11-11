%token  NAME
%token  TYPE
%token  VAR
%token  FUNCTION
%token  BEGINT
%token  ENDT
%token  NUM
%token COMMENTS
%token ACTION

%start lines



/*-------------------------------------------------------*/

%union
{
    int ival;
    char *text;
};

%{
#include <stdio.h>
#include "y.tab.h"

int line_number = 0;






%}


/*-------------------------------------------------------*/
%%



lines:
    lines line          {};
|	  lines COMMENTS      {};
|	  line                {};
|	  COMMENTS            {};

line:
      NAME ':' '=' expression ';'
|     func_decl
|     var_decl
|     BEGINT
|     ENDT
|     ';'

expression:
      expression ACTION operand
|     ACTION operand
|     operand

operand:  NAME | NUM


func_decl:
      FUNCTION NAME '(' args_seq ')' ':' TYPE ';'

var_decl:
      VAR name_seq ':' TYPE ';'

name_seq:
      name_seq ',' NAME
|     NAME

args_seq:
      args_seq ',' arg
|     arg

arg:
      NAME ':'  TYPE

%%
