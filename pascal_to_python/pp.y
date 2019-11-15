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
|     func_call ';' {TAB_PRINT();
                    char *full_str = get_str_chain(", ",1);
                    printf("%s",full_str);
                    TAB_DEC_TRY();}
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
      }

conditional:
      IF '(' expression ')' THEN
      {
        TAB_PRINT();
        printf("if ");
        printf(":");
        TAB_INC();
        dec_after_next=1;
      }
|     IF expression THEN
      {
        TAB_PRINT();
        printf("if ");
        printf(":");
        TAB_INC();
        dec_after_next=1;
      }

func_call:
      NAME '(' func_call_args_seq ')'
      {
        currentStr->buffer = string_concat(currentStr->buffer, ")");
        currentStr->buffer = string_concat("(",currentStr->buffer);
        currentStr->buffer = string_concat($1,currentStr->buffer);
        fprintf(stderr,"\n\nFUNC CALL PARSE = %s\n\n",currentStr->buffer);
      }

func_call_args_seq:
      func_call_args_seq ',' expression
      {
        add_new_str(get_expression_chain(1));
        fprintf(stderr,"\n\ncurrent str = %s\n\n",currentStr->buffer);
        fprintf(stderr,"\n\ncurrent str prev = %s\n\n",currentStr->prev->buffer);
      }

|     expression
      {
        firstStr = calloc(1,sizeof(Str));
        fprintf(stderr,"\n\nsaving chain to str\n\n");
        firstStr->buffer = get_expression_chain(1);
        currentStr = firstStr;
        fprintf(stderr,"\n\nfirst str = %s\n\n",firstStr->buffer);

      }


expression:
      expression ACTION exp_operand
      {
        add_new_expression(currentOperand, $2);
        update_str_from_action($2);
        fprintf(stderr,"\n\naction = %s,exp_operand = %s\n\n",currentAction,currentOperand);
      }
|     ACTION exp_operand
      {
        firstExpersion = calloc(1,sizeof(Expression));
        firstExpersion->arg = currentOperand;
        firstExpersion->action = $1;
        currentExpression = firstExpersion;
      }
|     exp_operand
      {
        firstExpersion = calloc(1,sizeof(Expression));
        firstExpersion->arg = currentOperand;
        firstExpersion->action = A_EMPTY;
        currentExpression = firstExpersion;
        fprintf(stderr,"\n\nNEW EXP OPERAND = %s\n\n",currentExpression->arg);
      }

exp_operand:
      NUM
      {
        currentOperand = $1;
      }
|     NAME
      {
        currentOperand = $1;
      }
|     func_call
      {
        currentOperand = currentStr->buffer;

      }

func_decl:
      FUNCTION NAME '(' func_init_args_seq ')' ':' TYPE ';'
      {
        TAB_PRINT();
        printf("def %s(",$2);
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
          add_new_expression($3, A_EMPTY);
        }
|       NAME
        {

          firstExpersion = calloc(1,sizeof(Expression));
          firstExpersion->arg = $1;
          firstExpersion->action = A_EMPTY;
          currentExpression = firstExpersion;

        }


%%
