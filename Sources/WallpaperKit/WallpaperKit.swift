// The Swift Programming Language
// https://docs.swift.org/swift-book

import AVFoundation

#if os(macOS)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

import SwiftUI

///
public protocol WPKWallpaper {
    associatedtype Project: WPKProject
    
    var project: Project { get }
}

extension WPKWallpaper {
    func write(to url: URL, options: Data.WritingOptions = []) throws {
        do {
            let projectData = try JSONEncoder().encode(project)
            try projectData.write(to: url, options: options)
            if project is WPKEngineProjectCompatible {
                
            }
        } catch {
            throw error
        }
    }
}

///
public protocol WPKProject: Codable {
    
}

/// A protocol that indicate that a project model that conforms to this protocol supports converting itself to a stuff of Wallpaper Engine©.
public protocol WPKEngineProjectCompatible {
    
    /// Converted title.
    var legacyTitle: String { get }
    
    /// Converted description.
    var legacyDescription: String? { get }
    
    /// Converted version.
    var legacyVersion: Int? { get }
    
    /// Converted wallpaper type.
    var legacyType: WPKWallpaperEngineType { get }
    
    /// Converted preview image's filename
    var legacyPreview: String { get }
}

/// A type for wallpapers defined in this Framework.
public enum WPKWallpaperType: String, Codable {
    
    /// Wallpapers that represents a photo on the desktop.
    case photo
    
    /// Wallpapers that represents a video on the desktop.
    case video
    
    /// Wallpapers that represents a website on the desktop.
    case web
    
    /// Wallpapers that represents advanced, mixed scenes on the desktop.
    case mixed
}

/// A type for wallpapers in Wallpaper Engine©.
public enum WPKWallpaperEngineType: String, Codable {
    
    /// Wallpapers in Wallpaper Engine© that represents a image on the desktop
    case image
    
    /// Wallpapers in Wallpaper Engine© that represents a photo on the desktop
    case video
    
    /// Wallpapers in Wallpaper Engine© that represents a website on the desktop
    case web
    
    /// Wallpapers in Wallpaper Engine© that represents a scene composed with OpenGL shaders on the desktop
    case scene
    
    /// Wallpapers in Wallpaper Engine© that represents a executable/application on the desktop
    case application
}

/// A JSON model representing project config of Wallpaper Engine©.
public struct WPKEngineProject: Codable {
    
    /// Title property in project.json
    public var title: String
    
    /// Title property in project.json
    public var preview: String
    
    /// Title property in project.json
    public var type: WPKWallpaperEngineType
    
    /// Title property in project.json
    public var file: String
    
    /// Title property in project.json
    public var approved: Bool?
    
    /// Title property in project.json
    public var contentrating: String?
    
    /// Title property in project.json
    public var description: String?
    
    /// Title property in project.json
    public var general: General?
    
    /// Title property in project.json
    public var tags: [String]?
    
    /// Title property in project.json
    public var visibility: String?
    
    /// Title property in project.json
    public var workshopid: WorkshopId?
    
    /// Title property in project.json
    public var workshopurl: String?
    
    /// Title property in project.json
    public var version: Int?
    
    /// Convert a WallpaperKit project model into Wallpaper Engine© one
    public init(_ project: some WPKEngineProjectCompatible) {
        self.title = project.legacyTitle
        self.preview = project.legacyPreview
        self.type = project.legacyType
        self.file = project.legacyDescription!
    }
}

public protocol WPKResource {
    associatedtype Project: WPKResourceProject
    
    /// A model representation of this object', which usually been used for JSON encoding / decoding
    var project: Project { get }
}

public protocol WPKResourceProject: Codable {
    
}

public struct WPKPhotoResourceProject: WPKResourceProject {
    var photos: [Photo]
    
    public struct Photo: Codable {
        var name: String
        var md5: String
    }
}

public struct WPKVideoResourceProject: WPKResourceProject {
    var videos: [Video]
    
    public struct Video: Codable {
        var name: String
        var md5: String
    }
}

public struct WPKMixedResourceProject: WPKResourceProject {
    
}

