grammar myCompiler;

options {
   language = Java;
   backtrack = true;
}

@header {
   // import packages here.
   import java.util.HashMap;
   import java.util.ArrayList;
}

@members {
   boolean TRACEON = false;
   public enum Type{
      ERR, BOOL,
      INT, FLOAT, 
      CHAR, CONST_INT, CONST_FLOAT;
   }

   class tVar {
	   int   varIndex; // temporary variable's index. Ex: t1, t2, ..., etc.
	   boolean flag; // value of boolean
      int   iValue;   // value of constant integer. Ex: 123.
	   float fValue;   // value of constant floating point. Ex: 2.314.
	};

   class Info {
      Type theType;  // type information.
      tVar theVar;
	   
	   Info() {
         theType = Type.ERR;
		   theVar = new tVar();
	   }
   };

   HashMap<String, Info> symtab = new HashMap<String, Info>();

   int labelCount = 0;
   String mainlabel = "L0";
   int varCount = 0;
   int fstrCount = 0;
   int idleCount = 0;
   Type dtype = Type.ERR;
   List<String> TextCode = new ArrayList<String>();

   void prologue(){
      TextCode.add("; === prologue ====");
      TextCode.add("declare dso_local i32 @printf(i8*, ...)\n");
	   TextCode.add("define dso_local i32 @main()");
	   TextCode.add("{");
   }

   void epilogue(){
      /* handle epilogue */
      TextCode.add("\n; === epilogue ===");
	   TextCode.add("ret i32 0");
      TextCode.add("}");
   }
    
   String newLabel(){
      return (new String("L")) + Integer.toString(labelCount);
   } 

   public List<String> getTextCode(){
      return TextCode;
   }
}

/* description of the tokens */
   FLOAT:'float';
   INT:'int';
   CHAR: 'char';

   MAIN: 'main';
   VOID: 'void';
   IF: 'if';
   ELSE: 'else';
   FOR: 'for';

   RelationOP: '>' |'>=' | '<' | '<=' | '==' | '!=';
   BooleanOP: '&&' |'||' ;
   Identifier:('a'..'z'|'A'..'Z'|'_') ('a'..'z'|'A'..'Z'|'0'..'9'|'_')*;
   Integer_constant:'0'..'9'+;
   Floating_point_constant:'0'..'9'+ '.' '0'..'9'+;
   STRING_LITERAL: '"' ( EscapeSequence | ~('\\'|'"') )* '"';
   WS:( ' ' | '\t' | '\r' | '\n' ) {$channel=HIDDEN;};
   COMMENT:'/*' .* '*/' {$channel=HIDDEN;};

   fragment 
   EscapeSequence: '\\' ('b'|'t'|'n'|'a'|'r'|'\"'|'\''|'\\');
/*  */

/* ==========start symbol========== */
   program: INT MAIN '(' ')'{
      /* Output function prologue */
      prologue();
   }
   '{'  statements '}'{
	if (TRACEON) System.out.println("INT MAIN () {declarations statements}");
   /* output function epilogue */	  
   epilogue();
   };
/* ==========start symbol========== */

/* ==========statments========== */
   statements: 
      statement statements
      |
      ;

   statement:
      declarations ';'
      | assignment ';' 
      | printf ';'  
      | condition   
      | returnstmt ';'
   ;
   block_stmt: '{' statements '}';
/* ==========statments========== */

/* ==========type========== */
   type returns [Type attr_type] : 
         INT { 
            if (TRACEON) System.out.println("type: INT"); 
            $attr_type=Type.INT; 
         }
      |  CHAR { 
            if (TRACEON) System.out.println("type: CHAR"); 
            $attr_type=Type.CHAR; 
         }
      |  FLOAT {
            if (TRACEON) System.out.println("type: FLOAT"); 
            $attr_type=Type.FLOAT; 
         };
/* ==========type========== */

