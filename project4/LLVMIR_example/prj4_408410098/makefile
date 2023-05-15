all:
	java -jar ./antlr-3.5.2-complete-no-st3.jar myCompiler.g
	javac -cp ./antlr-3.5.2-complete-no-st3.jar:. myCompiler_test.java

test1demo:
	@java -cp ./antlr-3.5.2-complete-no-st3.jar:. myCompiler_test test1.c
test1ll:
	java -cp ./antlr-3.5.2-complete-no-st3.jar:. myCompiler_test test1.c > test1.ll
test1comp:
	java -cp ./antlr-3.5.2-complete-no-st3.jar:. myCompiler_test test1.c > test1.ll
	llc test1.ll
	gcc -no-pie test1.s -o test1.exe

test2demo:
	@java -cp ./antlr-3.5.2-complete-no-st3.jar:. myCompiler_test test2.c
test2ll:
	java -cp ./antlr-3.5.2-complete-no-st3.jar:. myCompiler_test test2.c > test2.ll
test2comp:
	java -cp ./antlr-3.5.2-complete-no-st3.jar:. myCompiler_test test2.c > test2.ll
	llc test2.ll
	gcc -no-pie test2.s -o test2.exe

test3demo:
	@java -cp ./antlr-3.5.2-complete-no-st3.jar:. myCompiler_test test3.c
test3ll:
	java -cp ./antlr-3.5.2-complete-no-st3.jar:. myCompiler_test test3.c > test3.ll
test3comp:
	java -cp ./antlr-3.5.2-complete-no-st3.jar:. myCompiler_test test3.c > test3.ll
	llc test3.ll
	gcc -no-pie test3.s -o test3.exe

clean:
	rm *.class myCompilerLexer.java myCompilerParser.java *.tokens *.s *.exe


