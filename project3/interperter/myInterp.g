grammar myInterp;

options {
   language = Java;
   backtrack = true;
}

@header {
    import java.util.HashMap;
    import java.util.ArrayList; 
    import java.util.Scanner;
}
@members {
    HashMap mem = new HashMap();
    boolean traceon = true;
    boolean elseflag = true;
}

/*data structure */
    FLOAT:'float';
    DOUBLE:'double';
    INT: 'int';
    CHAR: 'char';
    fragment LONG_ROOT: 'long';
    LONG: (LONG_ROOT)(' ')(INT?);
    LLONG: (LONG_ROOT)(' ')(LONG_ROOT)(' ')(INT?);

    type : 
    INT| CHAR|FLOAT|DOUBLE|LONG|LLONG;
/* */


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
    STRUCT : 'struct';
    TYPEDEF : 'typedef';
/*  */

Identifier:('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*;


/*constant */
    Integer_constant:'0'..'9'+;
    Floating_point_constant:'0'..'9'+ '.' '0'..'9'+;
    Char_constant: '\''(.)?'\'';
    String_constant: '\"'(.)*'\"';
    WS:( ' ' | '\t' | '\r' | '\n' ) {$channel=HIDDEN;};
    COMMENT:'/*' .* '*/' {$channel=HIDDEN;};
/* */

/* grammer rule */

/*start symbol */
    program:{System.out.println("main\n");}
        (VOID|INT)? MAIN '(' ')' '{' statements[traceon]  '}' ;
/*  */


statements[boolean trace]:
    statement[$trace] statements[$trace]|;

statement[boolean trace]:
{if($trace){System.out.println("====== Statement start ======");}}
    (   {if($trace){System.out.println("[declaration]");}} declaration[$trace] ';'
    |   {if($trace){System.out.println("[assignment]");}} assignment[$trace] ';'
    |   {if($trace){System.out.println("[return] ");}}return_statement[$trace] ';'
    |   {if($trace){System.out.println("[condition]");}}condition[$trace]
    |   {if($trace){System.out.println("[printf]");}}printf_statement[$trace] ';'
    |   {if($trace){System.out.println("[scanf]");}}scanf_statment[$trace] ';'
    )
{if($trace){System.out.println("======= Statement end =======\n");}}
;
/* arithmetic expression */
    arithexpr[boolean trace]  returns[int v]:
        a = mulexpr[$trace]{if($trace){$v = $a.v;}}(
            '+' b0 = mulexpr[$trace]{if($trace){$v = $v + $b0.v;}}
        |   '-' b1 = mulexpr[$trace]{if($trace){$v = $v - $b1.v;}}
        )*
    ;
    mulexpr[boolean trace] returns[int v]: 
        a = signexpr[$trace]{if($trace){$v = $a.v;}}
        (   
            '*' b0 = signexpr[$trace] {if($trace){$v = $v * $b0.v;}}
        |   '/' b1 = signexpr[$trace] {if($trace){$v = $v / $b1.v;}}
        |   '%' b2 = signexpr[$trace] {if($trace){$v = $v \% $b2.v;}}
		)*
    ;

    signexpr[boolean trace] returns[int v]: 
            a = primaryexpr[$trace]{if($trace){$v = $a.v;}}
        |   '-' b = primaryexpr[$trace]{if($trace){$v = - $b.v;}}

    ;
		  
    primaryexpr[boolean trace] returns[int v]: 
        Integer_constant {
            if($trace){
                $v= Integer.parseInt($Integer_constant.text);
            }
        }
    |   Identifier{
            if($trace){
                Integer v0 = (Integer)mem.get($Identifier.text);
                if ( v0!=null ) $v = v0.intValue();
                else System.err.println("undefined variable "+$Identifier.text);
            }
        }
    |   '(' a = arithexpr[$trace] ')'{
            if($trace){$v = $a.v;}
        }
    ;

assignment[boolean trace]:
    Identifier '=' v = arithexpr[$trace]{
        if($trace){ 
            mem.put($Identifier.text, new Integer($v.v));
            Integer v0 = (Integer)mem.get($Identifier.text);
            System.out.println($Identifier.text + " : " + v0.intValue());
        }

    }
;

declaration_unit[boolean trace]:
    Identifier{
            if($trace){
                mem.put($Identifier.text, new Integer(0));
                System.out.println($Identifier.text + " No init value");
            }
        } 
    |   assignment[$trace]
;
declaration[boolean trace] : 
    INT(
        declaration_unit[$trace]
    )(','declaration_unit[$trace])*
;

return_statement[boolean trace]:

    RETURN 
    (
        a = arithexpr[$trace]
    | 
    )
;


bool_statement[boolean trace] returns[boolean v]:
(
        a=primaryexpr[$trace]{if($trace){System.out.print($a.v);}}
        (
        |  '>' b0=primaryexpr[$trace]{
                if($trace){
                    $v = $a.v > $b0.v ;
                    System.out.print(">"+$b0.v+" ");
                }
            }
        |  '>=' b1 = primaryexpr[$trace]{
                if($trace){
                    $v = $a.v >= $b1.v ;
                    System.out.print(">="+$b1.v+" ");
                } 
            }

        |  '<' b2 = primaryexpr[$trace]{
                if($trace){
                    $v = $a.v < $b2.v ;
                    System.out.print("<"+$b2.v+" ");
                } 
            }
        |  '<=' b3 = primaryexpr[$trace]{
                if($trace){
                    $v = $a.v <= $b3.v ;
                    System.out.print("<="+$b3.v+" ");
                } 
            }
        | '==' b4 = primaryexpr[$trace]{
                if($trace){
                    $v = $a.v == $b4.v ;
                    System.out.print("=="+$b4.v+" ");
                } 
            }
        | '!='  b5 = primaryexpr[$trace]{
                if($trace){
                    $v = $a.v != $b5.v ;
                    System.out.print("!="+$b5.v+" ");
                } 
            }
        )
    
    |   '!' 
        (   a1=bool_statement[$trace]{
                if($trace){
                    $v = !$a1.v;
                    System.out.print("!"+String.valueOf($a1.v)+" ");
                } 
            }
        )
)
{
    if($trace){
        System.out.println($v);
    }
} 
;


in_bracket_statement[boolean trace]:
    statement[$trace]
|   '{' statements[$trace] '}'
;

condition[boolean trace]: (
    b = ifstat[$trace]{
        if($trace){
            if($b.flag){elseflag = false;}
        }
    }in_bracket_statement[$b.flag]
    (
        b1 = else_if_stat[elseflag]{
            if(elseflag){
                if($b1.flag){
                    elseflag=false;
                }
            }
        }in_bracket_statement[$b1.flag]
    )*
    (
        ELSE in_bracket_statement[elseflag]
    )?
){elseflag = true;}
;

ifstat[boolean trace] returns[boolean flag]:
    IF '(' b=bool_statement[$trace] ')' {
        if($trace){$flag = $b.v;}
    }
;

else_if_stat[boolean trace] returns[boolean flag]:
    ELSE_IF '(' b=bool_statement[$trace] ')' {
        /* System.out.println("else if");*/
        if($trace){$flag = $b.v;}
    }
; 

printf_statement[boolean trace]@init{ArrayList<Integer> buf = new ArrayList<Integer>();}:
    'printf''(' formatstr = String_constant (
        ',' Identifier{
            if($trace){
                Integer v0 = (Integer)mem.get($Identifier.text);
                buf.add(v0.intValue());
                //System.out.println("buf: "+v0.intValue());
            }
        }
        )*
    ')'
    {
        if($trace){
            String fstr = new String($formatstr.text);
            fstr = fstr.substring(1,fstr.length()-1);
            fstr = fstr.replace("\\n", "\n");
            for(int i = 0; i< buf.size(); i++){
                fstr = fstr.replaceFirst("\%d", (buf.get(i)).toString());
            }
            System.out.println(fstr);
        }
    }
;

scanf_statment[boolean trace]@init{Scanner sc = new Scanner(System.in);}:
( 'scanf' '(' formatstring=String_constant (',' '&'Identifier
    {
        if($trace){
            int input = sc.nextInt();
            mem.put($Identifier.text, new Integer(input));
        }
    }
    
    )+ ')'
){sc.close();}
;