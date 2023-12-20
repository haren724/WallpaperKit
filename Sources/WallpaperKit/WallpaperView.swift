//
//  WallpaperView.swift
//
//
//  Created by Haren on 2023/10/30.
//

import SwiftUI
import AVKit

//@available(iOS 16.0, macOS 13.0, *)
//public struct WallpaperView: View {
//    
//    @ObservedObject private var wallpaper: _WPKWallpaper
//    
//    public var body: some View {
//        switch wallpaper.type {
//        case .photo:
//            Image(nsImage: NSImage(contentsOf: <#T##URL#>))
//        case .video:
//            break
//        default:
//            EmptyWallpaperView()
//        }
//    }
//}

public struct VideoWallpaperView: View {
    
    @ObservedObject private var videoWallpaper: VideoWallpaper
    
    @State private var player: AVPlayer?
    
    init(_ videoWallpaper: VideoWallpaper) {
        self.videoWallpaper = videoWallpaper
        if let url = URL(string: videoWallpaper.wallpaper.file) {
            self.player = AVPlayer(url: url)
        }
    }
    
    public var body: some View {
        VideoPlayer(player: player)
    }
}

@available(iOS 16.0, macOS 13.0, *)
struct EmptyWallpaperView: View {
    
    var body: some View {
        Image(systemName: "rectangle.slash")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

//#Preview {
//    WallpaperView(wallpaper: .constant(WPKPhotoWallpaper()))
//                .frame(width: 320, height: 180)
//                .border(Color.primary)
//}

// Thoughts:
// 1. Read project.json file to load struct model
// - If the `type` key in it has conflicted with the resource files
//   this directory have, then the initializer will throw an error.
// 2.


public struct _WPKTestWallpaper {
    public var type: WPKWallpaperType
}

// Usage: MyTextView("aBÇ😄¿sakldjgkdfsgkldfs")
struct MyTextView: View {
    
    var str: String
    
    init(_ str: String) {
        self.str = str
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(str.enumerated().map { $0.element }, id: \.hashValue) { char in
                Text(String(char))
                    .frame(width: 20, height: 10)
            }
        }
    }
}

#Preview {
    MyTextView("aBÇ😄¿sakldjgkdfsgkldfs")
        .frame(width: 1000, height: 100)
}
