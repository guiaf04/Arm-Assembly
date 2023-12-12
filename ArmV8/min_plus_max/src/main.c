#include <stdio.h>

extern double min_array(double *array, int n);

extern double max_array(double *array, int n);

extern double min_plus_max(double *array, int n);

int main() {
    double array[] = {1, 2, 3, 4, 5};
    double min = min_array(array, 5);
    printf("Min of the Array: %lf\n", min);

    double max = max_array(array, 5);
    printf("Max of the Array: %lf\n", max);

    double sum = min_plus_max(array, 5);
    printf("Sum of the Array: %lf\n", sum);

    return 0;
}
