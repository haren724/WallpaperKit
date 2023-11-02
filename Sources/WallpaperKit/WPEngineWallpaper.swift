//
//  WPEngineWallpaper.swift
//
//
//  Created by Haren on 2023/10/12.
//

import Foundation

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
