執行環境:
    Ubuntu20.04 (Win10 wsl2)
    java:　openjdk 11.0.13

編譯相關依賴:
    antlr-3.5.2-complete-no-st3.jar
    (已經放在資料夾底下了)

如何編譯:
    1. 使用資料夾裡面的makefile
        make 
        清除編譯出來的檔案: make clean

    2. 下命令: 
        java -cp path_of_antlr-3.5.2-complete-no-st3.jar org.antlr.Tool myInterp.g
	    javac -cp path_of_antlr-3.5.2-complete-no-st3.jar:. *.java
        編譯出來的檔案:
            *.class *.tokens myparserLexer.java myparserParser.java

如何執行:
    java -cp ./antlr-3.5.2-complete-no-st3.jar:. myInterp_test test_C_file.c

    資料夾裡面有附上test1.c test2.c test3.c 測試檔案，可使用makefile來執行:
    make test1 
        (features: declaration, assignment )
    make test2 
        (features: if-elseif-else, boolean expression)
    make test3 
        (features: printf(), scanf())

程式特色:
    本程式只支援 int 型態
    可parsing 並直譯: 
        宣告(初始化 or not皆可)
        賦值     
        if elseif else結構(包含所需的boolean expression)
        printf
        scanf(parsing 到scanf 之時，會在stdin 等待輸入)

    輸出:
    ====== Statement Start =======
    [statement type]
    印出parsing到的statement 的值 (sacnf 則只有單純讀輸入)
    ====== Statement end =========
