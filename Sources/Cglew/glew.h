//
//  Header.h
//  
//
//  Created by Haren on 2024/3/5.
//

#ifndef Header_h
#define Header_h

#define GLEW_NO_GLU

#include <GL/glew.h>

#include <stdio.h>

void printArray(float *array, int length) {
    for (int i = 0; i < length; ++i) {
        printf("%f, ", array[i]);
    }
}

#endif /* Header_h */
