//
//  WPEngineWallpaper.swift
//
//
//  Created by Haren on 2023/10/12.
//

import Foundation

public extension Storage {
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
