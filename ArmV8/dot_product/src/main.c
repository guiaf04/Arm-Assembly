#include <stdio.h>

// #define __aarch64__
#include "arm_neon.h"

int main() {
    float vector01[4] = {10, 20, 12.5, 50};
    float vector02[4] = {20.2, 4, 4, 7};

    float32x4_t neon_vector01 = vld1q_f32(vector01);
    float32x4_t neon_vector02 = vld1q_f32(vector02);
    float32x4_t neon_vector_result = vmulq_f32(neon_vector01, neon_vector02);
    float32_t result = vaddvq_f32(neon_vector_result);

    printf("%f\n", result);

    return 0;
}
