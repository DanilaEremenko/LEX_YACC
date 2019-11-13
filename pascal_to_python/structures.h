struct WordChain{
  char *buffer;
  struct WordChain *prev;
  struct WordChain *next;
}typedef WordChain;

struct ExpressionChain{
  char *arg;
  int action;
  struct ExpressionChain *prev;
  struct ExpressionChain *next;

}typedef ExpressionChain;
