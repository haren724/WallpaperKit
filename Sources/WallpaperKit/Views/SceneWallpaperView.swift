//
//  SceneWallpaperView.swift
//
//
//  Created by Haren on 2024/3/9.
//

import Cocoa
import SwiftUI

public let attributes: [NSOpenGLPixelFormatAttribute] = [
    .init(NSOpenGLPFAOpenGLProfile),    .init(NSOpenGLProfileVersion3_2Core),
    .init(NSOpenGLPFAColorSize),        .init(24),
    .init(NSOpenGLPFAAlphaSize),        .init(8),
    .init(NSOpenGLPFADoubleBuffer),
    .init(NSOpenGLPFAAccelerated),
    .init(NSOpenGLPFANoRecovery),
    .init(0),
]

struct SceneWallpaperView: View {
    
    init(packageURL pkgURL: URL) throws {
        self.packageData = Data()
    }
    
    @State private var packageData: Data
    
    var body: some View {
        Text("Hello, world!")
    }
}

struct SceneWallpaperViewWrapper: NSViewRepresentable {
    func makeNSView(context: Context) -> NSSceneWallpaperView {
        NSSceneWallpaperView()
    }
    
    func updateNSView(_ nsView: NSSceneWallpaperView, context: Context) {
        
    }
}

class NSSceneWallpaperView: NSOpenGLView {
    
    override func prepareOpenGL() {
        
    }
    
    override func draw(_ dirtyRect: NSRect) {
        
    }
}
