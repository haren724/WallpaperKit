//
//  Models.swift
//
//
//  Created by Haren on 2023/12/28.
//

import Foundation

/// All models being used for passing through wallpaper data
public enum Models { }

public extension Models {
    struct Wallpaper: Equatable {
        
        internal var title: String
        
        internal var author: Author?
        
        internal var type: WallpaperType
        
        internal var file: File
        
        internal var config: Config
        
        internal var projectDescription: String?
        
        internal init(project: Project, config: Config? = nil, file: File) {
            self.title = project.title
            self.type = project.type
            self.projectDescription = project.description
            
            if let config = config {
                self.config = config
            } else {
                self.config = Config()
            }
            
            self.file = file
        }
    }
}

protocol WallpaperEngineModelCompatible {
    associatedtype M: Codable
    
    var compatibleModel: M { get }
}

extension Models.Wallpaper: WallpaperEngineModelCompatible {
    internal var compatibleModel: WallpaperEngine.Project {
        .init(file: "", title: "", type: "")
    }
}

extension Models.Wallpaper: CustomStringConvertible {
    public var description: String {
        "Hello, this wallpaper name is \(title)"
    }
}

public extension Models {
    struct Author: Codable, Equatable {
        internal var name: String
        internal var avator: String?
        internal var description: String?
    }
}

public extension Models {
    struct Project: Codable, Equatable {
        
        internal var approved: Bool?
        
        internal var contentrating: String?
        
        internal var description: String?
        
        internal var version: Int?
        
        internal var title: String
        
        internal var preview: String?
        
        internal var type: WallpaperType
        
//        internal var author: String?
        
        internal var tags: [String]?
        
        internal var file: String
    }
}

public extension Models {
    struct File: Equatable {
        internal let filename: String
        internal let hashValue: Int?
    }
}

public extension Models {
    struct Config: Codable, Equatable {
        internal var rate: Float = 1.0
        internal var volume: Float = 1.0
        internal var size: Float = 1.0
    }
}
