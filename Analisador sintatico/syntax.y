%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>



extern char *yytext;

extern int yylex();
extern int n_linha, contErros;

extern int yylex(void);
extern void abrirArq();
extern void imprimirToken();

void yyerror(char *erroSint);
%}

%start entrada

%token ELS IF INT RTN VOD WHL 
%token SOM SUB MUL DIV LT GT LEQ BEQ IGL DIF ATT
%token PEV VRG APR FPR ACL FCL ACH FCH
%token ID NUM IDERROR ERR NL FIM

%left SOM SUB
%left MUL DIV 
%nonassoc LT GT LEQ BEQ IGL DIF



%%
entrada :	/* entrada vazia */
	| 	entrada programa 
    ;
programa: 
    declaracao_lista
    ;

declaracao_lista:
    declaracao_lista declaracao
    | declaracao 
    ;

declaracao:
    var_declaracao
    | fun_declaracao
    ;

var_declaracao:
    tipo_especificador ID PEV
    | tipo_especificador ID ACL NUM FCL PEV
    ;

fun_declaracao:
    tipo_especificador ID APR params FPR composto_decl
    ;

tipo_especificador:
    INT
    | VOD 
    ;


params: 
    param_lista 
    | VOD
    ;

param_lista: 
    param_lista VRG param 
    | param
    ;

param:
    tipo_especificador ID 
    | tipo_especificador ID ACL FCL
    ;

composto_decl:
    ACH local_declaracoes statement_lista FCH
    ;

local_declaracoes:
    local_declaracoes var_declaracao
    | /* vazio */
    ;

statement_lista:
    statement_lista statement 
    | /* vazio */
    ;

statement:
    expressao_decl 
    | composto_decl
    | selecao_decl
    | iteracao_decl
    | retorno_decl
    ;

expressao_decl:
    expressao PEV
    | PEV
    ;

selecao_decl:
    IF APR expressao FPR statement
    | IF APR expressao FPR statement ELS statement
    ;

iteracao_decl: 
    WHL APR expressao FPR statement
    ;

retorno_decl: 
    RTN PEV
    | RTN expressao PEV
    ;

expressao: 
    var ATT expressao
    | simples_expressao
    ;

var: 
    ID 
    | ID ACL expressao FCL
    ;
simples_expressao: 
    soma_expressao relacional soma_expressao
    | soma_expressao
    ;

relacional:
    LEQ
    | LT
    | GT
    | BEQ
    | IGL
    | DIF
    ;

soma_expressao:
    soma_expressao soma termo
    | termo
    ;

soma:
    SOM
    | SUB
    ;

termo:
    termo mult fator
    | fator
    ;

mult:
    MUL
    | DIV
    ;

fator:
    APR expressao FPR 
    | var 
    | ativacao
    | NUM
    ;

ativacao:
    ID APR args FPR
    ;

args:
    arg_lista
    | /* vazio */
    ;

arg_lista: 
    arg_lista VRG expressao
    | expressao
    ;
%%

int main(int argc, char *argv[])
{
    printf("\nParser em execucao...\n");
    abrirArq(argv[1]);
    
    int resultado = yyparse();
    if(!resultado){
        printf("Analise sintatica e lexica concluida com sucesso!\n");
    }
    return resultado;
}

void yyerror(char * msg)
{
    /*coloquei o yytext no comeco do codigo*/
  printf("Erro sintatico na linha %d: %s antes de '%s'\n", n_linha, msg, yytext);

}