/// A unified file resources for photo type wallpapers
public struct WPKPhotoResource: WPKResource {
    var photos: [FileWrapper]
    
    /// A model representation of this object', which usually been used for JSON encoding / decoding
    public var project: WPKPhotoResourceProject
}

/// A unified file resources for video type wallpapers
public struct WPKVideoResource: WPKResource {
    var videos: [FileWrapper]
    
    public var project: WPKVideoResourceProject
}

/// A unified file resources for mixed type wallpapers
public struct WPKMixedResource: WPKResource {
    public var project: WPKMixedResourceProject { .init() }
}

/// A wrapper for a WallpaperKit wallpaper that you use to be compatible with Wallpaper Engine©
public protocol WPKLegacyWallpaperRepresenable: WPKWallpaper where Project: WPKEngineProjectCompatible {
    var projectLegacy: WPKEngineProject { get }
}

public struct WPKPhotoWallpaper: WPKLegacyWallpaperRepresenable {
    private(set) public var project: WPKPhotoWallpaperProject
    public var projectLegacy: WPKEngineProject { WPKEngineProject(project) }
    
    init() {
        self.project = Project()
    }
}

/// A wallpaper that represents a photo on the desktop.
public struct WPKPhotoWallpaperProject: WPKProject, WPKEngineProjectCompatible {
    
    public var title: String = ""
    public var preview: String = ""
    public var desceiption: String?
    
    /// Preview property for project convention
    public var legacyPreview: String { preview }
    
    public var legacyTitle: String { title }
    
    public var legacyDescription: String? { desceiption }
    
    public var legacyVersion: Int? { 0 }
    
    public var legacyType: WPKWallpaperEngineType { .image }
}

public struct WPKVideoWallpaper: WPKWallpaper {
    private(set) public var project: WPKVideoWallpaperProject
}

public struct WPKVideoWallpaperProject: WPKProject {
    
}

public struct WPKMixedWallpaper: WPKWallpaper {
    private(set) public var project: WPKMixedWallpaperProject
}

public struct WPKMixedWallpaperProject: WPKProject {
    
}

public struct WPKProjectAuthor: Codable {
    
}

public protocol WPKResourcea {
    func addResource(_ data: Data, with name: String) throws
    func removeResource(_ name: String) throws
}

struct WPEngineProject {
    var approved: Bool?
    var contentrating: String?
    var description: String?
    var file: String
    var general: WEProjectGeneral?
    var preview: String?
    var tags: [String]?
    var title: String
    var visibility: String?
    var workshopid: WorkshopId?
    var workshopurl: String?
    var type: String
    var version: Int?
}

enum WPKError: Error {
    case wrongType
}

struct WEProjectPropertyOption: Codable, Equatable, Hashable {
    var label: String
    var value: String
}

struct WEProjectProperty: Codable, Equatable, Hashable {
    // optional
    var condition: String?
    var index: Int?
    var options: [WEProjectPropertyOption]?
    var order: Int?
    
    // must have
    var text: String
    var type: String
    var value: String
}

struct WEProjectProperties: Codable, Equatable, Hashable {
    var schemecolor: WEProjectProperty?
}

struct WEProjectGeneral: Codable, Equatable, Hashable {
    var properties: WEProjectProperties
}

enum WorkshopId: Codable, Equatable, Hashable, RawRepresentable {
    case int(Int)
    case string(String)
    
    var rawValue: String {
        switch self {
        case .int(let x):
            return String(x)
        case .string(let x):
            return x
        }
    }
    
    init?(rawValue: String) {
        guard rawValue.allSatisfy({ $0.isASCII && $0.isNumber }) else { return nil }
        self = .string(rawValue)
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if let x = try? container.decode(Int.self) {
            self = .int(x)
            return
        }
        if let x = try? container.decode(String.self) {
            self = .string(x)
            return
        }
        throw DecodingError.typeMismatch(Self.self, DecodingError.Context(codingPath: decoder.codingPath,
                                                                          debugDescription: "Wrong type for Workshop ID"))
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .int(let x):
            try container.encode(x)
        case .string(let x):
            try container.encode(x)
        }
    }
}

