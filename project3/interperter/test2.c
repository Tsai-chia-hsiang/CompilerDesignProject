
void main(){
    int p = 3;
    int q = 3;
    int s = 10;
    
    if(p > 5){
        p = 2*p;
    }
    else if(p < q){
        p = p+q;
    }
    else if(p > q){
        q = q + p;
    }else{
        p = p*p;
    }

    if(p > s){
        p = p / 3;
    }else{
        p = p + s;
    }

    return ;
}