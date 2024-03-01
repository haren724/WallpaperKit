//
//  SceneWallpaper.swift
//
//
//  Created by Haren on 2024/2/29.
//

import Foundation

final class SceneWallpaper: Wallpaper {
    var baseURL: URL
    
    var isBundled: Bool
    
    init?(contentsOf url: URL) {
        nil
    }
    
    init(createAt url: URL, with wallpaper: Models.Wallpaper) throws {
        throw WPKError.notBundled
    }
    
    @Published var wallpaper: Models.Wallpaper
    
    
}