//struct WEWallpaper: Codable, RawRepresentable, Identifiable {
//
//    var id: Int { self.project.hashValue }
//    var rawValue: String {
//        do {
//            let rawValueData = try JSONEncoder().encode(self)
//            return String(data: rawValueData, encoding: .utf8)!
//        } catch {
//            print(error)
//            return ""
//        }
//    }
//
//    var wallpaperDirectory: URL
//    var project: WPEngineProject
//
//    var wallpaperSize: Int {
//        guard let sizeBytes = try? self.wallpaperDirectory.directoryTotalAllocatedSize(includingSubfolders: true)
//        else { return 0 }
//        return sizeBytes
//    }
//
//    init(using project: WPEngineProject, where url: URL) {
//        self.wallpaperDirectory = url
//        self.project = project
//    }
//
//    enum CodingKeys: CodingKey {
//        case wallpaperDirectory
//        case project
//        // <all the other elements too>
//    }
//
//    init(from decoder: Decoder) throws {
//        let container = try decoder.container(keyedBy: CodingKeys.self)
//        self.wallpaperDirectory = try container.decode(URL.self, forKey: .wallpaperDirectory)
//        self.project = try container.decode(WPEngineProject.self, forKey: .project)
//        // <and so on>
//    }
//
//    func encode(to encoder: Encoder) throws {
//        var container = encoder.container(keyedBy: CodingKeys.self)
//        try container.encode(wallpaperDirectory, forKey: .wallpaperDirectory)
//        try container.encode(project, forKey: .project)
//        // <and so on>
//    }
//
//    init?(rawValue: String) {
//        if let rawValueData = rawValue.data(using: .utf8),
//           let wallpaper = try? JSONDecoder().decode(WEWallpaper.self, from: rawValueData) {
//            self = wallpaper
//        } else {
//            return nil
//        }
//    }
//}

enum WEWallpaperSortingMethod: String, CaseIterable, Identifiable {
    
    var id: Self { self }
    
    case name = "Name"
    case rating = "Rating"
    //    case favorite = "Favorite"
    case fileSize = "File Size"
    //    case subDate = "Subscription Date"
    //    case lastUpdated = "Last Updated"
}

enum WEWallpaperSortingSequence: Int {
    case decrease = 0, increase = 1
}

enum WEInitError: Error {
    enum WEJSONProjectInitError: Error {
        case notFound, corrupted, mismatched, unkownError
    }
    
    enum WEResourcesInitError: Error {
        case notFound, mismatchedFormat, corrupted, unkownError
    }
    
    enum WEPreviewInitError: Error {
        case notFound, notImage, unkownError
    }
    
    case badDirectoryPath
    case JSONProject(was: WEJSONProjectInitError)
    case resources(was: WEResourcesInitError)
    case preview(was: WEPreviewInitError)
}

extension URL {
    /// check if the URL is a directory and if it is reachable
    func isDirectoryAndReachable() throws -> Bool {
        guard try resourceValues(forKeys: [.isDirectoryKey]).isDirectory == true else {
            return false
        }
        return try checkResourceIsReachable()
    }
    
    /// returns total allocated size of a the directory including its subFolders or not
    func directoryTotalAllocatedSize(includingSubfolders: Bool = false) throws -> Int? {
        guard try isDirectoryAndReachable() else { return nil }
        if includingSubfolders {
            guard
                let urls = FileManager.default.enumerator(at: self, includingPropertiesForKeys: nil)?.allObjects as? [URL] else { return nil }
            return try urls.lazy.reduce(0) {
                (try $1.resourceValues(forKeys: [.totalFileAllocatedSizeKey]).totalFileAllocatedSize ?? 0) + $0
            }
        }
        return try FileManager.default.contentsOfDirectory(at: self, includingPropertiesForKeys: nil).lazy.reduce(0) {
            (try $1.resourceValues(forKeys: [.totalFileAllocatedSizeKey])
                .totalFileAllocatedSize ?? 0) + $0
        }
    }
}