/* ==========arithmetic========== */
   arith_expression
      returns [Info theInfo]
      @init {theInfo = new Info();}: 
      a=multExpr { $theInfo=$a.theInfo; }
      (
         '+' b=multExpr{
         if (($a.theInfo.theType == Type.INT) && 
            ($b.theInfo.theType == Type.INT)) {
            TextCode.add("\%t" + varCount + " = add nsw i32 \%t" + $theInfo.theVar.varIndex + ", \%t" + $b.theInfo.theVar.varIndex);
			   $theInfo.theType = Type.INT;
			   $theInfo.theVar.varIndex = varCount;
				varCount ++;
         } 
         else if (($a.theInfo.theType == Type.INT) && 
                  ($b.theInfo.theType == Type.CONST_INT)) {
            TextCode.add("\%t" + varCount + " = add nsw i32 \%t" + $theInfo.theVar.varIndex + ", " + $b.theInfo.theVar.iValue);
            $theInfo.theType = Type.INT;
			   $theInfo.theVar.varIndex = varCount;
				varCount ++;
         }
         else if (($a.theInfo.theType == Type.CONST_INT) && 
                  ($b.theInfo.theType == Type.CONST_INT)) {
            TextCode.add("\%t" + varCount + " = add nsw i32 " + $theInfo.theVar.iValue + ", " + $b.theInfo.theVar.iValue);
            $theInfo.theType = Type.INT;
			   $theInfo.theVar.varIndex = varCount;
				varCount ++;
         }
         else if (($a.theInfo.theType == Type.CONST_INT) && 
                  ($b.theInfo.theType == Type.INT)) {

            TextCode.add("\%t" + varCount + " = add nsw i32 " + $theInfo.theVar.iValue + ", \%t" + $b.theInfo.theVar.varIndex);
            $theInfo.theType = Type.INT;
			   $theInfo.theVar.varIndex = varCount;
				varCount ++;
         }
      }
      | '-' b0=multExpr{
         if (($a.theInfo.theType == Type.INT) && 
            ($b0.theInfo.theType == Type.INT)){
            TextCode.add("\%t"+varCount+" = sub nsw i32 \%t"+ $theInfo.theVar.varIndex + ", \%t" + $b0.theInfo.theVar.varIndex);
            $theInfo.theType = Type.INT;
			   $theInfo.theVar.varIndex = varCount;
				varCount ++;
         }
         else if (($a.theInfo.theType == Type.INT) && 
               ($b0.theInfo.theType == Type.CONST_INT)) {
            TextCode.add("\%t" + varCount + " = sub nsw i32 \%t" + $theInfo.theVar.varIndex + ", " + $b0.theInfo.theVar.iValue);
            $theInfo.theType = Type.INT;
			   $theInfo.theVar.varIndex = varCount;
				varCount ++;
         }
         else if (($a.theInfo.theType == Type.CONST_INT) && 
                  ($b0.theInfo.theType == Type.CONST_INT)) {
            TextCode.add("\%t" + varCount + " = sub nsw i32 " + $theInfo.theVar.iValue + ", " + $b0.theInfo.theVar.iValue);
            $theInfo.theType = Type.INT;
			   $theInfo.theVar.varIndex = varCount;
				varCount ++;
         }
         else if (($a.theInfo.theType == Type.CONST_INT) && 
                  ($b0.theInfo.theType == Type.INT)) {
            TextCode.add("\%t" + varCount + " = sub nsw i32 " + $theInfo.theVar.iValue + ", \%t" + $b0.theInfo.theVar.varIndex);
            $theInfo.theType = Type.INT;
			   $theInfo.theVar.varIndex = varCount;
				varCount ++;
         }
      }
      )*;

   multExpr returns [Info theInfo]
      @init {theInfo = new Info();}: 
      a=signExpr { $theInfo=$a.theInfo; }
      (  '*' b=signExpr{
         if(($a.theInfo.theType == Type.INT)&&
            ($b.theInfo.theType == Type.INT)){
            TextCode.add("\%t" + varCount + " = mul nsw i32 \%t" + $theInfo.theVar.varIndex + ", \%t" + $b.theInfo.theVar.varIndex);
		      $theInfo.theType = Type.INT;
		      $theInfo.theVar.varIndex = varCount;
		      varCount ++;
         }
         else if (($a.theInfo.theType == Type.INT)&&
               ($b.theInfo.theType == Type.CONST_INT)){
            TextCode.add("\%t" + varCount + " = mul nsw i32 \%t" + $theInfo.theVar.varIndex + ", " + $b.theInfo.theVar.iValue);
		      $theInfo.theType = Type.INT;
		      $theInfo.theVar.varIndex = varCount;
		      varCount ++;
         }         
         else if (($a.theInfo.theType == Type.CONST_INT) && 
                  ($b.theInfo.theType == Type.CONST_INT)) {
            TextCode.add("\%t" + varCount + " = mul nsw i32 " + $theInfo.theVar.iValue + ", " + $b.theInfo.theVar.iValue);
            $theInfo.theType = Type.INT;
			   $theInfo.theVar.varIndex = varCount;
				varCount ++;
         }
         else if (($a.theInfo.theType == Type.CONST_INT) && 
                  ($b.theInfo.theType == Type.INT)) {

            TextCode.add("\%t" + varCount + " = mul nsw i32 " + $theInfo.theVar.iValue + ", \%t" + $b.theInfo.theVar.varIndex);
            $theInfo.theType = Type.INT;
			   $theInfo.theVar.varIndex = varCount;
				varCount ++;
         }
         }
      |  '/' b0=signExpr{
         if(($a.theInfo.theType == Type.INT)&&
            ($b0.theInfo.theType == Type.INT)){
            TextCode.add("\%t" + varCount + " = sdiv i32 \%t" + $theInfo.theVar.varIndex + ", \%t" + $b0.theInfo.theVar.varIndex);
		      $theInfo.theType = Type.INT;
		      $theInfo.theVar.varIndex = varCount;
		      varCount ++;
         }
         else if (($a.theInfo.theType == Type.INT)&&
               ($b0.theInfo.theType == Type.CONST_INT)){
            TextCode.add("\%t" + varCount + " = sdiv i32 \%t" + $theInfo.theVar.varIndex + ", " + $b0.theInfo.theVar.iValue);
		      $theInfo.theType = Type.INT;
		      $theInfo.theVar.varIndex = varCount;
		      varCount ++;
         }
         else if (($a.theInfo.theType == Type.CONST_INT) && 
                  ($b0.theInfo.theType == Type.CONST_INT)) {
            TextCode.add("\%t" + varCount + " = sdiv i32 " + $theInfo.theVar.iValue + ", " + $b0.theInfo.theVar.iValue);
            $theInfo.theType = Type.INT;
			   $theInfo.theVar.varIndex = varCount;
				varCount ++;
         }
         else if (($a.theInfo.theType == Type.CONST_INT) && 
                  ($b0.theInfo.theType == Type.INT)) {
            TextCode.add("\%t" + varCount + " = sdiv i32 " + $theInfo.theVar.iValue + ", \%t" + $b0.theInfo.theVar.varIndex);
            $theInfo.theType = Type.INT;
			   $theInfo.theVar.varIndex = varCount;
				varCount ++;
         }

         }
      |  '%' b1=signExpr{
         if(($a.theInfo.theType == Type.INT)&&
            ($b1.theInfo.theType == Type.INT)){
            TextCode.add("\%t" + varCount + " = srem i32 \%t" + $theInfo.theVar.varIndex + ", \%t" + $b1.theInfo.theVar.varIndex);
		      $theInfo.theType = Type.INT;
		      $theInfo.theVar.varIndex = varCount;
		      varCount ++;
         }
         else if (($a.theInfo.theType == Type.INT)&&
               ($b1.theInfo.theType == Type.CONST_INT)){
            TextCode.add("\%t" + varCount + " = srem i32 \%t" + $theInfo.theVar.varIndex + ", " + $b1.theInfo.theVar.iValue);
		      $theInfo.theType = Type.INT;
		      $theInfo.theVar.varIndex = varCount;
		      varCount ++;
         }         
         else if (($a.theInfo.theType == Type.CONST_INT) && 
                  ($b1.theInfo.theType == Type.CONST_INT)) {
            TextCode.add("\%t" + varCount + " = srem i32 " + $theInfo.theVar.iValue + ", " + $b1.theInfo.theVar.iValue);
            $theInfo.theType = Type.INT;
			   $theInfo.theVar.varIndex = varCount;
				varCount ++;
         }
         else if (($a.theInfo.theType == Type.CONST_INT) && 
                  ($b1.theInfo.theType == Type.INT)) {
            TextCode.add("\%t" + varCount + " = srem i32 " + $theInfo.theVar.iValue + ", \%t" + $b1.theInfo.theVar.varIndex);
            $theInfo.theType = Type.INT;
			   $theInfo.theVar.varIndex = varCount;
				varCount ++;
         }
         }
	   )*;

   signExpr returns [Info theInfo]
      @init {theInfo = new Info();}: 
         a=primaryExpr { $theInfo=$a.theInfo; } 
      | '-' a0=primaryExpr {

         $theInfo=$a0.theInfo;
         if ($a0.theInfo.theType == Type.INT){
      
            TextCode.add("\%t" + varCount + " = sub nsw i32 0" + ", \%t" + $a0.theInfo.theVar.varIndex);
			   $theInfo.theVar.varIndex = varCount;
            $theInfo.theType = Type.INT;
				varCount ++;
         }
         else if ($a0.theInfo.theType == Type.CONST_INT){
         
            TextCode.add("\%t" + varCount + " = sub nsw i32 0" + ", " + $a0.theInfo.theVar.iValue);
		      $theInfo.theVar.varIndex = varCount;
            $theInfo.theType = Type.INT;
		      varCount ++;
         }
      };
  
   primaryExpr returns [Info theInfo]
      @init {theInfo = new Info();}: 
      Integer_constant{
         $theInfo.theType = Type.CONST_INT;
			$theInfo.theVar.iValue = Integer.parseInt($Integer_constant.text);
      }
      | Identifier{
         // get type information from symtab.
         Type the_type = symtab.get($Identifier.text).theType;
			$theInfo.theType = the_type;

         // get variable index from symtab.
         int vIndex = symtab.get($Identifier.text).theVar.varIndex;
				
         switch (the_type) {
            case INT: 
            // get a new temporary variable and
				// load the variable into the temporary variable.
                         
				// Ex: \%tx = load i32, i32* \%ty.
				TextCode.add("\%t" + varCount + " = load i32, i32* \%t" + vIndex+", align 4");
				         
				// Now, Identifier's value is at the temporary variable \%t[varCount].
				// Therefore, update it.
				$theInfo.theVar.varIndex = varCount;
				varCount ++;
            break;
         }
      }
	   | '(' a = arith_expression{ theInfo=$a.theInfo;} ')';
