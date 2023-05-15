all:
	java -cp ./antlr-3.5.2-complete-no-st3.jar org.antlr.Tool myInterp.g
	javac -cp ./antlr-3.5.2-complete-no-st3.jar:. *.java

clean:
	rm -f *.class *.tokens myInterpLexer.java myInterpParser.java

test1:
	@java -cp ./antlr-3.5.2-complete-no-st3.jar:. myInterp_test test1.c

test2:
	@java -cp ./antlr-3.5.2-complete-no-st3.jar:. myInterp_test test2.c

test3:
	@java -cp ./antlr-3.5.2-complete-no-st3.jar:. myInterp_test test3.c

