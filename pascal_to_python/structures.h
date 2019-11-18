struct Expression{
  char *arg;
  int action;
  struct Expression *prev;
  struct Expression *next;

}typedef Expression;


struct Str{
  char *buffer;
  struct Str *prev;
  struct Str *next;

}typedef Str;

struct RecStack{
  int recNum;
  struct Str *firstStr;
  struct Str *currentStr;
  struct RecStack *prevLevel;
  struct RecStack *nextLevel;

}typedef RecStack;
