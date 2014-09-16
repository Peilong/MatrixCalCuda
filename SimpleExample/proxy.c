
#include <stdio.h>
#include "Main.h"

JNIEXPORT jint JNICALL Java_Main_CUDAProxy_1matrixAdd(JNIEnv *env, jobject obj, jfloatArray aArray, jfloatArray bArray, jfloatArray cArray)
{
    printf("C: fetching arrays from Java\n");
    jfloat *a = (*env)->GetFloatArrayElements(env, aArray, 0);
    jfloat *b = (*env)->GetFloatArrayElements(env, bArray, 0);
    jfloat *c = (*env)->GetFloatArrayElements(env, cArray, 0);
    printf("C: Got reference to all a, b, and c\n");
    jsize N = (*env)->GetArrayLength(env, aArray);
    printf("C: calling CUDA kernel\n");
    cuda_matrixAdd(a, b, c, N);
    printf("C: back from CUDA kernel, coping data to Java\n");
    (*env)->ReleaseFloatArrayElements(env, aArray, a, 0);
    (*env)->ReleaseFloatArrayElements(env, bArray, b, 0);
    (*env)->ReleaseFloatArrayElements(env, cArray, c, 0);
    printf("C: Going back to Java\n");
    return (jint) N; // this might not be the right way to return values to Java
}
