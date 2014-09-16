
// includes, system
#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include <math.h>

// includes, project
//#include <cutil_inline.h>
#include <helper_cuda.h>

// includes, kernels
//#include <matrixAdd_kernel.cu>
#ifndef _MATRIXADD_KERNEL_H_
#define _MATRIXADD_KERNEL_H_

#include <stdio.h>

#define SDATA( index)      cutilBankChecker(sdata, index)

////////////////////////////////////////////////////////////////////////////////
//! Simple test kernel for device functionality
//! @param g_idata  input data in global memory
//! @param g_odata  output data in global memory
////////////////////////////////////////////////////////////////////////////////
// Kernel that executes on the CUDA device
#ifdef __cplusplus
extern "C"
{
#endif
    
__global__ void add_matrix(float *a, float *b, float *c, int N)
{
    int idx = blockIdx.x * blockDim.x + threadIdx.x;
    if (idx < N) c[idx] = a[idx] + b[idx];

}
#ifdef __cplusplus
}
#endif 
#endif // #ifndef _MATRIXADD_KERNEL_H_
////////////////////////////////////////////////////////////////////////////////
// declaration, forward
/*
 * void runTest( int argc, char** argv);
 *
 * extern "C"
 * void computeGold( float* reference, float* idata, const unsigned int len);
 */
////////////////////////////////////////////////////////////////////////////////
// Program main
////////////////////////////////////////////////////////////////////////////////

#ifdef __cplusplus
extern "C"
{
#endif

// CUDA code here

int cuda_matrixAdd(float *a_h, float *b_h, float *c_h, int N)
/*
int main(int argc, char* argv)
 */
{
    float *a_d, *b_d, *c_d;
    //const int N = 10;
   
        size_t size = N * sizeof (float);
         /*
        // allocate memory in the host for array a
        a_h = (float *) malloc(size);
        // allocate memory in the host for array b
        b_h = (float *) malloc(size);
        // allocate memory in the host for array c
        c_h = (float *) malloc(size);
        // initialize the arrays a and b
        for (int i = 0; i < N; i++)
        {
            printf("i = %d |\n", i);
            a_h[i] = (float) i;
            printf("a_h[%d] = %f\n", i, a_h[i]);
            b_h[i] = (float) i;
        }
        printf("\nA:");
        for (int i = 0; i < N; i++) printf("%5.2f|", a_h[i]);
        printf("\nB:");
        for (int i = 0; i < N; i++) printf("%5.2f|", b_h[i]);
        printf("\n");
     */
    // allocate memory in the GPU device for a, b and c
    cudaMalloc((void **) & a_d, size);
    cudaMalloc((void **) & b_d, size);
    cudaMalloc((void **) & c_d, size);
    // copy from host to GPU device
    cudaMemcpy(a_d, a_h, size, cudaMemcpyHostToDevice);
    cudaMemcpy(b_d, b_h, size, cudaMemcpyHostToDevice);
    // do calculations on device
    int block_size = 4;
    int n_blocks = N / block_size + (N % block_size == 0 ? 0 : 1);
    add_matrix <<<n_blocks, block_size >>>(a_d, b_d, c_d, N);
    // Retrieve results from the device
    cudaMemcpy(c_h, c_d, size, cudaMemcpyDeviceToHost);
    // print out the results
    printf("CU: c[]:");
    for (int i = 0; i < N; i++) printf("%5.2f|", c_h[i]);
    printf("\n");
    /*
        // Cleanup
        free(a_h);
        free(b_h);
        free(c_h);
     */
    cudaFree(a_d);
    cudaFree(b_d);
    cudaFree(c_d);
    return N;
}


#ifdef __cplusplus
}
#endif 
