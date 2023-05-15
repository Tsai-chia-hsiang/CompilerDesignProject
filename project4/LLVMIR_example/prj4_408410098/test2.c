int main(){

    int p = 98,q = 12 ;
    int r = 0;
    r = p%q;
    int s = 36;
    printf("s=%d. OK, The remain of %d / %d is %d: \n",s,p,q,r);

    if (r == 1){
        printf("one\n");
    }
    else if(r == 3){
        printf("three\n");
    }
    else if (r == 4){
        printf("four\n");
    }
    else if(r == 2){
        printf("two\n");
    }

    int l = -100;
    if (l == 0){
        printf("%d is false\n",l);
    }

    int k = 0;
    if (k != 0){
        printf("K is ture");
    }
    else{
        printf("K is false");
    }

    return 0;
}