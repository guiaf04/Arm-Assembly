#include <stdio.h>

// #define __aarch64__
#include "arm_neon.h"

int main() {
    int n;
    printf("Digite o número de alunos: ");
    scanf("%d", &n);

    float pesos[4] = {0.2, 0.3, 0.15, 0.35};
    float notas[n][4];
    float media[n];
 
    for(int i = 0; i < n; i++){
        printf("Digite as notas do aluno %d: ", i+1);
        for(int j = 0; j < 4; j++){
            scanf("%f", &notas[i][j]);
        }
    }

    float32x4_t neon_vector01 = vld1q_f32(pesos);
    float32x4_t neon_vector02;
    float32x4_t neon_vector_result;

    for(int i = 0; i < n; i++){
        neon_vector02 = vld1q_f32(notas[i]);
        neon_vector_result = vmulq_f32(neon_vector01, neon_vector02);
        media[i] = (vaddvq_f32(neon_vector_result));
    }

    for(int i = 0; i < n; i++){
        printf("A média do aluno %d é: %f\n", i+1, media[i]);
    }

    float32_t result = 0.0;

    for(int i = 0; i < n; i += 4){
        neon_vector02 = vld1q_f32(media + i);
        result += vaddvq_f32(neon_vector02);
    }
    result /= n;
    printf(" A média da turma é: %f\n", result);

    return 0;
}
