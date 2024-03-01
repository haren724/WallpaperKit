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
            
            var strLastIndex = strFirstIndex + length
            
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
    
    func testGLFW() throws {
        glfw_start()
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
