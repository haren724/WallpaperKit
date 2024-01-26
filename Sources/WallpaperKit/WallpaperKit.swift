// The Swift Programming Language
// https://docs.swift.org/swift-book

import AVFoundation

#if os(macOS)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

import SwiftUI
import Combine

import OSLog

let logger = Logger()

public enum WallpaperType: String, Codable {
    case scene, web, application, video, mixed
}

/// Types that being used for passing through informations for being rendered & displaying.
public enum Passthrough {
    public struct Wallpaper {
        var title: String
        var preview: String?
        var type: WallpaperType
        var author: String
        var tags: [String]
        var file: String
        
        var speed: Double
        var volume: Double
        
        var isBundled: Bool
        
        static let test = Wallpaper(title: "Test Wallpaper", 
                                    preview: nil, type: .video,
                                    author: "nobody",
                                    tags: ["test"],
                                    file: "",
                                    speed: 1.0,
                                    volume: 1.0,
                                    isBundled: false)
    }
}

/// Types that mostly conforms to Codable protocol to save models into local storage
public enum WallpaperEngine { }

///
/// A protocol that all reference type of wallpaper types conform.
///
/// - Important: You may not implement your custom wallpaper type
///   conforming to this protocol. When you pass your custom wallpaper
///     type into `WallpaperPlayer`, you'll get a blank page.
///
public protocol Wallpaper: ObservableObject {
    
    var wallpaper: Models.Wallpaper { get }
    
    /// Creates a wallpaper from a local location.
    init?(contentsOf url: URL)
    
    
    init(createAt url: URL, with wallpaper: Models.Wallpaper) throws
}

/// Describes errors within the WallpaperKit error domain.
enum WPKError: Error {
    case wrongType, notBundled
}
