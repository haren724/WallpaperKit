//
//  WallpaperPlayer.swift
//
//
//  Created by Haren on 2024/2/7.
//

import SwiftUI

public struct WallpaperPlayer<W: Wallpaper>: View {
    
    @ObservedObject var wallpaper: W
    
    public init(wallpaper: W) {
        self.wallpaper = wallpaper
    }
    
    public var body: some View {
        if let wallpaper = wallpaper as? VideoWallpaper {
            VideoWallpaperView(wallpaper: wallpaper)
        } else if let wallpaper = wallpaper as? WebWallpaper {
            WebWallpaperView(wallpaper: wallpaper)
        } else {
            Text("Unsupported Wallpaper Type.")
        }
    }
}
