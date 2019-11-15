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
