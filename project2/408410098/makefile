all:
	java -cp ./antlr-3.5.2-complete-no-st3.jar org.antlr.Tool myparser.g
	javac -cp ./antlr-3.5.2-complete-no-st3.jar:. *.java

test1:
	@java -cp ./antlr-3.5.2-complete-no-st3.jar:. testParser test1.c
test2:
	@java -cp ./antlr-3.5.2-complete-no-st3.jar:. testParser test2.c
test3: 
	@java -cp ./antlr-3.5.2-complete-no-st3.jar:. testParser test3.c		

clean:
	rm *.class *.tokens myparserLexer.java myparserParser.java