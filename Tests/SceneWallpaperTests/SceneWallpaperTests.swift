//
//  SceneWallpaperTests.swift
//
//
//  Created by Haren on 2024/2/29.
//

import XCTest
import Common
@testable import WallpaperKit

import AVFoundation

import GLFWBridge
import Cglfw
import Cglew

final class SceneWallpaperTests: XCTestCase, WallpaperTestable {
    
    var files = [PkgHeader]()
    
    var dataPartFirstIndex: Int!
    
    var pkgURL: URL!
    
    var pkgData: Data!
    
    func testPkgFileLocating() throws {
        pkgURL = try XCTUnwrap(Bundle.module.url(forResource: "scene", withExtension: "pkg"))
        print("Found scene.pkg!")
        
        pkgData = try Data(contentsOf: pkgURL)
        print("Loaded scene.pkg!")
    }
    
    func testPkgHeaderParsing() throws {
        try testPkgFileLocating()
        
        var i: UInt32 = 0x10

        for _ in 0x10...UInt32.max {
            let strFirstIndex = i + 4
            
            let length = pkgData[i..<strFirstIndex].withUnsafeBytes {
                $0.loadUnaligned(as: UInt32.self)
            }
            
            if !files.isEmpty {
                guard let maxHeader = files.max(by: { $0.dataLastIndex < $1.dataLastIndex }) else { break }
                let dataPartFirstIndexMaybe = UInt32(pkgData.count) - maxHeader.dataLastIndex
                guard i + length < dataPartFirstIndexMaybe else {
                    dataPartFirstIndex = Int(dataPartFirstIndexMaybe)
                    break
                }
            }
            
            let strLastIndex = strFirstIndex + length
            
            guard let filePath = String(data: pkgData[strFirstIndex..<strLastIndex], encoding: .utf8) else { break }
            
            print("URL found: \(filePath)")
            
            let dataIndexFirstIndex = strLastIndex
            let dataIndexLastIndex = dataIndexFirstIndex + 4
            
            let dataFirstIndex = pkgData[dataIndexFirstIndex..<dataIndexLastIndex].withUnsafeBytes {
                $0.loadUnaligned(as: UInt32.self)
            }
            
            let dataOffsetFirstIndex = dataIndexLastIndex
            let dataOffsetLastIndex = dataOffsetFirstIndex + 4
            
            let dataOffset = pkgData[dataOffsetFirstIndex..<dataOffsetLastIndex].withUnsafeBytes {
                $0.loadUnaligned(as: UInt32.self)
            }
            
            files.append(PkgHeader(filePath: filePath, dataFirstIndex: dataFirstIndex, dataOffset: dataOffset))
            
            i = dataOffsetLastIndex
        }
    }
    
    func testUnpackAllJSONFile() throws {
        try testPkgHeaderParsing()
        
        let jsonFiles = try XCTUnwrap(files.filter { file in
            file.filePath.suffix(5) == ".json"
        })
        
        try jsonFiles.forEach { file in
            try print(XCTUnwrap(String(data: pkgData[UInt32(dataPartFirstIndex)+file.dataFirstIndex
                                                                                ..<
                                                          UInt32(dataPartFirstIndex)+file.dataLastIndex],
                                       encoding: .utf8)))
        }
    }
    
    func testPlayBackgroundSound() async throws {
        try testUnpackAllJSONFile()
        
        let audioFile = try XCTUnwrap(files.first { file in
            file.filePath.suffix(4) == ".mp3"
        })
        
        print("Audio file \"\(audioFile.filePath)\" found.")
        
        let player = try AVAudioPlayer(data: pkgData[UInt32(dataPartFirstIndex)+audioFile.dataFirstIndex
                                                                        ..<
                                             UInt32(dataPartFirstIndex)+audioFile.dataLastIndex])
        
        XCTAssert(player.play())
        try await Task.sleep(for: .seconds(5))
        player.stop()
    }
    
    func testGLFWBridge() throws {
        glfw_test_start()
    }
    
    func testGLFW() throws {
        var vertexBuffer: GLuint = 0
        var vertexShader: GLuint = 0
        var fragmentShader: GLuint = 0
        var program: GLuint = 0
        
        var mvpLocation: GLint = 0
        var vposLocation: GLint = 0
        var vcolLocation: GLint = 0
        
        let __vertexShaderText = """
        #version 110
        uniform mat4 MVP;
        attribute vec3 vCol;
        attribute vec2 vPos;
        varying vec3 color;
        void main()
        {
            gl_Position = MVP * vec4(vPos, 0.0, 1.0);
            color = vCol;
        }
        """
        let _vertexShaderText = UnsafeMutablePointer<GLchar>.allocate(capacity: __vertexShaderText.count + 1)
        _vertexShaderText.initialize(from: __vertexShaderText, count: __vertexShaderText.count + 1)
        
        var vertexShaderText = UnsafePointer<GLchar>?(_vertexShaderText)
        
        let __fragmentShaderText = """
        #version 110
        varying vec3 color;
        void main()
        {
            gl_FragColor = vec4(color, 1.0);
        }
        """
        let _fragmentShaderText = UnsafeMutablePointer<GLchar>.allocate(capacity: __fragmentShaderText.count + 1)
        _vertexShaderText.initialize(from: __fragmentShaderText, count: __fragmentShaderText.count + 1)
        
        var fragmentShaderText = UnsafePointer<GLchar>?(_fragmentShaderText)
        
        var vertices = UnsafeMutablePointer<Vertice>.allocate(capacity: 3)
        vertices[0] = Vertice(x: -0.6, y: -0.4, r: 1, g: 0, b: 0)
        vertices[1] = Vertice(x: 0.6, y: -0.4, r: 0, g: 1, b: 0)
        vertices[2] = Vertice(x: 0, y: 0.6, r: 0, g: 0, b: 1)
        
        glfwInit()
        
        glfwWindowHint(GLFW_DECORATED, GLFW_FALSE); // Collapse the window title bar
        
        guard let window = glfwCreateWindow(800, 600, "fjsdkjf", nil, nil)
        else {
            glfwTerminate()
            XCTFail("Createing window failed!")
            return
        }
        
        glfwMakeContextCurrent(window)
        
        glGenBuffers(1, &vertexBuffer)
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout.size(ofValue: vertices), vertices, GLenum(GL_STATIC_DRAW))
        