/* ==========arithmetic========== */

/* ==========condition========== */
   cond_expression returns [Info theInfo] @init {theInfo = new Info();}: 
      a = arith_expression RelationOP b=arith_expression{

         switch($RelationOP.text){
         case "==":
            if(($a.theInfo.theType == Type.INT)&&
               ($b.theInfo.theType == Type.INT)){
               TextCode.add("\%t" + varCount + " = icmp eq i32 \%t" + $a.theInfo.theVar.varIndex + ", \%t" + $b.theInfo.theVar.varIndex);
		         $theInfo.theType = Type.BOOL;
		         $theInfo.theVar.varIndex = varCount;
		         
            }
            else if (($a.theInfo.theType == Type.INT)&&
               ($b.theInfo.theType == Type.CONST_INT)){
               TextCode.add("\%t" + varCount + " = icmp eq i32 \%t" + $a.theInfo.theVar.varIndex + ", " + $b.theInfo.theVar.iValue);
		         $theInfo.theType = Type.BOOL;
		         $theInfo.theVar.varIndex = varCount;
		         
            }         
            else if (($a.theInfo.theType == Type.CONST_INT) && 
                  ($b.theInfo.theType == Type.CONST_INT)) {
               TextCode.add("\%t" + varCount + " = icmp eq i32 " + $a.theInfo.theVar.iValue + ", " + $b.theInfo.theVar.iValue);
               $theInfo.theType = Type.BOOL;
			      $theInfo.theVar.varIndex = varCount;
				  
            }
            else if (($a.theInfo.theType == Type.CONST_INT) && 
                  ($b.theInfo.theType == Type.INT)) {

               TextCode.add("\%t" + varCount + " = icmp eq i32 " + $a.theInfo.theVar.iValue + ", \%t" + $b.theInfo.theVar.varIndex);
               $theInfo.theType = Type.BOOL;
			      $theInfo.theVar.varIndex = varCount;
				  
            }
            break;
         case "!=":
            if(($a.theInfo.theType == Type.INT)&&
               ($b.theInfo.theType == Type.INT)){
               TextCode.add("\%t" + varCount + " = icmp ne i32 \%t" + $a.theInfo.theVar.varIndex + ", \%t" + $b.theInfo.theVar.varIndex);
		         $theInfo.theType = Type.BOOL;
		         $theInfo.theVar.varIndex = varCount;
		         
            }
            else if (($a.theInfo.theType == Type.INT)&&
               ($b.theInfo.theType == Type.CONST_INT)){
               TextCode.add("\%t" + varCount + " = icmp ne i32 \%t" + $a.theInfo.theVar.varIndex + ", " + $b.theInfo.theVar.iValue);
		         $theInfo.theType = Type.BOOL;
		         $theInfo.theVar.varIndex = varCount;
		         
            }         
            else if (($a.theInfo.theType == Type.CONST_INT) && 
                  ($b.theInfo.theType == Type.CONST_INT)) {
               TextCode.add("\%t" + varCount + " = icmp ne i32 " + $a.theInfo.theVar.iValue + ", " + $b.theInfo.theVar.iValue);
               $theInfo.theType = Type.BOOL;
			      $theInfo.theVar.varIndex = varCount;
				  
            }
            else if (($a.theInfo.theType == Type.CONST_INT) && 
                  ($b.theInfo.theType == Type.INT)) {

               TextCode.add("\%t" + varCount + " = icmp ne i32 " + $a.theInfo.theVar.iValue + ", \%t" + $b.theInfo.theVar.varIndex);
               $theInfo.theType = Type.BOOL;
			      $theInfo.theVar.varIndex = varCount;
				   
            }
            break;
         case ">":
            if(($a.theInfo.theType == Type.INT)&&
               ($b.theInfo.theType == Type.INT)){
               TextCode.add("\%t" + varCount + " = icmp sgt i32 \%t" + $a.theInfo.theVar.varIndex + ", \%t" + $b.theInfo.theVar.varIndex);
		         $theInfo.theType = Type.BOOL;
		         $theInfo.theVar.varIndex = varCount;
		         varCount ++;
            }
            else if (($a.theInfo.theType == Type.INT)&&
               ($b.theInfo.theType == Type.CONST_INT)){
               TextCode.add("\%t" + varCount + " = icmp sgt i32 \%t" + $a.theInfo.theVar.varIndex + ", " + $b.theInfo.theVar.iValue);
		         $theInfo.theType = Type.BOOL;
		         $theInfo.theVar.varIndex = varCount;
		         varCount ++;
            }         
            else if (($a.theInfo.theType == Type.CONST_INT) && 
                  ($b.theInfo.theType == Type.CONST_INT)) {
               TextCode.add("\%t" + varCount + " = icmp sgt i32 " + $a.theInfo.theVar.iValue + ", " + $b.theInfo.theVar.iValue);
               $theInfo.theType = Type.BOOL;
			      $theInfo.theVar.varIndex = varCount;
				   varCount ++;
            }
            else if (($a.theInfo.theType == Type.CONST_INT) && 
                  ($b.theInfo.theType == Type.INT)) {

               TextCode.add("\%t" + varCount + " = icmp sgt i32 " + $a.theInfo.theVar.iValue + ", \%t" + $b.theInfo.theVar.varIndex);
               $theInfo.theType = Type.BOOL;
			      $theInfo.theVar.varIndex = varCount;
				   
            }
            break;
         case ">=":
            if(($a.theInfo.theType == Type.INT)&&
               ($b.theInfo.theType == Type.INT)){
               TextCode.add("\%t" + varCount + " = icmp sge i32 \%t" + $a.theInfo.theVar.varIndex + ", \%t" + $b.theInfo.theVar.varIndex);
		         $theInfo.theType = Type.BOOL;
		         $theInfo.theVar.varIndex = varCount;
		         
            }
            else if (($a.theInfo.theType == Type.INT)&&
               ($b.theInfo.theType == Type.CONST_INT)){
               TextCode.add("\%t" + varCount + " = icmp sge i32 \%t" + $a.theInfo.theVar.varIndex + ", " + $b.theInfo.theVar.iValue);
		         $theInfo.theType = Type.BOOL;
		         $theInfo.theVar.varIndex = varCount;
		         
            }         
            else if (($a.theInfo.theType == Type.CONST_INT) && 
                  ($b.theInfo.theType == Type.CONST_INT)) {
               TextCode.add("\%t" + varCount + " = icmp sge i32 " + $a.theInfo.theVar.iValue + ", " + $b.theInfo.theVar.iValue);
               $theInfo.theType = Type.BOOL;
			      $theInfo.theVar.varIndex = varCount;
				   
            }
            else if (($a.theInfo.theType == Type.CONST_INT) && 
                  ($b.theInfo.theType == Type.INT)) {

               TextCode.add("\%t" + varCount + " = icmp sge i32 " + $a.theInfo.theVar.iValue + ", \%t" + $b.theInfo.theVar.varIndex);
               $theInfo.theType = Type.BOOL;
			      $theInfo.theVar.varIndex = varCount;
				   
            }
            break;
         case "<" :
            if(($a.theInfo.theType == Type.INT)&&
               ($b.theInfo.theType == Type.INT)){
               TextCode.add("\%t" + varCount + " = icmp slt i32 \%t" + $a.theInfo.theVar.varIndex + ", \%t" + $b.theInfo.theVar.varIndex);
		         $theInfo.theType = Type.BOOL;
		         $theInfo.theVar.varIndex = varCount;
		        
            }
            else if (($a.theInfo.theType == Type.INT)&&
               ($b.theInfo.theType == Type.CONST_INT)){
               TextCode.add("\%t" + varCount + " = icmp slt i32 \%t" + $a.theInfo.theVar.varIndex + ", " + $b.theInfo.theVar.iValue);
		         $theInfo.theType = Type.BOOL;
		         $theInfo.theVar.varIndex = varCount;
		         
            }         
            else if (($a.theInfo.theType == Type.CONST_INT) && 
                  ($b.theInfo.theType == Type.CONST_INT)) {
               TextCode.add("\%t" + varCount + " = icmp slt i32 " + $a.theInfo.theVar.iValue + ", " + $b.theInfo.theVar.iValue);
               $theInfo.theType = Type.BOOL;
			      $theInfo.theVar.varIndex = varCount;
				   
            }
            else if (($a.theInfo.theType == Type.CONST_INT) && 
                  ($b.theInfo.theType == Type.INT)) {

               TextCode.add("\%t" + varCount + " = icmp slt i32 " + $a.theInfo.theVar.iValue + ", \%t" + $b.theInfo.theVar.varIndex);
               $theInfo.theType = Type.BOOL;
			      $theInfo.theVar.varIndex = varCount;
				   
            }
            break;
         case "<=":
                     if(($a.theInfo.theType == Type.INT)&&
               ($b.theInfo.theType == Type.INT)){
               TextCode.add("\%t" + varCount + " = icmp sle i32 \%t" + $a.theInfo.theVar.varIndex + ", \%t" + $b.theInfo.theVar.varIndex);
		         $theInfo.theType = Type.BOOL;
		         $theInfo.theVar.varIndex = varCount;
		         
            }
            else if (($a.theInfo.theType == Type.INT)&&
               ($b.theInfo.theType == Type.CONST_INT)){
               TextCode.add("\%t" + varCount + " = icmp sle i32 \%t" + $a.theInfo.theVar.varIndex + ", " + $b.theInfo.theVar.iValue);
		         $theInfo.theType = Type.BOOL;
		         $theInfo.theVar.varIndex = varCount;
		         
            }         
            else if (($a.theInfo.theType == Type.CONST_INT) && 
                  ($b.theInfo.theType == Type.CONST_INT)) {
               TextCode.add("\%t" + varCount + " = icmp sle i32 " + $a.theInfo.theVar.iValue + ", " + $b.theInfo.theVar.iValue);
               $theInfo.theType = Type.BOOL;
			      $theInfo.theVar.varIndex = varCount;
				   
            }
            else if (($a.theInfo.theType == Type.CONST_INT) && 
                  ($b.theInfo.theType == Type.INT)) {

               TextCode.add("\%t" + varCount + " = icmp sle i32 " + $a.theInfo.theVar.iValue + ", \%t" + $b.theInfo.theVar.varIndex);
               $theInfo.theType = Type.BOOL;
			      $theInfo.theVar.varIndex = varCount;
				   
            }
            break;
         }
         varCount++;
      }
   
 ;

