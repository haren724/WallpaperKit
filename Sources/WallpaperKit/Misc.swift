//
//  Misc.swift
//
//
//  Created by Haren on 2023/11/18.
//

import Foundation

final class WPKBundle {
    init?(url: URL) {
        guard Self.isValidURL(url) else { return nil }
        self.directory = url
    }
    
    convenience init?(path: String) {
        guard let url = URL(string: path) else { return nil }
        self.init(url: url)
    }
    
    private(set) var directory: URL
    
    var wallpapers: [_WPKWallpaperModel] {
        let wrapper = try? FileWrapper(url: directory)
        wrapper?.fileWrappers
        
        return []
    }
    
    func remove(wallpaper: _WPKWallpaperModel) throws {
        
    }
    
    func add(wallpaper: _WPKWallpaperModel) throws {
        
    }
    
//    func find(title: String? = nil, author: String? = nil) throws -> [_WPKWallpaperModel] {
//        wallpapers
//            .filter { $0.title == title }
//            .filter { $0.author == author }
//    }
    
    private static func isValidURL(_ url: URL) -> Bool {
        false
    }
}

final class _WPKWallpaper: ObservableObject {
    
    var wallpaper: _WPKWallpaperModel? {
        nil
    }
    
    private(set) var directory: URL
    
    var type: WPType? {
        self.project?.type
    }
    
    var project: Project? {
        guard let data = FileManager.default.contents(atPath: directory.appending(path: "project.json")
            .path(percentEncoded: false))
        else { return nil }
        
        return nil
    }
    
    func setProject(to project: WPKProject) throws {
        try (try JSONEncoder().encode(project)).write(to: directory.appending(path: "project.json"))
    }
    
    /// Initializes a wallpaper instance.
    init(url: URL) {
        self.directory = url
    }
}

enum WPKLoadError: Error {
    case a
}

struct _WPKWallpaperModel {
    var title: String
    var author: String
}

struct _WPKProject<Resource> where Resource: WPKResource {
    var title: String
    var author: WPKProjectAuthor
    var type: WPKWallpaperType
    var resource: Resource
}

struct Project: Codable {
    var title: String
    var type: WPType
    var author: Author
    var version: String?
    var global: Properties?
    var resource: Resource
}

struct Author: Codable {
    var name: String
    var description: String?
    var gender: Gender?
    var website: URL?
}

enum Gender: String, Codable {
    case male, female, other
}

enum WPType: String, Codable {
    case photo, video, mixed
    case engineImage = "image"
    case engineWeb = "web"
    case engineScene = "scene"
}

struct Properties: Codable {
    var volume: Double?
    var ratio: Double?
    var speed: Double?
    var allowUnsafeContent: Bool?
}

struct Resource: Codable {
    var photo: [File]?
    var video: [File]?
    var website: [File]?
}

struct File: Codable {
    var name: String
    var md5: String
    var properties: Properties?
}
