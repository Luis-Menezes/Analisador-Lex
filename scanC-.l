%{
#include <stdlib.h>
#include <stdio.h>

#define NUM 300
#define ID  301
#define SOM 302
#define SUB 303
#define MUL 304
#define DIV 305
#define IGL 306
#define PEV 307
#define APR 308
#define FPR 309
#define FIM 310
#define ERR 311
#define NL  312
#define INT 313
#define IF  318
#define ELS 319
#define WHL 314
#define RTN 315
#define ACH 316
#define FCH 317
#define ACL 320
#define FCL 321
#define VRG 322
%}

DIGITO [0-9]
LETRA [a-zA-Z]
OUTRO [^0-9a-zA-Z;/=\-\+\*\(\)\[\]\,]
NOVALINHA \\n

%%

{DIGITO}+			return NUM;
"+"				return SOM;
"-"				return SUB;
"*"				return MUL;
"/"				return DIV;
=				return IGL;
;				return PEV;
"("				return APR;
")"				return FPR;
"{"             return ACH;
"}"             return FCH;
"["             return ACL;
"]"             return FCL;
","             return VRG;
<<EOF>>         return FIM;
{NOVALINHA}     return NL;  
"if"            return IF;
"else"          return ELS;
"int"           return INT; 
"while"         return WHL;
"return"        return RTN;    
[ "\t"]+ 
{LETRA}({LETRA}|{DIGITO})*	return ID;
{OUTRO}+			return ERR;

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
      case SOM: printf("+ ");       break;
      case SUB: printf("- ");       break;
      case MUL: printf("* ");       break;
      case DIV: printf("/ ");       break;
      case IGL: printf(" = ");      break;
      case PEV: printf("; ");     break;
      case VRG: printf(", ");       break;
      case APR: printf("( ");       break;
      case FPR: printf(") ");       break;
      case NL:  printf("NL \n");    break;
      case ERR: printf("ERR ");     break;
      case INT: printf("INT ");     break;
      case WHL: printf("WHILE ");   break;
      case IF:  printf("IF ");       break;
      case ELS: printf("ELSE ");   break;
      case FCH: printf("}");    break;
      case ACH: printf("{ ");       break;
      case FCL: printf("] ");    break;
      case ACL: printf("[ ");       break;
    }
    i++;
  }
  return(0);
}

