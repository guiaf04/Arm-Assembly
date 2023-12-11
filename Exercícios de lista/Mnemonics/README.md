Escrever o código abaixo em assembly ARM, em duas versões:

a Sem mnemônicos de condição;
b Com mnemônicos de condição

```c
X = 0
A = 0
B = 1
while ( X < 5)
{
if (X > 3) {
B = X + A;
}
else if (X == 3){
B = A = X;
}
else {
A = X + B;
}
B += B*A;
X = X + 1;
}
```