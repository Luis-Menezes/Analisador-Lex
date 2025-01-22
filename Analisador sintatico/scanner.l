
%{
#include <stdlib.h>
#include <stdio.h>


#define ID    300
#define NUM   301
#define IF    302
#define THEN  303
#define ELS  304
#define BEG   305
#define END   306
#define PRINT 307
#define PEV   308
#define ATT   309
#define NL    310
#define FIM   311
#define ERRL  312
int n_linha=1;

%}

DIGITO [0-9]
LETRA [a-zA-Z]
NOVALINHA (\r?\n)+
OUTRO[^a-zA-Z0-9_=]


%%

{DIGITO}+		return NUM;
=				return ATT;
;				return PEV;
<<EOF>>         return FIM;
{NOVALINHA}     {n_linha++;} 
[ \t]+ 		;
"if"            return IF;
"then"          return THEN;
"else"          return ELS;
"begin"         return BEG;
"end"           return END;
"print"         return PRINT;
"/*"            {char c;
                do{
                  c = input();
                  if(c == EOF) return ERRL;
                  if(c=='*'){
                    if(input()=='/')  break;
                  }
                }while(c!=EOF);
} 
{LETRA}{LETRA}*	return ID;
{OUTRO}+			{printf("Erro lexico na linha: %d \n", n_linha);return ERRL;};


%%
int token;
void ERRO(){
  printf("Erro na Analise Sintatica: %d %d \n", n_linha, token);
}
void eat(int t){
  if(token == t){
    token = yylex();
  }
  else ERRO();
}
void L(){
  switch(token){
    case PEV: eat(PEV); S(); L(); break;
    case END: eat(END); break;
    default: ERRO();
  }
}
void E(){
  switch(token){
    case ID: eat(ID); eat(ATT); eat(NUM); break;
    default: ERRO();
  }
}
void S(){
  switch(token){
    case BEG:   eat(BEG); S(); L(); break;
    case IF:    eat(IF); E(); eat(THEN); S(); eat(ELS); S(); break;
    case PRINT: eat(PRINT); eat(ID); break;
    default: ERRO();
  }
}

int main(int argc, char *argv[]){
  FILE *f_in;
 
  if (argc == 2){
    if(f_in = fopen(argv[1],"r"))  yyin = f_in;
    else  perror(argv[0]);
  }
  else  yyin = stdin;
  
  token = yylex();
  S();

  printf("\nNumero total de linhas: %d", n_linha);
  return(0);
}

