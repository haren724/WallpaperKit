//
//  OpenGLTests.swift
//
//
//  Created by Haren on 2024/3/5.
//

import XCTest
@testable import WallpaperKit

// MARK: - OpenGL Relative
import Cglfw
import Cglew

// Working with vectors and matrices
//import simd

import GLKit
// MARK: -

final class OpenGLTests: XCTestCase, NSApplicationDelegate {
    func createShaderProgram() -> GLuint {
        let VertexShaderID = glCreateShader(GLenum(GL_VERTEX_SHADER))
        let FragmentShaderID = glCreateShader(GLenum(GL_FRAGMENT_SHADER))
        
        let vshaderString = """
        #version 330 core
        
        // Input vertex data, different for all executions of this shader.
        layout(location = 0) in vec3 vertexPosition_modelspace;
        
        void main() {
            gl_Position.xyz = vertexPosition_modelspace;
            gl_Position.w = 1.0;
        }
        """
        let vshaderPointer = UnsafeMutablePointer<GLchar>.allocate(capacity: vshaderString.count + 1)
        vshaderPointer.initialize(from: vshaderString, count: vshaderString.count + 1)
        var VertexShaderPointer = UnsafePointer?(vshaderPointer)
        
        let fshaderString = """
        #version 330 core
        
        // Ouput data
        out vec3 color;
        
        void main(void)
        { color = vec3(1.0, 1.0, 0.0); }
        """
        let fshaderPointer = UnsafeMutablePointer<GLchar>.allocate(capacity: fshaderString.count + 1)
        fshaderPointer.initialize(from: fshaderString, count: fshaderString.count + 1)
        var FragmentShaderPointer = UnsafePointer?(fshaderPointer)
        
        var Result: GLint = GL_FALSE
        var InfoLogLength: GLint = 0
        
        glShaderSource(VertexShaderID, 1, &VertexShaderPointer, nil)
        glCompileShader(VertexShaderID)
        
        glGetShaderiv(VertexShaderID, GLenum(GL_COMPILE_STATUS), &Result)
        glGetShaderiv(VertexShaderID, GLenum(GL_INFO_LOG_LENGTH), &InfoLogLength)
        
        glShaderSource(FragmentShaderID, 1, &FragmentShaderPointer, nil)
        glCompileShader(FragmentShaderID)
        
        glGetShaderiv(FragmentShaderID, GLenum(GL_COMPILE_STATUS), &Result)
        glGetShaderiv(FragmentShaderID, GLenum(GL_INFO_LOG_LENGTH), &InfoLogLength)
        
        let ProgramID = glCreateProgram()
        glAttachShader(ProgramID, VertexShaderID)
        glAttachShader(ProgramID, FragmentShaderID)
        glLinkProgram(ProgramID)
        
        glGetProgramiv(ProgramID, GLenum(GL_LINK_STATUS), &Result)
        glGetProgramiv(ProgramID, GLenum(GL_INFO_LOG_LENGTH), &InfoLogLength)
        
        glDetachShader(ProgramID, VertexShaderID)
        glDetachShader(ProgramID, FragmentShaderID)
        
        glDeleteShader(VertexShaderID)
        glDeleteShader(FragmentShaderID)
        
        return ProgramID
    }
    
    func testSingleDot() throws {
        glfwInit()
        
        glfwWindowHint(GLFW_SAMPLES, 4)
        glfwWindowHint(GLFW_CONTEXT_VERSION_MAJOR, 3)
        glfwWindowHint(GLFW_CONTEXT_VERSION_MINOR, 3)
        glfwWindowHint(GLFW_OPENGL_FORWARD_COMPAT, GL_TRUE) // To make macOS happy; should not be needed
        glfwWindowHint(GLFW_OPENGL_PROFILE, GLFW_OPENGL_CORE_PROFILE)
        
        glfwWindowHint(GLFW_DECORATED, GL_FALSE)
        
        let window = glfwCreateWindow(1024, 768, "Tutorial 2", nil, nil)
        glfwMakeContextCurrent(window)
        
        glewExperimental = GLboolean(1)
        
        glewInit()
        
        glfwSetInputMode(window, GLFW_STICKY_KEYS, GL_TRUE)
        
        glClearColor(1.0, 0.0, 0.0, 0.0)
        
        var VertexArrayID: GLuint = 0
        glGenVertexArrays(1, &VertexArrayID)
        glBindVertexArray(VertexArrayID)
        
        let programID = createShaderProgram()
        
        var g_vertex_buffer_data: [GLfloat] = [
            -1.0, -1.0, 0.0,
             1.0, -1.0, 0.0,
             0.0,  1.0, 0.0,
        ]
        
        var vertexbuffer: GLuint = 0
        glGenBuffers(1, &vertexbuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexbuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<GLfloat>.size * g_vertex_buffer_data.count, &g_vertex_buffer_data, GLenum(GL_STATIC_DRAW))
        
        repeat {
            glClear(GLbitfield(GL_COLOR_BUFFER_BIT))
            
            glUseProgram(programID)
            
            glEnableVertexAttribArray(0)
         // {
                glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexbuffer)
                glVertexAttribPointer(0, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, UnsafeRawPointer(bitPattern: 0))
                
                glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
         // }
            glDisableVertexAttribArray(0)
            
            glfwSwapBuffers(window)
            glfwPollEvents()
        } while glfwGetKey(window, GLFW_KEY_ESCAPE) != GLFW_PRESS && glfwWindowShouldClose(window) == 0
        
        glDeleteBuffers(1, &vertexbuffer)
        glDeleteVertexArrays(1, &VertexArrayID)
        glDeleteProgram(programID)
        
        glfwTerminate()
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        let window = NSWindow(contentRect: NSRect(x: 0, y: 0, width: 400, height: 300), 
                              styleMask: [.closable, .miniaturizable, .titled],
                              backing: .buffered,
                              defer: true)
        
        window.title = "OpenGL Tests"
        
        window.contentView = NSOpenGLView(frame: NSRect(x: 0, y: 0, width: 400, height: 300),
                                          pixelFormat: nil)
        
        window.makeKeyAndOrderFront(self)
    }
    
    func testTutorial_3() throws {
        NSApplication.shared.delegate = self
        NSApp.run()
    }
}


