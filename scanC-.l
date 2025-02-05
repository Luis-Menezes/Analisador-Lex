/* FALAR AQUI OS ERROS PFVR */
%{
#include <stdlib.h>
#include <stdio.h>

#define NUM 300
#define ID  301
#define SOM 302
#define SUB 303
#define MUL 304
#define DIV 305
#define ATT 306
#define PEV 307
#define APR 308
#define FPR 309
#define FIM 310
#define ERR 311
#define NL  312
#define INT 313
#define IF  318
#define ELS 319
#define VOD 325
#define WHL 314
#define RTN 315
#define ACH 316
#define FCH 317
#define ACL 320
#define FCL 321
#define VRG 322
#define GT  323
#define LT  324
#define LEQ 327
#define BEQ 328
#define IGL 329
#define DIF 330
#define IDERROR 331
int n_linha = 1;

%}

DIGITO [0-9]
LETRA [a-zA-Z]
NOVALINHA (\r?\n)+(\t)*
IDERR {DIGITO}+{LETRA}+|{LETRA}{DIGITO}+{LETRA}*|{LETRA}+{DIGITO}+ 
OUTRO [^a-zA-Z0-9_\s\+\-\*/<>=!;,{}\(\)\[\]\"\'/ ]


%%

{DIGITO}+		return NUM;
"+"				return SOM;
"-"				return SUB;
"*"				return MUL;
"/"				return DIV;
"=="          	return IGL;
"!="			return DIF;
=				return ATT;
;				return PEV;
"("				return APR;
")"				return FPR;
"{"             return ACH;
"}"             return FCH;
"["             return ACL;
"]"             return FCL;
"<"             return LT;
">"             return GT;
"<="            return LEQ;
">="            return BEQ;
,               return VRG;
<<EOF>>         return FIM;
{NOVALINHA}     {n_linha++; return NL;} 
[\t]+ 		      ;
"if"            return IF;
"else"          return ELS;
"int"           return INT; 
"while"         return WHL;
"void"          return VOD;
"return"        return RTN;  
"/*"            {char c;
                do{
                  c = input();
                  if(c == EOF) return ERR;
                  if(c=='*'){
                    if(input()=='/')  break;
                  }
                }while(c!=EOF);
} 
{LETRA}{LETRA}*	return ID;
{IDERR}         {printf("Erro lexico no identificador da linha: %d \n", n_linha); return IDERROR;}
{OUTRO}+			  {printf("Erro lexico na linha: %d \n", n_linha);return ERR;};


%%

int main(int argc, char *argv[])
{
  int token, i, buf[100000];
  FILE *f_in;
 
  for (i=0;i<=99;i++) buf[i] = 0;
 

  if (argc == 2)
  {
    if(f_in = fopen(argv[1],"r"))  yyin = f_in;
    else  perror(argv[0]);
  }
  else  yyin = stdin;
  
  i = 0;
  while ((token=yylex())!=FIM)
  {
    buf[i] = token;
    i++;
  }

  i = 0;
  while (buf[i] != 0)
  {
    switch(buf[i])
    {
      case NUM: printf("NUM ");     break;
      case ID:  printf("ID ");      break;
      case IGL: printf("IGL ");     break;
	  case DIF: printf("DIF ");		break;
      case SOM: printf("+ ");       break;
      case SUB: printf("- ");       break;
      case MUL: printf("* ");       break;
      case DIV: printf("/ ");       break;
      case ATT: printf(" ATT ");      break;
      case PEV: printf("; ");       break;
      case VRG: printf(", ");       break;
      case APR: printf("( ");       break;
      case FPR: printf(") ");       break;
      case GT:  printf("> ");       break;
      case LT:  printf("< ");       break;
      case NL:  printf("\n");    break;
      case ERR: printf("ERR");     break;
      case INT: printf("INT ");     break;
      case RTN: printf("RETURN ");  break;
      case VOD: printf("VOID ");    break;
      case WHL: printf("WHILE ");   break;
      case IF:  printf("IF ");      break;
      case ELS: printf("ELSE ");    break;
      case FCH: printf("}");        break;
      case ACH: printf("{ ");       break;
      case FCL: printf("] ");       break;
      case ACL: printf("[ ");       break;
      case LEQ: printf("<= ");       break;
      case BEQ: printf(">= ");        break;
      case IDERROR: printf("IDERR");   break;
    }
    i++;
  }
  printf("\nNumero total de linhas: %d", n_linha);
  return(0);
}

