#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "y.tab.h"
#include "constants.h"
#include "structures.h"

WordChain *firstWord;
WordChain *currentWord;

ExpressionChain *firstExpersion;
ExpressionChain *currentExpression;

char *currentOperand;
char *currentAction;

int line_number = 0;
int tab_num = 0;
char *tab_str;
int block_next_tab = 0;
int dec_after_next = 0;


void tab_update(){
      if(tab_str != NULL){
        free(tab_str);
      }

      tab_str = calloc(tab_num, sizeof(char));
      for(int i = 0; i < tab_num; i++){
          tab_str[i] = '\t';
      };

}

#define TAB_INC() if(!block_next_tab){tab_num++;}

#define TAB_DEC() if(tab_num != 0){tab_num--;}

#define TAB_DEC_TRY() if(dec_after_next){tab_num--;dec_after_next=0;}

#define TAB_PRINT() tab_update();if(tab_num != 0){printf("%s",tab_str);}

#define PRINT_ALL_WORDS_IN_CHAIN(separator)\
    currentWord = firstWord;\
    while(currentWord->next != NULL){\
      printf("%s%s",currentWord->buffer,separator);\
      currentWord = currentWord->next;\
      free(currentWord->prev);\
    }\
    printf("%s",currentWord->buffer);\
    free(currentWord);

#define PRINT_ALL_EXPRESSION_IN_CHAIN()\
    currentExpression = firstExpersion;\
    while(currentExpression->next != NULL){\
      update_str_from_action(currentExpression->action);\
      printf("%s%s",currentAction, currentExpression->arg);\
      free(currentAction);\
      currentExpression = currentExpression->next;\
      free(currentExpression->prev);\
    }\
    update_str_from_action(currentExpression->action);\
    printf("%s%s",currentAction, currentExpression->arg);\
    free(currentAction);\
    free(currentExpression);

void add_new_expression(char *arg, int action){
  currentExpression->next = calloc(1,sizeof(ExpressionChain));
  currentExpression->next->arg = arg;
  currentExpression->next->action = action;

  currentExpression->next->prev = currentExpression;
  currentExpression = currentExpression->next;


}

void add_new_word(char *buffer){
  currentWord->next = calloc(1,sizeof(WordChain));
  currentWord->next->buffer = buffer;
  currentWord->next->prev = currentWord;
  currentWord = currentWord->next;

}

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

char* string_concat(const char *s1, const char *s2)
{
    char *result = malloc(strlen(s1) + strlen(s2) + 1); // +1 for the null-terminator
    // in real code you would check for errors in malloc here
    strcpy(result, s1);
    strcat(result, s2);
    return result;
}
