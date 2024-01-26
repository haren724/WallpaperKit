//
//  MultiDisplayManager.swift
//
//
//  Created by Haren on 2024/1/22.
//

import Cocoa
import Combine
import Foundation

public extension Models {
    struct Screen: Hashable, Equatable, Identifiable {
        public var id: Int { self.hashValue }
        
        public var serialNumber: String
        public var modelNumber: String
        public var vendorNumber: String
    }
}

public extension Models {
    struct ScreenConfig {
        public var wallpaper: Wallpaper
        public var isHide: Bool
        
        init(wallpaper: Wallpaper, isHide: Bool = false) {
            self.wallpaper = wallpaper
            self.isHide = isHide
        }
    }
}

/// - Important: Cocoa Application Only!
public final class MultiDisplayManager {
    
    @Published private var configs: [Models.Screen : Models.ScreenConfig] = [:]
    
    private var cancellable = Set<AnyCancellable>()
    
    private init() {
        $configs
            .sink { [weak self] configs in
                self?.updateWindows(with: configs)
            }
            .store(in: &cancellable)
    }
    
    private func updateWindows(with configs: [Models.Screen : Models.ScreenConfig]) {
        
    }
    
    public func loadSettings(settings: [Models.Screen : Models.ScreenConfig]) {
        self.configs = settings
    }
    
    public func updateScreen(_ screen: Models.Screen, to config: Models.ScreenConfig) throws {
        
    }
    
    @discardableResult
    public func resetScreen(_ screen: Models.Screen) -> Models.ScreenConfig? {
        configs.removeValue(forKey: screen)
    }
    
    public func resetAllScreen() {
        self.configs.removeAll()
    }
    
    public static let shared = MultiDisplayManager()
}
