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
    
    public var baseURL: URL
    
    public var isBundled: Bool
    
    public init?(contentsOf url: URL) {
        self.wallpaper = .init(project: .init(title: "", type: .application, file: ""), file: .init(name: "", hashValue: nil))
        self.baseURL = URL(filePath: "")
        self.isBundled = true
    }
    
    public init(createAt url: URL, with wallpaper: Models.Wallpaper) throws {
        throw WPKError.notBundled
    }
}
