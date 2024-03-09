//
//  GLFWBridge.h
//
//
//  Created by Haren on 2024/3/1.
//

#ifndef Header_h
#define Header_h

#include <iostream>

/* Disable the deprecated message */
#define GL_SILENCE_DEPRECATION

/* Ask for an OpenGL Core Context */
#define GLFW_INCLUDE_GLCOREARB
#include <GLFW/glfw3.h>

void glfw_test_start();

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

#endif /* Header_h */
