lexer grammar mylexer;

options {
  language = Java;
}

/* data structure */
INT_TYPE   : 'int';
fragment LONG : 'long';
LONG_TYPE: (LONG)(' ')(INT_TYPE?);
LL_TYPE : (LONG)(' ')(LONG)(' ')(INT_TYPE?);
CHAR_TYPE  : 'char';
VOID_TYPE  : 'void';
FLOAT_TYPE : 'float';
DOUBLE_TYPE: 'double';   
/* -------------- */

/* keywords section */
CONST_TYPE : 'const';
RETURN : 'return';
/* loop */
WHILE  : 'while';
FOR    : 'for';
CONTINUE: 'continue';
BREAK  : 'break';
/*------ */
/*control unit */
IF     : 'if';
ELSE_IF: 'else if';
ELSE   : 'else';
/*------------ */
/*others */
STRUCT : 'struct';
MAIN : 'main';
TYPEDEF : 'typedef';
/* ---------------- */

/* operation  */
ASSIGN: '=';
EQ_OP : '==';
LT_OP : '<';
GT_OP : '>';
NLT_OP: '>=';
NGT_OP: '<=';
NE_OP : '!=';
PL_OP : '+';
PE_OP : '+=';
MI_OP : '-';
ME_OP : '-=';
PP_OP : '++';
MM_OP : '--';
AND_OP: '&&';
OR_OP : '||';
MOD_OP: '%';
TIME_OP:'*';
TE_OP : '*=';
DIV_OP :'/';
DIVE_OP: '/=';
GET_VALUE: '.';
SINGLE_AND: '&';
SINGLE_OR: '|';
/* ---------- */

/*punctuation */
COMMA : ',';
SEMICOLON : ';';
CURLY_BRACKET_L : '{';
CURLY_BRACKET_R : '}';
SQUARE_BRACKET_L : '[';
SQUARE_BRACKET_R : ']';
BRACKET_L : '(';
BRACKET_R : ')';
/* ---------- */

/* Comments */
COMMENT1 : '//'(.)*'\n';
COMMENT2 : '/*' (options{greedy=false;}: .)* '*/';
/*--------- */

WS  : (' '|'\r'|'\t')+ ;
NEW_LINE: '\n' ;


fragment DIGIT : '0'..'9';
fragment FLOAT_NUM1 : (DIGIT)+'.'(DIGIT)*;
fragment FLOAT_NUM2 : '.'(DIGIT)+ ;
fragment LETTER : 'a'..'z' | 'A'..'Z' | '_';

FLOAT_NUM : FLOAT_NUM1 | FLOAT_NUM2 ;
DEC_NUM : (DIGIT)+;
LIB : '#include'(.)*'\n';
ID : (LETTER)(LETTER | DIGIT)* ;
CHAR : '\''(.)?'\'';
STR : '"'(options{greedy=false;}:.)*'"';