/* ==========condition=========== */

/* ==========declarations========== */

   declarations:
      type{dtype=$type.attr_type;} declaration[dtype]
   ;

   declaration[Type declara_type]: 
      Identifier{
         if (symtab.containsKey($Identifier.text)) {
              // variable re-declared.
              System.out.println("Type Error: " + 
                                  $Identifier.getLine() + 
                                 ": Redeclared identifier.");
              System.exit(0);
         }
                 
         /* Add ID and its info into the symbol table. */
	      Info the_entry = new Info();
		   the_entry.theType = $declara_type;
		   the_entry.theVar.varIndex = varCount;
		   varCount ++;
		   symtab.put($Identifier.text, the_entry);   
         if ($declara_type == Type.INT) { 
            TextCode.add("\%t" + the_entry.theVar.varIndex + " = alloca i32, align 4");
            TextCode.add("store i32 0, i32* \%t"+the_entry.theVar.varIndex+", align 4");
         }
      }
   ('=' a = arith_expression{
      Info id = symtab.get($Identifier.text);
      if ($a.theInfo.theType==Type.INT){
      
         TextCode.add("store i32 \%t"+$a.theInfo.theVar.varIndex +", i32* \%t"+id.theVar.varIndex+", align 4");
      }
      else if($a.theInfo.theType == Type.CONST_INT){

         TextCode.add("store i32 "+$a.theInfo.theVar.iValue +", i32* \%t"+id.theVar.varIndex+", align 4");
      }
      
   })?(
      ',' declaration[dtype]
   )*; 
