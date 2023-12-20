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

public enum WallpaperType: String, Codable {
    case scene, web, application, video, mixed
}

/// Types that being used for passing through informations for being rendered & displaying.
public enum Passthrough {
    public struct Wallpaper {
        var title: String
        var preview: String?
        var type: WallpaperType
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
public enum Storage { }

public protocol Wallpaper: ObservableObject {
//    var wallpaper: Passthrough.Wallpaper { get }
    
    var bundleURL: URL! { get }
    
//    init(fileURL: URL)
    
    init(contentsOf bundleURL: URL) throws
    
    func saveProperties() throws
}

public final class AnyWallpaper: Wallpaper {
    public var bundleURL: URL!
    
    public init(contentsOf bundleURL: URL) throws {
        
    }
    
    public func saveProperties() throws {
        
    }
    
    
}

public final class VideoWallpaper: Wallpaper {
    public let bundleURL: URL!
    
    private var cancellable = Set<AnyCancellable>()
    
    private var jsonEncoder = JSONEncoder()
    
    public func saveProperties() throws {
        if isBundled {
            let saveData = try jsonEncoder.encode(self.legacyProject)
            try saveData.write(to: bundleURL.appending(path: "project.json"), options: .atomic)
        } else {
            throw WPKError.notBundled
        }
    }
    
    public var legacyProject: Storage.WPEngineProject {
        if let currentData = try? Data(contentsOf: bundleURL.appending(path: "project.json")),
           var project = try? JSONDecoder().decode(Storage.WPEngineProject.self, from: currentData) {
            project.title = self.title
            project.file = self.file
            return project
        } else {
            return .init(file: self.file, title: self.title, type: "video")
        }
    }
    
//    @Published public private(set) var wallpaper: Passthrough.Wallpaper
    
    // MARK: Wallpaper Properties
    // Each one has its own publisher.
    @Published public var title: String
    @Published public var file: String
    @Published public var tags = [String]()
    
    @Published public var speed = 1.0
    @Published public var volume = 1.0
    @Published public var size = 1.0
    
    public var isBundled: Bool {
        self.bundleURL != nil
    }
    
    public lazy var player = AVPlayer()
    
    public init(contentsOf bundleURL: URL) throws {
        jsonEncoder.outputFormatting = .prettyPrinted
        
        self.bundleURL = bundleURL
        
        let projectData = try Data(contentsOf: bundleURL.appending(path: "project.json"))
        let project = try JSONDecoder().decode(Storage.WPEngineProject.self, from: projectData)
        
        self.title = project.title
        self.file = project.file
        
        $file.sink { [weak self] newFile in
            if let file = self?.file,
               let bundleURL = self?.bundleURL {
                let newPlayerItem = AVPlayerItem(url: bundleURL.appending(path: file))
                self?.player.replaceCurrentItem(with: newPlayerItem)
            }
        }.store(in: &cancellable)
        
        $volume.sink { [weak self] newVolume in
            self?.player.volume = Float(newVolume)
        }.store(in: &cancellable)
        
        $speed.sink { [weak self] newSpeed in
            self?.player.rate = Float(newSpeed)
        }.store(in: &cancellable)
    }
    
//    public init(fileURL: URL) {
//
//    }
}

public struct WPKProjectAuthor: Codable {
    var name: String
    var avator: String?
    var description: String?
}

enum WPKError: Error {
    case wrongType, notBundled
}
