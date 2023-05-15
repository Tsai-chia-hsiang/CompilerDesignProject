Compiler design Project 1 ReadMe file
Lexical Analyzer 
本次project 我是使用java來完成
執行:

1. 執行環境:
    OS : Ubuntu20.04 (win10 WSL2 版)
    Java : openjdk 11.0.13
    
2. 執行相關依賴:
    antlr: antlr-3.5.2-complete-no-st3.jar
    **要將該檔案與其他source code 放置於
    「同一個」資料夾底下進行編譯

3. 如何編譯:
    **要將antlr-3.5.2-complete-no-st3.jar
      與其他source code 放置於同一個資料夾下。
    
    使用目錄下的makefile:
        $make 

    或是自己下命令:
        $java -cp ./antlr-3.5.2-complete-no-st3.jar org.antlr.Tool mylexer.g
	    $javac -cp ./antlr-3.5.2-complete-no-st3.jar:. testLexer.java mylexer.java
        
4. 執行測試程式:
    執行: 
        $java -cp ./antlr-3.5.2-complete-no-st3.jar:. testLexer testfile
    
    **若要執行資料夾內的測試.c檔案
      test1.c test2.c test3.c，也可以透過目錄下的
      makefile 使用以下指令:
            分析test1.c 結果 : $make test1
            分析test2.c 結果 : $make test2
            分析test3.c 結果 : $make test3

    清除編譯出來的檔案:
        make clean

5. 執行:
    執行的輸出是testLexer.java 的stdout
    ( System.out.println() )
    ，每一行的格式為:
    Token: tokentype_ID lexeme
    ex: Token: 25 200.0
    
    至於tokentype_id的對應，
    則是在編譯出來的mylexer.token檔案裡面。

    test1.c 特色: 
        註解 ,if ,else ,else if, for, const
    test2.c 特色:
        char ,string ,[](陣列的運算子)
    test3.c 特色:
        long, long long , long int,
        long long int, struct,取值運算(.運算子)  




subset description :
    mylexer.g :

    在這個.g 檔裡面，我定義了許多c檔案的基本關鍵字，包含:
        

    (1)keywords: 
	    return ,
        const ,
        main (main 函式),
        struct ,
        tydefine

    (2) 控制結構 :
        迴圈:
	        while ,
            for ,
            break ,
            continue 
        條件:
            if ,
            else if ,
            else ,

    (3) 資料型態:
        int , long (long int),  long long (long long int),
        char , void , float ,double 

    (4) 運算子:
        =, == ,  < ,  > , <=,  >=,
        + ,  -,  * ,  /,  +=,  -=,  /=,  *= ,
        && , != ,  || ,  & ,   |,  . (struct 的取值運算)
        
    (5) 符號: 
        ,   :   ;   {   }  [  ]  (  )

    (6) 註解 : 
        //(單行註解) 
 	    /**/(多行註解)
        
    (7) header:
        #include...\n  (type: LIB)
	
    (8) constant value: 
        decimal number,
        floating point,
        char ('(.)?'),
        string (“.”)
        
    (9) Identity (ID)

    (10)WS : ' ' , '\r',  ‘\t’
    
    (11)NEW_LINE : ‘\n’ 



使用這之.g 檔分析的.c程式碼在分辨ID這類token的時候，目前沒有
辦法把他更進一步區分出這個token 是variable 還是 function，
僅列成 ID 這個type(例如 test2.c 裡面的 printfloat() function)
至於main 我則直接把他列為一個類別 (MAIN token)，
所以執行時，最好只有包含一個main 函式的檔案較好。
目前還有一個缺點，是user 自定義的type 也會被歸類為ID type(例如test3.c 裡面的struct u)。

不過在聽過第四章(syntax analysis)後，我想上述這兩個問題或許要交給
syntax analysis來做更進一步的區分會較合適。