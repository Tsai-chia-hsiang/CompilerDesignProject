; === prologue ====
@str4 = private unnamed_addr constant [5 x i8] c"End\0A\00", align 1
@str3 = private unnamed_addr constant [8 x i8] c"q == p\0A\00", align 1
@str2 = private unnamed_addr constant [7 x i8] c"q < p\0A\00", align 1
@str1 = private unnamed_addr constant [8 x i8] c"q <= p\0A\00", align 1
@str0 = private unnamed_addr constant [22 x i8] c"2 int q = %d, p = %d\0A\00", align 1
declare dso_local i32 @printf(i8*, ...)

define dso_local i32 @main()
{
%t0 = alloca i32, align 4
store i32 0, i32* %t0, align 4
%t1 = alloca i32, align 4
store i32 0, i32* %t1, align 4
store i32 3, i32* %t1, align 4
%t2 = sub nsw i32 0, 5
%t3 = mul nsw i32 2, 3
%t4 = add nsw i32 %t2, %t3
store i32 %t4, i32* %t0
%t5 = load i32, i32* %t0, align 4
%t6 = load i32, i32* %t1, align 4
%t7 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([22 x i8], [22 x i8]* @str0, i64 0, i64 0 ) ,i32 %t5 ,i32 %t6)
%t8 = load i32, i32* %t0, align 4
%t9 = load i32, i32* %t1, align 4
%t10 = icmp sle i32 %t8, %t9
br i1 %t10, label %L1, label %L2

L1:
%t11 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str1, i64 0, i64 0 ))
%t12 = load i32, i32* %t0, align 4
%t13 = load i32, i32* %t1, align 4
%t14 = icmp slt i32 %t12, %t13
br i1 %t14, label %L4, label %L5

L4:
%t15 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @str2, i64 0, i64 0 ))
br label %L3

L5:
%t16 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([8 x i8], [8 x i8]* @str3, i64 0, i64 0 ))
br label %L3

L3:
br label %L0

L2:
br label %L0

L0:
%t17 = call i32 (i8*, ...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @str4, i64 0, i64 0 ))
ret i32 0

; === epilogue ===
ret i32 0
}
