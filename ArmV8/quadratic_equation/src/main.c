#include <stdio.h>

extern double discriminant (double a , double b , double c );
extern int quadraticFormula (double a , double b , double c , double *x1 , double *x2 ) ;

int main() {
    double a, b, c, x1, x2;
    //printf("Enter a, b, c: \n");
    scanf("%lf %lf %lf", &a, &b, &c);

    printf("Entrada:\n%.2lf %.2lf %.2lf\n\n", a, b, c);

    int number_roots = quadraticFormula(a, b, c, &x1, &x2);

    if(number_roots == 0){
        printf("Saída:\n Two equal real roots:\n x1 = %.2lf\n x2 = %.2lf\n", x1, x2);
    }else if (number_roots < 0){
        printf("Saída:\nNone real roots\n");
    }else{
        printf("Saída:\nTwo real roots:\n x1 = %.2lf \n x2 = %.2lf\n", x1, x2);
    }
}
