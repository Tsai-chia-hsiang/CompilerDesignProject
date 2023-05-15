; === prologue ====
@str7 = private unnamed_addr constant [11 x i8] c"K is false\00", align 1
@str6 = private unnamed_addr constant [10 x i8] c"K is ture\00", align 1
@str5 = private unnamed_addr constant [13 x i8] c"%d is false\0A\00", align 1
@str4 = private unnamed_addr constant [5 x i8] c"two\0A\00", align 1
@str3 = private unnamed_addr constant [6 x i8] c"four\0A\00", align 1
@str2 = private unnamed_addr constant [7 x i8] c"three\0A\00", align 1
@str1 = private unnamed_addr constant [5 x i8] c"one\0A\00", align 1
@str0 = private unnamed_addr constant [41 x i8] c"s=%d. OK, The remain of %d / %d is %d: \0A\00", align 1
declare dso_local i32 @printf(i8*, ...)

define dso_local i32 @main()
{
%t0 = alloca i32, align 4
store i32 0, i32* %t0, align 4
store i32 98, i32* %t0, align 4
%t1 = alloca i32, align 4
store i32 0, i32* %t1, align 4
store i32 12, i32* %t1, align 4
%t2 = alloca i32, align 4
store i32 0, i32* %t2, align 4
store i32 0, i32* %t2, align 4
%t3 = load i32, i32* %t0, align 4
%t4 = load i32, i32* %t1, align 4
%t5 = srem i32 %t3, %t4
store i32 %t5, i32* %t2
%t6 = alloca i32, align 4
store i32 0, i32* %t6, align 4
store i32 36, i32* %t6, align 4
%t7 = load i32, i32* %t6, align 4
%t8 = load i32, i32* %t0, align 4
%t9 = load i32, i32* %t1, align 4
%t10 = load i32, i32* %t2, align 4
%t11 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([41 x i8], [41 x i8]* @str0, i64 0, i64 0 ) ,i32 %t7 ,i32 %t8 ,i32 %t9 ,i32 %t10)
%t12 = load i32, i32* %t2, align 4
%t13 = icmp eq i32 %t12, 1
br i1 %t13, label %L1, label %L2

L1:
%t14 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str1, i64 0, i64 0 ))
br label %L0

L2:
%t15 = load i32, i32* %t2, align 4
%t16 = icmp eq i32 %t15, 3
br i1 %t16, label %L3, label %L4

L3:
%t17 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str2, i64 0, i64 0 ))
br label %L0

L4:
%t18 = load i32, i32* %t2, align 4
%t19 = icmp eq i32 %t18, 4
br i1 %t19, label %L5, label %L6

L5:
%t20 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @str3, i64 0, i64 0 ))
br label %L0

L6:
%t21 = load i32, i32* %t2, align 4
%t22 = icmp eq i32 %t21, 2
br i1 %t22, label %L7, label %L8

L7:
%t23 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str4, i64 0, i64 0 ))
br label %L0

L8:
br label %L0

L0:
%t24 = alloca i32, align 4
store i32 0, i32* %t24, align 4
%t25 = sub nsw i32 0, 100
store i32 %t25, i32* %t24, align 4
%t26 = load i32, i32* %t24, align 4
%t27 = icmp eq i32 %t26, 0
br i1 %t27, label %L10, label %L11

L10:
%t28 = load i32, i32* %t24, align 4
%t29 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([13 x i8], [13 x i8]* @str5, i64 0, i64 0 ) ,i32 %t28)
br label %L9

L11:
br label %L9

L9:
%t30 = alloca i32, align 4
store i32 0, i32* %t30, align 4
store i32 0, i32* %t30, align 4
%t31 = load i32, i32* %t30, align 4
%t32 = icmp ne i32 %t31, 0
br i1 %t32, label %L13, label %L14

L13:
%t33 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @str6, i64 0, i64 0 ))
br label %L12

L14:
%t34 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @str7, i64 0, i64 0 ))
br label %L12

L12:
ret i32 0

; === epilogue ===
ret i32 0
}
