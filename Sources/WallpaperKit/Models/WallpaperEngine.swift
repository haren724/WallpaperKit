//
//  WPEngineWallpaper.swift
//
//
//  Created by Haren on 2023/10/12.
//

import Foundation

/// A namespace storing types that mostly conforms to
/// ``Codable`` protocol for model persistence
public enum WallpaperEngine { }

public extension WallpaperEngine {
    struct Project: Codable {
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
    
    struct PropertyOption: Codable {
        public var label: String
        public var value: String
    }

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

    struct Properties: Codable {
        public var schemecolor: Property?
    }

    struct General: Codable {
        public var properties: Properties
    }

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
}
