; === prologue ====
@str5 = private unnamed_addr constant [14 x i8] c"    div = %d\0A\00", align 1
@str4 = private unnamed_addr constant [23 x i8] c"    prodcuct sub = %d\0A\00", align 1
@str3 = private unnamed_addr constant [14 x i8] c"    add = %d\0A\00", align 1
@str2 = private unnamed_addr constant [18 x i8] c"    product = %d\0A\00", align 1
@str1 = private unnamed_addr constant [14 x i8] c"The answear:\0A\00", align 1
@str0 = private unnamed_addr constant [27 x i8] c"Args : a = %d, b = %d, ..\0A\00", align 1
declare dso_local i32 @printf(i8*, ...)

define dso_local i32 @main()
{
%t0 = alloca i32, align 4
store i32 0, i32* %t0, align 4
store i32 23, i32* %t0, align 4
%t1 = alloca i32, align 4
store i32 0, i32* %t1, align 4
store i32 19, i32* %t1
%t2 = alloca i32, align 4
store i32 0, i32* %t2, align 4
%t3 = load i32, i32* %t0, align 4
%t4 = load i32, i32* %t1, align 4
%t5 = mul nsw i32 %t3, %t4
store i32 %t5, i32* %t2, align 4
%t6 = alloca i32, align 4
store i32 0, i32* %t6, align 4
%t7 = load i32, i32* %t0, align 4
%t8 = load i32, i32* %t1, align 4
%t9 = add nsw i32 %t7, %t8
store i32 %t9, i32* %t6, align 4
%t10 = alloca i32, align 4
store i32 0, i32* %t10, align 4
%t11 = load i32, i32* %t0, align 4
%t12 = load i32, i32* %t0, align 4
%t13 = load i32, i32* %t1, align 4
%t14 = sub nsw i32 %t12, %t13
%t15 = mul nsw i32 %t11, %t14
store i32 %t15, i32* %t10, align 4
%t16 = alloca i32, align 4
store i32 0, i32* %t16, align 4
%t17 = load i32, i32* %t0, align 4
%t18 = load i32, i32* %t1, align 4
%t19 = sdiv i32 %t17, %t18
store i32 %t19, i32* %t16, align 4
%t20 = load i32, i32* %t0, align 4
%t21 = load i32, i32* %t1, align 4
%t22 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([27 x i8], [27 x i8]* @str0, i64 0, i64 0 ) ,i32 %t20 ,i32 %t21)
%t23 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str1, i64 0, i64 0 ))
%t24 = load i32, i32* %t2, align 4
%t25 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([18 x i8], [18 x i8]* @str2, i64 0, i64 0 ) ,i32 %t24)
%t26 = load i32, i32* %t6, align 4
%t27 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str3, i64 0, i64 0 ) ,i32 %t26)
%t28 = load i32, i32* %t10, align 4
%t29 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([23 x i8], [23 x i8]* @str4, i64 0, i64 0 ) ,i32 %t28)
%t30 = load i32, i32* %t16, align 4
%t31 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([14 x i8], [14 x i8]* @str5, i64 0, i64 0 ) ,i32 %t30)
ret i32 0

; === epilogue ===
ret i32 0
}
