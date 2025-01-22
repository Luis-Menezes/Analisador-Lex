%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
extern int yylex();
extern int contLinha;
void yyerror(const char *erroSint)
%}

%token ELSE IF INT RETURN VOID WHILE SOMA SUB MULT DIV MENOR MAIOR MEOI MAOI IGUAL DIF ATRI
%token PVIR VIR APAR FPAR ACOL FCOL AKEY FKEY
%token ID NUM NOMERR ERRO 

%left SOMA SUB
%left MULT DIV 
%nonassoc MENOR MAIOR MEOI MAOI IGUAL DIF

%%

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
    tipo_especificador ID PVIR
    | tipo_especificador ID ACOL NUM FCOL PVIR
    ;

tipo_especificador:
    INT
    | VOID 
    ;

fun_declaracao:
    tipo_especificador ID APAR params FPAR composto_decl
    ;

params: 
    param_lista 
    | VOID
    ;

param_lista: 
    param_lista VIR param 
    | param
    ;

param:
    tipo_especificador ID 
    | tipo_especificador ID ACOL FCOL
    ;

composto_decl:
    AKEY local_declaracoes statement_lista FKEY
    ;

local_declaracoes:
    local_declaracoes var_declaracao
    | 
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
    expressao PVIR
    | PVIR
    ;

selecao_decl:
    IF APAR expressao FPAR statement
    | IF APAR expressao FPAR statement ELSE statement
    ;

iteracao-decl: 
    WHILE APAR expressao FPAR statement
    ;

retorno-decl: 
    RETURN PVIR
    | RETURN expressao
    ;

expressao: 
    var ATRI expressao
    | simples-expressao
    ;

var: 
    ID 
    | ID ACOL expressao FCOL
    ;
simples-expressao: 
    soma-expressao relacional soma-expressao
    | soma-expressao
    ;

relacional:
    MEOI
    | MENOR
    | MAIOR
    | MAOI
    | IGUAL
    | DIF
    ;

soma-expressao:
    soma-expressao soma termo
    | termo
    ;

soma:
    SOMA
    | SUB
    ;

termo:
    termo mult fator
    | fator
    ;

mult:
    MULT
    | DIV
    ;

fator:
    APAR expressao FPAR 
    | var 
    | ativacao
    | NUM
    ;

ativacao:
    ID APAR args FPAR
    ;

args:
    arg-lista
    | /* vazio */
    ;

arg-lista: 
    arg-lista VIR expressao
    | declaracao
    ;
%%