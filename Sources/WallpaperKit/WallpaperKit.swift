// The Swift Programming Language
// https://docs.swift.org/swift-book

import AVFoundation

import Cocoa
import SwiftUI

public protocol WPKWallpaper {
    associatedtype Project: WPKProject
    
    var project: Project { get }
}

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
    
    /// Wallpapers that represents advanced, mixed scenes on the desktop.
    case mixed
}

/// A type for wallpapers in Wallpaper Engine©.
public enum WPKWallpaperEngineType: String, Codable {
    
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
    
}

public struct WPKPhoto: WPKResource {
    
}

public protocol WPKLegacyProjectRepresenable: WPKWallpaper where Project: WPKEngineProjectCompatible {
    var projectLegacy: WPKEngineProject { get }
}

public struct WPKPhotoWallpaper: WPKLegacyProjectRepresenable {
    private(set) public var project: WPKPhotoWallpaperProject
    public var projectLegacy: WPKEngineProject { WPKEngineProject(project) }
    
    init() {
        self.project = Project()
    }
}

public struct WPKPhotoWallpaperProject: WPKProject, WPKEngineProjectCompatible {
    public var legacyPreview: String {
        ""
    }
    
    public var legacyTitle: String {
        ""
    }
    
    public var legacyDescription: String? {
        nil
    }
    
    public var legacyVersion: Int? {
        nil
    }
    
    public var legacyType: WPKWallpaperEngineType {
        .video
    }
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

//public protocol WPKProjecta: Codable where Resource: WPKResource {
//    associatedtype Resource
//    
//    var title: String { get set }
//    var author: WPKProjectAuthor { get set }
//    var type: `Type` { get set }
//    var version: Int { get set }
//    var resources: Resource { get set }
//    
//    // Optional
//    var tags: [String]? { get set }
//}
//
//public struct WPKPhotoProject: WPKProject {
//    public typealias Resource = <#type#>
//    
//    public var title: String
//    
//    public var author: WPKProjectAuthor
//    
//    public var type: WPKProject.`Type`
//    
//    public var version: Int
//    
//    public var tags: [String]?
//    
//    
//}

public struct WPKProjectAuthor: Codable {
    
}

//public struct WPKProjecta<Resource>: Codable where Resource: WPKResource {
//    // Must have
//    public var title: String
//    public var author: Author
//    public var type: `Type`
//    public var version: Int
//    public var resources: Resource
//    
//    // Optional
//    public var tags: [String]?
//}
//
//public protocol WPKResource: Codable { }
//
//public extension WPKProject {
//    struct Author: Codable {
//        public var name: String
//        public var link: String
//        public var description: String?
//    }
//}
//
//public extension WPKProject {
//    struct Property: Codable {
//        
//    }
//}
//
//public extension WPKProject {
//    enum `Type`: String, Codable {
//        case photo, video, mixed
//    }
//}


class WPKManager {
    init() async {
        
    }
}

public protocol WPKResourcea {
    func addResource(_ data: Data, with name: String) throws
    func removeResource(_ name: String) throws
}

/// Wallpaper Protocol
public protocol _WPKWallpaper where Resource: _WPKResource, Project: _WPKProject {
    associatedtype Resource
    associatedtype Project
    
    var resource: Resource { get }
    var project: Project { get }
}

/// Wallpaper Protocol
public protocol _WPKResource {
    func find() -> any StringProtocol
}

/// Wallpaper Protocol
public protocol _WPKProject: Codable, Equatable, Hashable {
    var title: String { get set }
    var preview: String? { get set }
    var type: String { get set }
    var tags: [String]? { get set }
}

struct WPEngineProject: _WPKProject {
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

protocol WPKWallpapera where Project: Codable, Flag: OptionSet {
    associatedtype Project
    associatedtype Flag
    
    var project: Project { get }
    
    init(contentOf url: URL, flags: Flag) throws
    
    func setSaveURL(_ url: URL)
    
    
}

extension WPKWallpapera {
    
}

struct Flag: OptionSet {
    var rawValue: Int
    
    static let overwrite: Self = Self.init(rawValue: 1 << 0)
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
        throw DecodingError.typeMismatch(Self.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for Workshop ID"))
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

struct WEWallpaper: Codable, RawRepresentable, Identifiable {
    
    var id: Int { self.project.hashValue }
    var rawValue: String {
        do {
            let rawValueData = try JSONEncoder().encode(self)
            return String(data: rawValueData, encoding: .utf8)!
        } catch {
            print(error)
            return ""
        }
    }
    
    var wallpaperDirectory: URL
    var project: WPEngineProject
    
    var wallpaperSize: Int {
        guard let sizeBytes = try? self.wallpaperDirectory.directoryTotalAllocatedSize(includingSubfolders: true)
        else { return 0 }
        return sizeBytes
    }
    
    init(using project: WPEngineProject, where url: URL) {
        self.wallpaperDirectory = url
        self.project = project
    }
    
    enum CodingKeys: CodingKey {
        case wallpaperDirectory
        case project
        // <all the other elements too>
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.wallpaperDirectory = try container.decode(URL.self, forKey: .wallpaperDirectory)
        self.project = try container.decode(WPEngineProject.self, forKey: .project)
        // <and so on>
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(wallpaperDirectory, forKey: .wallpaperDirectory)
        try container.encode(project, forKey: .project)
        // <and so on>
    }
    
    init?(rawValue: String) {
        if let rawValueData = rawValue.data(using: .utf8),
           let wallpaper = try? JSONDecoder().decode(WEWallpaper.self, from: rawValueData) {
            self = wallpaper
        } else {
            return nil
        }
    }
}

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
