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

func_call:
      NAME '(' func_call_args_seq ')'
      {

        printf("%s() PARSED\n",$1);
        /* currentOperand = string_concat($1,"(");
        currentWord = firstWord;
        while(currentWord->next != NULL){
          currentOperand = string_concat(currentOperand ,string_concat(currentWord->buffer,","));
          currentWord = currentWord->next;
          free(currentWord->prev);
        }
        currentOperand = string_concat(currentOperand, string_concat(currentWord->buffer,")"));
        free(currentWord); */
      }

func_call_args_seq:
|   func_call_args_seq ',' expression
expression


expression:
      expression ACTION exp_operand
      {
        add_new_expression(currentOperand, $2);
        update_str_from_action($2);
        fprintf(stderr,"\n\naction = %s,exp_operand = %s\n\n",currentAction,currentOperand);
      }
|      expression ACTION '('
      {
        add_new_expression(strdup("("), $2);
      }

|      expression ACTION ')'
      {
        add_new_expression(strdup(")"), $2);
      }
|      expression exp_operand
      {
        add_new_expression(currentOperand, A_EMPTY);
      }

|     ACTION exp_operand
      {
        firstExpersion = calloc(1,sizeof(ExpressionChain));
        firstExpersion->arg = currentOperand;
        firstExpersion->action = $1;
        currentExpression = firstExpersion;
      }
|     exp_operand
      {
        firstExpersion = calloc(1,sizeof(ExpressionChain));
        firstExpersion->arg = currentOperand;
        firstExpersion->action = A_EMPTY;
        currentExpression = firstExpersion;
        fprintf(stderr,"\n\nexp_operand = %s\n\n",currentExpression->arg);
      }

exp_operand:
      NAME
      {
        currentOperand = $1;
      }
|     NUM
      {
        currentOperand = $1;
      }
|     func_call
      {
        currentOperand = currentOperand;
      }

func_decl:
      FUNCTION NAME '(' func_init_args_seq ')' ':' TYPE ';'
      {
        TAB_PRINT();
        printf("def %s(",$2);
        PRINT_ALL_WORDS_IN_CHAIN(", ")
        printf("):");
        TAB_INC();
        block_next_tab = 1;

      };

func_init_args_seq:
       func_init_args_seq ',' name_seq ':' TYPE
|      name_seq ':' TYPE


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

name_seq:
        name_seq ',' NAME
        {
          add_new_word($3);
        }
|       name_seq ',' NUM
        {
          add_new_word($3);
        }
|       NAME
        {
          firstWord = calloc(1,sizeof(WordChain));
          firstWord->buffer = $1;
          currentWord = firstWord;

        }
|       NUM
        {
          firstWord = calloc(1,sizeof(WordChain));
          firstWord->buffer = $1;
          currentWord = firstWord;

        }


%%
