執行環境:
    Ubuntu20.04 (Win10 wsl2)
    java:　openjdk 11.0.13

編譯相關依賴:
    antlr-3.5.2-complete-no-st3.jar
    ** 編譯時若使用資料夾下的makefile，請將此檔案跟source code 放於「同一資料夾」下

如何編譯:
    1. 使用資料夾裡面的makefile
        make 
        清除編譯出來的檔案: make clean

    2. 下命令: 
        java -cp path_of_antlr-3.5.2-complete-no-st3.jar org.antlr.Tool myparser.g
	    javac -cp path_of_antlr-3.5.2-complete-no-st3.jar:. *.java
        編譯出來的檔案:
            *.class *.tokens myparserLexer.java myparserParser.java

如何執行:
    java -cp ./antlr-3.5.2-complete-no-st3.jar:. testParser test_C_file

    資料夾裡面有附上test1.c test2.c test3.c 測試檔案，可使用makefile來執行:
    make test1
    make test2
    make test3