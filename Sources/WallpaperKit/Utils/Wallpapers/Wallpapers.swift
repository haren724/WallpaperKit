//
//  Wallpapers.swift
//
//
//  Created by Haren on 2024/2/28.
//

import Foundation

/// Obserable object which contains a wallpaper model and its publisher
/// - Important: The property `wallpaper` must be wrapped with `@Published`,
///  or the object will be unable to publish changes in `wallpaper`.
public protocol ObserableWallpaperWrapper: ObservableObject {
    var wallpaper: Models.Wallpaper { get }
}

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

/// Add implements for bundled wallpaper objects to suppport
/// initializing with a single wallpaper object.
public protocol SingleWallpaperCompatible {
    associatedtype S: SingleWallpaper
    
    init(createAt url: URL, with wallpaper: S) throws
}

/// Add default initializer for ``SingleWallpaperCompatible`` protocol
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