/* ==========declarations========== */

/* ==========assignment========== */
   assignment :
   Identifier '=' arith_expression{
      Info theRHS = $arith_expression.theInfo;
		Info theLHS = symtab.get($Identifier.text); 
		   
      if ((theLHS.theType == Type.INT) &&
            (theRHS.theType == Type.INT)) {		   
         // issue store insruction.
         // Ex: store i32 \%tx, i32* \%ty
         TextCode.add("store i32 \%t" + theRHS.theVar.varIndex + ", i32* \%t" + theLHS.theVar.varIndex);
		}
      else if ((theLHS.theType == Type.INT) &&
				    (theRHS.theType == Type.CONST_INT)) {
         // issue store insruction.
         // Ex: store i32 value, i32* \%ty
         TextCode.add("store i32 " + theRHS.theVar.iValue + ", i32* \%t" + theLHS.theVar.varIndex);				
		}
	}
   ;
/* ==========assignment========== */

/* ==========void function========== */
   func_no_return_stmt: Identifier '(' argument ')';
   argument: arg (',' arg)*;
   arg: arith_expression
   | STRING_LITERAL
   ;
/* ==========void function========== */

/* ==========printf========== */
   printf
   @init{ArrayList<Info> buf = new ArrayList<Info>();}:
   'printf' '(' STRING_LITERAL (
      ',' Identifier{
         Info id = new Info();
         id = symtab.get($Identifier.text);
         buf.add(id);
      }
   )*
   ')'{
      String fstr = $STRING_LITERAL.text;
      
      fstr = fstr.substring(1,fstr.length()-1);
      int strlen = fstr.replaceAll("\\\\","").length()+1;
      //System.out.println(fstr.replaceAll("\\\\",""));
      //System.out.println("Len = "+strlen);
      fstr = fstr+"\\00";
      
      if(fstr.contains("\\n")){
         fstr = fstr.replaceAll("\\\\n", "\\\\0A");  
      }
      TextCode.add(1, "@str" + fstrCount + " = private unnamed_addr constant [" + strlen + " x i8] c\"" + fstr + "\", align 1");
      int printfvar = varCount+buf.size();
      String ins = 
         "\%t"+ printfvar + 
         " = call i32 (i8*, ...) @printf(i8* getelementptr inbounds (["+
         strlen +
         " x i8], ["+ 
         strlen +
         " x i8]* @str"+fstrCount+", i64 0, i64 0 )";

      for(int i = 0; i< buf.size(); i++){   
         if (buf.get(i).theType == Type.INT){
            TextCode.add(
               "\%t" + varCount + 
               " = load i32, i32* \%t" + 
               buf.get(i).theVar.varIndex + 
               ", align 4"

            );
            ins = ins + " ,i32 \%t"+varCount;
            varCount++;
         }
      }
   TextCode.add(ins+")");
   fstrCount++;
   varCount++;
   }
   ;
