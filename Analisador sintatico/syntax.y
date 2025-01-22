%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

extern int yylex();
extern int contLinha;
void yyerror(char *erroSint)
%}

%token ELS IF INT RTN VOD WHL SOM SUB MUL DIV LT GT LEQ BEQ IGL DIF ATT
%token PEV VRG APR FPR ACL FCL ACH FCH
%token   ID NUM IDERR ERR 

%start entrada
%left SOM SUB
%left MUL DIV 
%nonassoc LT GT LEQ BEQ IGL DIF

%%
entrada :	/* entrada vazia */
	| 	entrada programa;
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

tipo_especificador:
    INT
    | VOD 
    ;

fun_declaracao:
    tipo_especificador ID APR params FPR composto_decl
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
    | iteracao-decl
    | retorno-decl
    ;

expressao_decl:
    expressao PEV
    | PEV
    ;

selecao_decl:
    IF APR expressao FPR statement
    | IF APR expressao FPR statement ELS statement
    ;

iteracao-decl: 
    WHL APR expressao FPR statement
    ;

retorno-decl: 
    RTN PEV
    | RTN expressao
    ;

expressao: 
    var ATT expressao
    | simples-expressao
    ;

var: 
    ID 
    | ID ACL expressao FCL
    ;
simples-expressao: 
    soma-expressao relacional soma-expressao
    | soma-expressao
    ;

relacional:
    LEQ
    | LT
    | GT
    | BEQ
    | IGL
    | DIF
    ;

soma-expressao:
    soma-expressao soma termo
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
    arg-lista
    | /* vazio */
    ;

arg-lista: 
    arg-lista VRG expressao
    | declaracao
    ;
%%