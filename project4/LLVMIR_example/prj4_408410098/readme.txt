執行環境:
    Ubuntu20.04 (Win10 wsl2)
    java:   openjdk 11.0.13
    llvm:   llvm-10
            clang:  10.0.0-4ubuntu1 
                    Target: x86_64-pc-linux-gnu 
                    Thread model: posix
    gcc:    9.4.0

編譯相關依賴:
    antlr-3.5.2-complete-no-st3.jar
    (已經放在資料夾底下了)

如何編譯:
    1. 使用資料夾裡面的makefile
        make 
    2. 
        java -jar ./antlr-3.5.2-complete-no-st3.jar myCompiler.g
	    javac -cp ./antlr-3.5.2-complete-no-st3.jar:. myCompiler_test.java

    清除編譯出來的檔案: make clean

如何執行:
    產稱.ll檔案:
        java -cp ./antlr-3.5.2-complete-no-st3.jar:. myCompiler_test test.c > test.ll
    
    產生執行檔:
    	llc test.ll
	    gcc -no-pie test.s -o test.exe

    ** 我的llvm 的llc 的命令是 llc-10 
        (我使用symbolic link, 所以makefile裡面的llc 指令即為 llc)
    
    ** 要請查看local 端的llc 指令來判斷是否要修改 makefile

    makefile有提供3隻測試程式產生.ll檔
    以及產生執行檔的指令:
        make test1ll: 產生test1.ll
        make test1comp: 產生test1.ll , test1.s, test1.exe
        make test1demo: 在終端機印出原本.ll檔的內容
                        (**不會產生.ll 檔)

        test2.c test3.c以此類推。

    執行:
        ./test.exe


testfile 特色:
    test1.c:    
        if 巢狀結構

    test2.c: 
        printf 4 個參數，單個if ，if else-if 沒有else
    
    test3.c: 
        +-*/% () 四則運算


    