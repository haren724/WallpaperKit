//
//  PhotoWallpaper.swift
//  
//
//  Created by Haren on 2023/11/10.
//

import AVFoundation

#if os(macOS)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

import SwiftUI

public final class WPKPhotoWallpaperManager: WPKWallpaperManager {
    @Published public var wallpaper: WPKPhotoWallpaper
    
    func resetAll() {
        
    }
    
    func addPhoto(_ photo: CGImage) throws {
        wallpaper.resource.photos.append(FileWrapper(regularFileWithContents: photo.dataProvider!.data! as Data))
    }
    
    func showPhoto(_ name: String) {
        
    }
    
    func rescale(to ratio: Double) {
        
    }
    
    init(wallpaper: WPKPhotoWallpaper) {
        self.wallpaper = wallpaper
    }
}

/// A unified file resources for photo type wallpapers
public struct WPKPhotoResource: WPKResource {
    var photos: [FileWrapper]
    
    /// A model representation of this object', which usually been used for JSON encoding / decoding
    public var project: WPKPhotoResourceProject
}

public struct WPKPhotoWallpaper: WPKLegacyWallpaperRepresenable {
    
    public static let empty = WPKPhotoWallpaper()
    
    public var project: WPKPhotoWallpaperProject
    public var projectLegacy: WPKEngineProject { WPKEngineProject(project) }
    
    public var resource: WPKPhotoResource
    
    init() {
        self.project = Project.empty
        self.resource = WPKPhotoResource(photos: [], project: WPKPhotoResourceProject(photos: []))
    }
    
    public func rescale(to ratio: Double) -> Self {
        self
    }
}

/// A wallpaper that represents a photo on the desktop.
public struct WPKPhotoWallpaperProject: WPKProject, WPKEngineProjectCompatible {
    
    public static let empty = WPKPhotoWallpaperProject(title: "Empty Wallpaper",
                                                       preview: nil,
                                                       desceiption: "This is a demo wallpaper project",
                                                       photos: [])
    
    public var title: String
    public var preview: ResourceFile?
    public var desceiption: String?
    
    public var photos: [ResourceFile]
    
    /// Preview property for project convention
    public var legacyPreview: String { preview?.name ?? "" }
    
    public var legacyTitle: String { title }
    
    public var legacyDescription: String? { desceiption }
    
    public var legacyVersion: Int? { 0 }
    
    public var legacyType: WPKWallpaperEngineType { .image }
}
