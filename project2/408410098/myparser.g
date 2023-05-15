grammar myparser;

options {
   language = Java;
}

program:(VOID|INT)? MAIN '(' ')' '{' statements '}'
        {System.out.println("MAIN () {statements}");}
;


/* primary expression unit */
    
arith_expression:
 multExpr(
     '+' multExpr{System.out.print(" match +, ");}
	| '-' multExpr{System.out.print(" match -, ");}
	)*

{System.out.println(" arithExpr");}
;

multExpr: signExpr
          ( '*' signExpr {System.out.print(" match *, ");}
          | '/' signExpr {System.out.print(" match /, ");}
          | '%' signExpr {System.out.print(" match mod, ");}
		  )*
{System.out.println(" mulExpr");}
;

signExpr: (primaryExpr{System.out.print(" match pri, ");}
        | '-' primaryExpr{System.out.print(" match -pri, ");})
{System.out.println(" signExpr");}
;
		  
primaryExpr: (
    Integer_constant {System.out.print(" match int-constant, ");}
|   Floating_point_constant {System.out.print(" match float-constant, ");}
|   Identifier{System.out.print(" match Id, ");}
|   '(' arith_expression ')'{System.out.print(" match (), ");}
)
{System.out.println(" primary-Expr");}
;
/*primary unit end */

iterative_assign:
(
    Identifier ('++'|'--') 
|   ('++'|'--') Identifier 
){System.out.println("iterative assign statement "); }
;

normal_assign:
(Identifier '=' (   arith_expression
                |   Char_constant
                |   String_constant
                )
)
{System.out.println("normal assign statement "); }
;

assign_statement:
    (options{backtrack=true;}: 
        (   normal_assign
        |   iterative_assign  
        ) ';'
    )


;

/*Declaration unit */
    type:
        INT { System.out.println(" type: INT "); }
        |   FLOAT { System.out.println(" type: FLOAT "); }
        |   DOUBLE { System.out.println(" type: DOUBLE "); }
        |   CHAR { System.out.println(" type: CHAR "); }
        |   LONG { System.out.println(" type: LONG "); }
        |   LLONG { System.out.println(" type: LONG LONG "); }
    ;

    declaration_with_init:
        type assign_statement
    {System.out.println("(init-statment)");}
    ;

    declaration_without_init:
        type Identifier ';'
    ;
/*Declaration unit end*/

declaration : 
(
        declaration_with_init 
    |   declaration_without_init
)
{System.out.println("declaration-statment ");}
; 


return_statement:
       RETURN (
                Identifier
            |   Integer_constant
            |   Floating_point_constant
            |   Char_constant
            |   String_constant
            |
            ) ';'
            {System.out.println("return statement "); }
;

/*condition unit */
    boolExpr:
    (options{backtrack=true;}:
            '!' '(' boolExpr ')'
        |   primaryExpr (
                '>'|'>='|'<'|'<='|'&'|'&&'|'=='|'|'|'||'|'^'
            )primaryExpr
        |   primaryExpr
    )
    {System.out.println(" boolExpr");}
    ;

    if_then_statements: 
    {System.out.print(" (if-then-statement Begin)");}
    (
        statement
    |   '{' statements '}'
    )
    {System.out.println(" (if-then-statement End)\n");}
    ;

    if_statement:
        IF '(' (boolExpr) ')'   
    {System.out.println("if statement");}
    ;

    elseif_statement:
        ELSE_IF '(' (boolExpr) ')'
    {System.out.println("else-if statement");}
    ;
    else_statement:
    (options{backtrack=true;}:
        ELSE {System.out.println("else statement");}
    )
    ;
/*condition unit end */

condition_statements:   
    (
        if_statement
    |   else_statement
    |   elseif_statement
    ) 
    if_then_statements
;

/*loop unit */
    in_loop_statement:
    {System.out.println(" (In loop)");}
    (
        statement
    |   '{' statements '}'
    )
    {System.out.println(" (loop end)");}
    ;

    for_statement: (
        options{backtrack=true;}:
            FOR '(' 
            (declaration_with_init|assign_statement) 
            boolExpr ';'
            ( (Identifier '=' arith_expression)| iterative_assign)
            ')' in_loop_statement
        )
    {System.out.println("for-statement");}
    ;

    while_statement:
        WHILE '(' boolExpr ')' in_loop_statement
    {System.out.println("while-statement");}
    ;

/*loop unit end */

loop_statement:
    for_statement
|   while_statement
;


/*function */
    argExpr:(options{backtrack=true;}:
        (primaryExpr| Char_constant| String_constant) (',' (primaryExpr| Char_constant| String_constant))*
        |   
    )
    {System.out.println("argument statment");}
    ;

printf:
    'printf' '(' argExpr ')' ';'
{System.out.println("printf");}
;

function:
    (Identifier) '(' argExpr ')' ';'
//{System.out.println("function");}
;
/* */
statement: 
{System.out.println("\nstatement-> ");}
        (    declaration
        |   assign_statement
        |   condition_statements
        |   loop_statement
        |   CONTINUE ';'
        |   BREAK ';'
        |   function
        |   printf
        |   return_statement

        )
;

statements: 
        statement statements 
    |   

;


/*data structure */
FLOAT:'float';
DOUBLE:'double';
INT: 'int';
CHAR: 'char';
fragment LONG_ROOT: 'long';
LONG: (LONG_ROOT)(' ')(INT?);
LLONG: (LONG_ROOT)(' ')(LONG_ROOT)(' ')(INT?);

/*keyword */
MAIN: 'main';
VOID: 'void';
ELSE_IF: 'else if';
IF: 'if';
ELSE: 'else';
WHILE  : 'while';
FOR    : 'for';
CONTINUE: 'continue';
BREAK  : 'break';
RETURN : 'return';


Identifier:('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*;


/*constant */
Integer_constant:'0'..'9'+;
Floating_point_constant:'0'..'9'+ '.' '0'..'9'+;
Char_constant: '\''(.)?'\'';
String_constant: '"'(.)*'"';



WS:( ' ' | '\t' | '\r' | '\n' ) {$channel=HIDDEN;};
COMMENT:'/*' .* '*/' {$channel=HIDDEN;};