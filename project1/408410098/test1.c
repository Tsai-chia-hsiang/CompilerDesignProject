#include<stdio.h>

const float pi = 3.14;

int main(){

    // this is one line comments test

    /*
    This is muti-lines
    comments, done..
    */
    int test0 = 3;
    int test1 = 2;
    float p = 3.0;
    float l = 5.0/2.0;

    int times = 10;
    for(int i = 0;i< times; i++){
        if(i % 2 == 0){
            test1 * test0;
            continue;
        }
        else{
            p *= 2;
        }
        if( i > 200.00){
            break;
        }
    }
    return 0;
}