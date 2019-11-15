#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "constants.h"
#include "structures.h"

/*-------------------------variables----------------*/

Str *firstStr;
Str *currentStr;

Expression *firstExpersion;
Expression *currentExpression;

char *currentOperand;
char *currentAction;

int line_number = 0;
int tab_num = 0;
char *tab_str;
int block_next_tab = 0;
int dec_after_next = 0;


/*-------------------------declarations----------------*/
void add_new_str(char *buffer);

void add_new_expression(char *arg, int action);

char* get_expression_chain(int free_chain);

void update_str_from_action(int action);

int get_action_from_str(char *str);

char* string_concat(const char *s1, const char *s2);

void tab_update();

/*-------------------------realiztions----------------*/
void tab_update(){
      if(tab_str != NULL){
        free(tab_str);
      }

      tab_str = calloc(tab_num, sizeof(char));
      for(int i = 0; i < tab_num; i++){
          tab_str[i] = '\t';
      };

}

/*-------------------------tab processing----------------*/
#define TAB_INC() if(!block_next_tab){tab_num++;}

#define TAB_DEC() if(tab_num != 0){tab_num--;}

#define TAB_DEC_TRY() if(dec_after_next){tab_num--;dec_after_next=0;}

#define TAB_PRINT() tab_update();if(tab_num != 0){printf("%s",tab_str);}

/*-------------------------str processing----------------*/
void add_new_str(char *buffer){
  currentStr->next = calloc(1,sizeof(Expression));
  currentStr->next->buffer = buffer;

  currentStr->next->prev = currentStr;
  currentStr = currentStr->next;


}

char* get_str_chain(char *divstr, int free_chain){
  char *full_chain_str = "";


  full_chain_str = string_concat(
                          full_chain_str ,
                          firstStr->buffer
                        );

  currentStr = firstStr->next;
  while(currentStr!= NULL){
    full_chain_str = string_concat(
                            full_chain_str ,
                            string_concat(divstr, currentStr->buffer)
                          );

    if(free_chain){
      free(currentStr->prev);
    }
    currentStr = currentStr->next;

  }
  return full_chain_str;

}


/*-------------------------expression processing----------------*/
void add_new_expression(char *arg, int action){
  currentExpression->next = calloc(1,sizeof(Expression));
  currentExpression->next->arg = arg;
  currentExpression->next->action = action;

  currentExpression->next->prev = currentExpression;
  currentExpression = currentExpression->next;


}

char* get_expression_chain(int free_chain){

  char *full_chain_str = "";
  currentExpression = firstExpersion;

  while(currentExpression!= NULL){
    update_str_from_action(currentExpression->action);
    full_chain_str = string_concat(
                            full_chain_str ,
                            string_concat(currentAction, currentExpression->arg)
                          );
    free(currentAction);

    if(free_chain){
      free(currentExpression->prev);
    }
    currentExpression = currentExpression->next;

  }
  return full_chain_str;
}

/*-------------------------actions processing----------------*/
void update_str_from_action(int action){
    switch (action) {
      case A_PLUS:
        currentAction = strdup("+");
        return;
      case A_MINUS:
        currentAction = strdup("-");
        return;
      case A_DIV:
        currentAction = strdup("/");
        return;
      case A_MULT:
        currentAction = strdup("*");
        return;
      case A_BIG:
        currentAction = strdup(">");
        return;
      case A_LESS:
        currentAction = strdup("<");
        return;
      case A_BIGEQ:
        currentAction = strdup(">=");
        return;
      case A_LESSEQ:
        currentAction = strdup("<=");
        return;
      case A_EQ:
        currentAction = strdup("==");
        return;
      case A_ASSIGN:
        currentAction = strdup(":=");
        return;
      case A_EMPTY:
        currentAction = strdup("");
        return;
      default:
        fprintf(stderr, "Undefined case in update str action\n");
        exit(1);
    }
}

int get_action_from_str(char *str){
  if(!strcmp(str,"+")){
    return A_PLUS;
  }else if(!strcmp(str,"-")){
    return A_MINUS;
  }else if(!strcmp(str,"/")){
    return A_DIV;
  }else if(!strcmp(str,"*")){
    return A_MULT;
  }else if(!strcmp(str,">")){
    return A_BIG;
  }else if(!strcmp(str,"<")){
    return A_LESS;
  }else if(!strcmp(str,">=")){
    return A_BIGEQ;
  }else if(!strcmp(str,"<=")){
    return A_LESSEQ;
  }else if(!strcmp(str,"==")){
    return A_EQ;
  }else if(!strcmp(str,":=")){
    return A_ASSIGN;
  }else{
    fprintf(stderr, "\n\nUNDEFINED ACTION, EXITING...\n\n");
    exit(1);
  }


}

/*-------------------------love C----------------*/
char* string_concat(const char *s1, const char *s2)
{
    char *result = malloc(strlen(s1) + strlen(s2) + 1); // +1 for the null-terminator
    // in real code you would check for errors in malloc here
    strcpy(result, s1);
    strcat(result, s2);
    return result;
}
