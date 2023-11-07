//
//  WallpaperView.swift
//
//
//  Created by Haren on 2023/10/30.
//

import SwiftUI

///
//public protocol Wallpaper: View { }
//
//extension Wallpaper {
//    func
//}

@available(iOS 16.0, macOS 13.0, *)
public struct WallpaperView<Wallpaper>: View where Wallpaper: WPKWallpaper {
    
    @Binding private var wallpaper: Wallpaper
    
    public init(wallpaper: Binding<Wallpaper>) {
        self._wallpaper = wallpaper
    }
    
    public var body: some View {
        Text("\(try! String(data: JSONEncoder().encode(wallpaper.project), encoding: .utf8)!)")
    }
}

#Preview {
    WallpaperView(wallpaper: .constant(WPKPhotoWallpaper()))
}
