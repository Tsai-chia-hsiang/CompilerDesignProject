all:
	java -cp ./antlr-3.5.2-complete-no-st3.jar org.antlr.Tool mylexer.g
	javac -cp ./antlr-3.5.2-complete-no-st3.jar:. testLexer.java mylexer.java

test1:
	java -cp ./antlr-3.5.2-complete-no-st3.jar:. testLexer test1.c

test2:
	java -cp ./antlr-3.5.2-complete-no-st3.jar:. testLexer test2.c

test3:
	java -cp ./antlr-3.5.2-complete-no-st3.jar:. testLexer test3.c

clean:
	rm *.class
	rm mylexer.java
	rm *.tokens