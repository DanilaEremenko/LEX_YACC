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
                    fprintf(stderr, "\n\nFUNC LINE  = %s\n\n", currentOperand);
                    printf("%s",currentOperand);
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
        free(currentOperand);
        currentOperand = get_str_chain(", ", 1);
        currentOperand = string_concat(currentOperand, ")");
        currentOperand = string_concat("(", currentOperand);
        currentOperand = string_concat($1, currentOperand);
        fprintf(stderr,"\n\nFUNC CALL PARSED = %s\n\n", currentOperand);
      }

func_call_args_seq:
      func_call_args_seq ',' expression
      {
        fprintf(stderr,"\n\nADDING NEW STR\n\n");
        add_new_str(get_expression_chain(1));
        fprintf(stderr,"\n\nNEW ARG = %s\n\n",currentCallLevel->currentStr->buffer);
        fprintf(stderr,"\n\nPREV ARG = %s\n\n",currentCallLevel->currentStr->prev->buffer);
        fprintf(stderr,"\n\n----------------------------\n\n");
      }

|     expression
      {
        incRecCallLevel();
        currentCallLevel->firstStr = calloc(1,sizeof(Str));
        currentCallLevel->firstStr->buffer = get_expression_chain(1);
        currentCallLevel->currentStr = currentCallLevel->firstStr;
        fprintf(stderr,"\n\nFIRST ARG = %s\n\n",currentCallLevel->firstStr->buffer);
        fprintf(stderr,"\n\n----------------------------\n\n");
      }


expression:
      expression ACTION exp_operand
      {
        add_new_expression(currentOperand, $2);
        update_str_from_action($2);
        fprintf(stderr,"\n\nACTION = %s,EXP_OPERAND = %s\n\n",currentAction,currentOperand);
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
        currentOperand = currentOperand;
        decRecCallLevel();

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
