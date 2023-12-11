/******************************************************************************

Welcome to GDB Online.
GDB online is an online compiler and debugger tool for C, C++, Python, Java, PHP, Ruby, Perl,
C#, OCaml, VB, Swift, Pascal, Fortran, Haskell, Objective-C, Assembly, HTML, CSS, JS, SQLite, Prolog.
Code, Compile, Run and Debug online from anywhere in world.

*******************************************************************************/
#include <stdio.h>

int main()
{
    int    X=0;
    int A=0;
    int B=1;
    while ( X < 5)
    {
        if (X > 3) {
            B = X + A;
        }
        else if (X == 3){
            A = X;
            B = A ;
        }
        else {
            A = X + B;
        }
        B += B*A;
        X = X + 1;
    }
    
    printf("A= %x B= %x X= %x", A, B, X);
}
