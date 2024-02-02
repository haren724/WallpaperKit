//
//  VideoWallpaper.swift
//
//
//  Created by Haren on 2023/11/10.
//

import AVKit
import Combine

public final class VideoWallpaper: Wallpaper {
    @Published public var wallpaper: Models.Wallpaper
    
//    @Published internal var __wallpaper: Models.Wallpaper
    
    public let baseURL: URL
    
    public let isBundled: Bool
    
    public var bundleURL: URL? { isBundled ? baseURL : nil }
    
    public var fileURL: URL? {
        let fileURL = baseURL.appending(path: wallpaper.file.name)
        if let fileData = try? Data(contentsOf: fileURL),
           fileData.hashValue == wallpaper.file.hashValue {
            return fileURL
        } else {
            logger.warning("File failed to load or hash value mismatched.")
            return nil
        }
    }
    
    // Cancellable subscriptions
    private var cancellable = Set<AnyCancellable>()
    
    func setFile(_ file: Models.File) {
        self.wallpaper.file = file
    }
    
    /// Video player for ``VideoWallpaperView``
    ///
    /// - Important: This AVPlayer class cannot be accessed by instances outside of this package
    internal var player: AVPlayer
    
    
    public init?(contentsOf baseURL: URL) {
        self.baseURL = baseURL
        
        guard let projectData = try? Data(contentsOf: baseURL.appending(component: "project.json")) else { return nil }
        guard let project = try? JSONDecoder().decode(Models.Project.self, from: projectData) else { return nil }
        
        let fileURL = baseURL.appending(path: project.file)
        let file = Models.File(name: project.file, hashValue: try? Data(contentsOf: fileURL).hashValue)
        
        self.wallpaper = Models.Wallpaper(project: project, file: file)
        
        self.player = AVPlayer(url: fileURL)
        
        self.isBundled = true
        
        // MARK: player item trigger
        $wallpaper
            .removeDuplicates { oldValue, newValue in
                oldValue.file == newValue.file
            }
            .sink { wallpaper in
                if let fileURL = self.fileURL {
                    self.player.replaceCurrentItem(with: AVPlayerItem(url: fileURL))
                }
            }
            .store(in: &cancellable)
        
        
        // MARK: rate trigger
        $wallpaper
            .removeDuplicates { oldValue, newValue in
                oldValue.config.rate == newValue.config.rate
            }
            .sink { wallpaper in
                self.player.rate = wallpaper.config.rate
            }
            .store(in: &cancellable)
        
        // MARK: volume trigger
        $wallpaper
            .removeDuplicates { oldValue, newValue in
                oldValue.config.volume == newValue.config.volume
            }
            .sink { wallpaper in
                self.player.volume = wallpaper.config.volume
            }
            .store(in: &cancellable)
        
    }
    
    /// Creates a video wallpaper from a local location.
    ///
    /// - Parameters:
    ///   - url: A local location where the wallpaper stores at.
    ///   - wallpaper: Metadata and properties of this wallpaper.
    ///
    /// - Important: Note that the target which url parameter point at must be a folder.
    public init(createAt url: URL, with wallpaper: Models.Wallpaper) throws {
        guard url.isFileURL else { throw WPKError.notBundled }
        
        let encoder = JSONEncoder()
        
        encoder.outputFormatting = .prettyPrinted
        
        let projectData = try encoder.encode(wallpaper.compatibleModel)
        
        try projectData.write(to: url.appending(path: "project.json"))
        
        self.isBundled = true
        
        self.baseURL = url
        
        self.wallpaper = wallpaper
        
        self.player = AVPlayer(playerItem: nil)
        
        $wallpaper
            .removeDuplicates { oldWallpaper, newWallpaper in
                oldWallpaper.file == newWallpaper.file
            }
            .sink { [weak self] wallpaper in
                guard let self = self else { return }
                self.player.replaceCurrentItem(with: .init(url: self.baseURL.appending(path: wallpaper.file.name)))
            }
            .store(in: &cancellable)
    }
    
    /// Creates a video wallpaper from a local location, with provided preview picture and video source file
    ///
    /// - Parameters:
    ///   - url: A local location where the wallpaper stores at.
    ///   - wallpaper: Metadata and properties of this wallpaper.
    ///   - 
    ///
    /// - Important: Note that the target which url parameter point at must be a folder.
    convenience public init(createAt url: URL, with wallpaper: Models.Wallpaper,
                            previewURL: URL? = nil, videoURL: URL? = nil) throws {
        try self.init(createAt: url, with: wallpaper)
        
        if let previewURL = previewURL {
            try FileManager.default.copyItem(at: previewURL, to: url.appending(path: previewURL.lastPathComponent))
        }
        
        if let videoURL = videoURL {
            try FileManager.default.copyItem(at: videoURL, to: url.appending(path: videoURL.lastPathComponent))
        }
    }
}

//public final class SingleVideoWallpaper: SingleWallpaper {
//    
//    public var wallpaper: Models.Wallpaper
//    
//    public var fileURL: URL
//    
//    public init?(contentsOf url: URL) {
//        <#code#>
//    }
//    
//    public init(createAt url: URL, with wallpaper: Models.Wallpaper) throws {
//        <#code#>
//    }
//    
//    
//}

/*
final class LegacyVideoWallpaper: Wallpaper {
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
        
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
            .sink { [weak self] _ in
                self?.player.seek(to: .zero)
                guard let speed = self?.speed else { return }
                self?.player.play()
            }.store(in: &cancellable)
    }
    
//    public init(fileURL: URL) {
//
//    }
}
*/

/*
public final class VideoWallpaper: ObservableObject {
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
        
        NotificationCenter.default.publisher(for: .AVPlayerItemDidPlayToEndTime)
            .sink { [weak self] _ in
                self?.player.seek(to: .zero)
                guard let speed = self?.speed else { return }
                self?.player.play()
            }.store(in: &cancellable)
    }
    
//    public init(fileURL: URL) {
//
//    }
}
*/
