//
//  WPEngineWallpaper.swift
//
//
//  Created by Haren on 2023/10/12.
//

import Foundation

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

public extension WPKEngineProject {
    struct PropertyOption: Codable {
        public var label: String
        public var value: String
    }
}

public extension WPKEngineProject {
    struct Property: Codable {
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
}

public extension WPKEngineProject {
    struct Properties: Codable {
        public var schemecolor: Property?
    }
}

public extension WPKEngineProject {
    struct General: Codable {
        public var properties: Properties
    }
}

public extension WPKEngineProject {
    enum WorkshopId: Codable {
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