        vertexShader = glCreateShader(GLenum(GL_VERTEX_SHADER))
        glShaderSource(vertexShader, 1, &vertexShaderText, nil)
        glCompileShader(vertexShader)
        
        fragmentShader = glCreateShader(GLenum(GL_FRAGMENT_SHADER))
        glShaderSource(fragmentShader, 1, &fragmentShaderText, nil)
        glCompileShader(fragmentShader)
        
        program = glCreateProgram()
        glAttachShader(program, vertexShader)
        glAttachShader(program, fragmentShader)
        glLinkProgram(program)
        
        mvpLocation = glGetUniformLocation(program, "MVP")
        vposLocation = glGetAttribLocation(program, "vPos")
        vcolLocation = glGetAttribLocation(program, "vCol")
        
        
        
        var a: Int = 0
        
        glEnableVertexAttribArray(GLuint(vposLocation))
        glVertexAttribPointer(GLuint(vposLocation), 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE),
                              GLsizei(MemoryLayout.size(ofValue: vertices[0])), UnsafeRawPointer(bitPattern: 0))
        glEnableVertexAttribArray(GLuint(vcolLocation))
        glVertexAttribPointer(GLuint(vcolLocation), 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE),
                              GLsizei(MemoryLayout.size(ofValue: vertices[0])), UnsafeRawPointer(bitPattern: MemoryLayout.size(ofValue: Float.self) * 2))
        
        while glfwWindowShouldClose(window) == 0 {
            var ratio: Float = 0
            var width: Int32 = 0
            var height: Int32 = 0
            
//            mat4
            
            glfwGetFramebufferSize(window, &width, &height)
            
            glViewport(0, 0, width, height)
            
            glClear(GLbitfield(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT))
            
            glUseProgram(program)
//            glUniformMatrix4fv(mvpLocation, 1, GLboolean(GL_FALSE), <#T##value: UnsafePointer<GLfloat>!##UnsafePointer<GLfloat>!#>)
            
            glfwSwapBuffers(window)
            
            glfwPollEvents()
        }
        
        _vertexShaderText.deallocate()
        vertexShaderText?.deallocate()
        
        _fragmentShaderText.deallocate()
        fragmentShaderText?.deallocate()
        
        glfwTerminate()
    }
    
    func testPlaygroundGLES() {
        let g_vertex_buffer_data: [GLfloat] = [
            -1.0, -1.0,  0.0,
             1.0, -1.0,  0.0,
             0.0,  1.0,  0.0
        ]
        
        var vertexBuffer: GLuint = 0
        
        glfwInit()
        
        glewInit()
        
        guard let window = glfwCreateWindow(800, 600, "Triangle", nil, nil)
        else {
            glfwTerminate()
            XCTFail("Createing window failed!")
            return
        }
        
        glGenBuffers(1, &vertexBuffer)
        
        glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
        
        glBufferData(GLenum(GL_ARRAY_BUFFER), MemoryLayout<GLuint>.size, g_vertex_buffer_data, GLenum(GL_STATIC_DRAW))
        
        // OpenGL ES RunLoop
        while glfwWindowShouldClose(window) == 0 {
            glEnableVertexAttribArray(0)
            
            glBindBuffer(GLenum(GL_ARRAY_BUFFER), vertexBuffer)
            
            var bufferOffset: GLint = 0
            
            glVertexAttribPointer(0, 3, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, &bufferOffset)
            
            glDrawArrays(GLenum(GL_TRIANGLES), 0, 3)
            
            glDisableVertexAttribArray(0)
            
            glfwSwapBuffers(window)
            
            glfwPollEvents()
        }
        
        glfwTerminate()
    }
    
    func testImportModel() throws {
        
    }
}

extension SceneWallpaperTests {
    struct PkgHeader {
        var filePath: String
        var dataFirstIndex: UInt32
        var dataOffset: UInt32
        var dataLastIndex: UInt32 {
            dataFirstIndex + dataOffset
        }
    }
}

extension SceneWallpaperTests {
    struct Vertice {
        var x: Float
        var y: Float
        
        var r: Float
        var g: Float
        var b: Float
    }
}
