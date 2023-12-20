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

public protocol WPKWallpaperManager: ObservableObject {
    associatedtype Wallpaper: WPKWallpaper
    
    var wallpaper: Wallpaper { get set }
}

///
public protocol WPKWallpaper {
    associatedtype Project: WPKProject
    associatedtype V: View
    
    var project: Project { get }
    
    var view: V { get }
}

extension WPKWallpaper {
    /// Default implementation (an empty wallpaper view)
    public var view: some View { EmptyWallpaperView() }
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

public struct ResourceFile: Codable {
    var name: String
    var md5: String
}

//public struct WPKVideoWallpaper: WPKWallpaper {
//    private(set) public var project: WPKVideoWallpaperProject
//}


/// Types that being used for passing through informations for being rendered & displaying.
public enum Passthrough {
    public struct Wallpaper {
        var title: String
        var preview: String?
        var type: WPKWallpaperType
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
public enum Storage {
    public struct Project: Codable {
        
    }
    
    public struct WPEngineProject: Codable {
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
    
    public struct PropertyOption: Codable {
        public var label: String
        public var value: String
    }

    public struct Property: Codable {
        // optional
        public var condition: String?
        public var index: Int?
        public var options: [PropertyOption]?
        public var order: Int?
        
        // must have
        public var text: String
        public var type: String
        public var value: String
    }

    public struct Properties: Codable {
        public var schemecolor: Property?
    }

    public struct General: Codable {
        public var properties: Properties
    }

    public enum WorkshopId: Codable {
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
        
        public init(from decoder: Decoder) throws {
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
        
        public func encode(to encoder: Encoder) throws {
            var container = encoder.singleValueContainer()
            switch self {
            case .int(let x):
                try container.encode(x)
            case .string(let x):
                try container.encode(x)
            }
        }
    }

    public struct WEProjectPropertyOption: Codable, Equatable, Hashable {
        var label: String
        var value: String
    }

    public struct WEProjectProperty: Codable, Equatable, Hashable {
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

    public struct WEProjectProperties: Codable, Equatable, Hashable {
        var schemecolor: WEProjectProperty?
    }

    public struct WEProjectGeneral: Codable, Equatable, Hashable {
        var properties: WEProjectProperties
    }
}

public protocol Wallpaper: ObservableObject {
    var wallpaper: Passthrough.Wallpaper { get }
    
    var bundleURL: URL? { get }
    
    init(fileURL: URL)
    
    init(contentsOf: URL)
    
    func saveProperties() throws
}

public final class VideoWallpaper {
    public var bundleURL: URL?
    
    private var cancellable = Set<AnyCancellable>()
    
    public func saveProperties() throws {
        if isBundled {
            
        } else {
            throw WPKError.notBundled
        }
    }
    
//    @Published public private(set) var wallpaper: Passthrough.Wallpaper
    
    @Published public var title: String
    @Published public var file: String
    
    public private(set) var isBundled: Bool
    
    public var player: AVPlayer?
    
    public init(contentsOf bundleURL: URL) throws {
        self.bundleURL = bundleURL
        self.isBundled = true
        
        let projectData = try Data(contentsOf: bundleURL.appending(path: "project.json"))
        let project = try JSONDecoder().decode(Storage.WPEngineProject.self, from: projectData)
        
        self.title = project.title
        self.file = project.file
        
//        self.wallpaper = .test
//        self.wallpaper.isBundled = true
        
        
    }
    
    public init(fileURL: URL) {
//        self.wallpaper = .test
//        self.wallpaper.isBundled = false
        self.isBundled = false
    }
}

public struct WPKVideoWallpaperProject: WPKProject {
    
}

public struct WPKMixedWallpaper: WPKWallpaper {
    private(set) public var project: WPKMixedWallpaperProject
}

public struct WPKMixedWallpaperProject: WPKProject {
    
}

public struct WPKProjectAuthor: Codable {
    var name: String
    var avator: String?
    var description: String?
}

enum WPKError: Error {
    case wrongType, notBundled
}
