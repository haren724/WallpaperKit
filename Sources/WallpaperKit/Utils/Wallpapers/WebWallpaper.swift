//
//  WebWallpaper.swift
//
//
//  Created by Haren on 2024/1/17.
//

import Combine
import Foundation

public final class WebWallpaper: Wallpaper {
    
    @Published public var wallpaper: Models.Wallpaper
    
    public init?(contentsOf url: URL) {
        nil
    }
    
    public init(createAt url: URL, with wallpaper: Models.Wallpaper) throws {
        throw WPKError.notBundled
    }
}
