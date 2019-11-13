%token <text>NAME
%token <ival>TYPE
%token  VAR
%token  FUNCTION
%token  BEGINT
%token  ENDT
%token <text>NUM
%token  COMMENTS
%token ASSIGN
%token <ival>ACTION
%token  IF
%token  THEN


%start lines



/*-------------------------------------------------------*/

%union
{
    int ival;
    char *text;
};

%{
#include "pp_common.h"


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
|     func_decl     {TAB_DEC_TRY();}
|     func_call ';' {TAB_PRINT();printf("%s",currentOperand);TAB_DEC_TRY();}
|     var_decl      {TAB_DEC_TRY();}
|     var_assign    {TAB_DEC_TRY();}
|     conditional
|     BEGINT        {TAB_INC();block_next_tab = 0;}
|     ENDT          {TAB_DEC();}
|     ';'


var_assign:
      NAME ASSIGN expression ';'
      {
        TAB_PRINT();
        printf("%s = ",$1);
        PRINT_ALL_EXPRESSION_IN_CHAIN();
        printf(";");
      }

conditional:
      IF '(' expression ')' THEN
      {
        TAB_PRINT();
        printf("if ");
        PRINT_ALL_EXPRESSION_IN_CHAIN();
        printf(":");
        TAB_INC();
        dec_after_next=1;
      }
|     IF expression THEN
      {
        TAB_PRINT();
        printf("if ");
        PRINT_ALL_EXPRESSION_IN_CHAIN();
        printf(":");
        TAB_INC();
        dec_after_next=1;
      }

expression:
      expression ACTION operand
      {
        currentExpression->next = calloc(1,sizeof(ExpressionChain));
        currentExpression->next->arg = currentOperand;
        currentExpression->next->action = $2;
        update_str_from_action(currentExpression->next->action);
        fprintf(stderr,"\n\naction = %s,operand = %s\n\n",currentAction,currentOperand);
        currentExpression->next->prev = currentExpression;
        currentExpression = currentExpression->next;
      }
|      expression ACTION '('
      {
        currentExpression->next = calloc(1,sizeof(ExpressionChain));
        currentExpression->next->arg = strdup("(");
        currentExpression->next->action = $2;

        currentExpression->next->prev = currentExpression;
        currentExpression = currentExpression->next;
      }

|      expression ACTION ')'
      {
        currentExpression->next = calloc(1,sizeof(ExpressionChain));
        currentExpression->next->arg = strdup(")");
        currentExpression->next->action = $2;

        currentExpression->next->prev = currentExpression;
        currentExpression = currentExpression->next;
      }

|     ACTION operand
      {
        firstExpersion = calloc(1,sizeof(ExpressionChain));
        firstExpersion->arg = currentOperand;
        firstExpersion->action = $1;
        currentExpression = firstExpersion;
      }
|     operand
      {
        firstExpersion = calloc(1,sizeof(ExpressionChain));
        firstExpersion->arg = currentOperand;
        firstExpersion->action = A_EMPTY;
        currentExpression = firstExpersion;
        fprintf(stderr,"\n\noperand = %s\n\n",currentExpression->arg);
      }

operand:
      NAME
      {
        currentOperand = $1;
      }
|     NUM
      {
        currentOperand = $1;
      }
|     func_call

func_decl:
      FUNCTION NAME '(' args_seq ')' ':' TYPE ';'
      {
        TAB_PRINT();
        printf("def %s(",$2);
        PRINT_ALL_WORDS_IN_CHAIN(", ")
        printf("):");
        TAB_INC();
        block_next_tab = 1;

      };
func_call:
      NAME '(' name_seq ')'
      {
        currentOperand = string_concat($1,"(");
        currentWord = firstWord;
        while(currentWord->next != NULL){
          currentOperand = string_concat(currentOperand ,string_concat(currentWord->buffer,","));
          currentWord = currentWord->next;
          free(currentWord->prev);
        }
        currentOperand = string_concat(currentOperand, string_concat(currentWord->buffer,")"));
        free(currentWord);
      }


var_decl:
      VAR name_seq ':' TYPE ';'
        {
          TAB_PRINT();
          PRINT_ALL_WORDS_IN_CHAIN(" = ")
          switch($4){
            case T_INT:
              printf(" = 0");
              break;
            case T_DOUBLE:
              printf(" = 0.0");
              break;
            default:
              fprintf(stderr,"UNDEFINED TYPE = %d, EXITING...",$4);
              exit(1);
          }
        }

args_seq:
       args_seq ',' name_seq ':' TYPE
|      name_seq ':' TYPE

name_seq:
      name_seq ',' NAME
        {
          currentWord->next = calloc(1,sizeof(WordChain));
          currentWord->next->buffer = $3;
          currentWord->next->prev = currentWord;
          currentWord = currentWord->next;


        }
|     name_seq ',' NUM
        {
          currentWord->next = calloc(1,sizeof(WordChain));
          currentWord->next->buffer = $3;
          currentWord->next->prev = currentWord;
          currentWord = currentWord->next;


        }
|     NAME
        {
          firstWord = calloc(1,sizeof(WordChain));
          firstWord->buffer = $1;
          currentWord = firstWord;

        }
|     NUM
        {
          firstWord = calloc(1,sizeof(WordChain));
          firstWord->buffer = $1;
          currentWord = firstWord;

        }



%%
