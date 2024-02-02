//
//  WebWallpaperView.swift
//
//
//  Created by Haren on 2024/2/1.
//

import SwiftUI
import WebKit

public struct WebWallpaperView: View {
    
    @ObservedObject var wallpaper: WebWallpaper
    
    public var body: some View {
        WebView(wallpaper: wallpaper)
    }
    
    private struct WebView: NSViewRepresentable {
        
        @ObservedObject var wallpaper: WebWallpaper
        
        var url: URL? {
            nil
        }
        
        func makeNSView(context: Context) -> WKWebView {
            WKWebView(frame: .zero, configuration: WKWebViewConfiguration())
        }
        
        func updateNSView(_ nsView: WKWebView, context: Context) {
            guard let url = self.url else { return }
            
            nsView.load(URLRequest(url: url))
        }
    }
}
