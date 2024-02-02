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
/// A protocol that all bundled wallpapers conform to.
///
/// Please aware this protocol is reference type only, to know more about the
/// differences between ``Wallpaper`` and ``Models.Wallpaper``, see [Basics](Basics.md)
///
/// If you just want to load single file as wallpaper, see ``SingleWallpaper``.
///
/// - Important: You may not implement your custom wallpaper type
///   conforming to this protocol. When you pass your custom wallpaper
///     type into `WallpaperPlayer`, you'll get a blank page.
///
public protocol Wallpaper: ObserableWallpaperWrapper {
    
    var baseURL: URL { get }
    
    var isBundled: Bool { get }
    
    /// Creates a wallpaper from a local location.
    init?(contentsOf url: URL)
    
    init(createAt url: URL, with wallpaper: Models.Wallpaper) throws
    
}

public protocol ObserableWallpaperWrapper: ObservableObject {
    var wallpaper: Models.Wallpaper { get }
}

public protocol SingleWallpaperCompatible {
    associatedtype S: SingleWallpaper
    
    init(createAt url: URL, with wallpaper: S) throws
}

// Default implementations
public extension SingleWallpaperCompatible {
    init(createAt url: URL, with wallpaper: S) throws {
        throw WPKError.unsupported
    }
}

/// For wallpapers which only have one resource file,
/// even with absence of project,json.
/// - Note: This protocol is typically designated  for single .mp4 or .pkg files.
///   if you want to load resource file that lies in folder with a project.json file,
///   please use ``Wallpaper`` instead.
public protocol SingleWallpaper: ObserableWallpaperWrapper {
    
    var fileURL: URL { get }
    
    init?(contentOf url: URL)
    
    init(createAt url: URL, with wallpaper: Models.Wallpaper) throws
}

/// Describes errors within the WallpaperKit error domain.
enum WPKError: Error {
    case wrongType, notBundled, unsupported
}