/* ==========printf========== */

/* ==========condition stmt========== */
   condition @init{int mainL = labelCount; labelCount++;}:

   a = if_then_stmt{
         TextCode.add("br label \%L"+mainL);
         TextCode.add("");
         TextCode.add($a.Label_f+":");
   } 
   (b = elseif_stmt{
         TextCode.add("br label \%L"+mainL);
         TextCode.add("");
         TextCode.add($b.Label_f+":");
      }
   )* 
   else_stmt
	{
      TextCode.add("br label \%L"+mainL);
      TextCode.add("");
      TextCode.add("L"+mainL+":");
      
   }
   ;

   if_then_stmt returns[String Label_f] @init{Label_f="";}: 
      IF '(' a =cond_expression ')' 
      {
         String Label_t = newLabel();
         labelCount ++;
         $Label_f = newLabel();
         labelCount ++;
         TextCode.add("br i1 \%t"+$a.theInfo.theVar.varIndex+", label \%" + Label_t+ ", label \%" + $Label_f);
         TextCode.add("");
         TextCode.add(Label_t + ":");
      }
      block_stmt;

   elseif_stmt returns[String Label_f]:
      ELSE  a=if_then_stmt{
         $Label_f = $a.Label_f;
      };
   else_stmt: 
      ELSE block_stmt | ;
/* ==========condition stmt========== */

/* ==========return========== */
returnstmt:
   'return' (
      Identifier{
         Info id = symtab.get($Identifier.text);
         if (id.theType == Type.INT){
            TextCode.add("ret i32 \%t"+id.theVar.varIndex);
         }
      }
   |  Integer_constant{
         TextCode.add("ret i32 "+$Integer_constant.text);
      }
   );