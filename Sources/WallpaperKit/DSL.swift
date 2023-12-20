//
//  DSL.swift
//
//
//  Created by Haren on 2023/11/27.
//

import Foundation

protocol DSLWallpaper {
    associatedtype Body: DSLWallpaper
    
    @WallpaperBuilder @MainActor var body: Self.Body { get }
}

extension DSLWallpaper {
    var body: some DSLWallpaper {
        EmptyWallpaper()
    }
}

struct EmptyWallpaper: DSLWallpaper { }

struct DSLPhoto: DSLWallpaper { }

struct DSLVideo: DSLWallpaper { }

struct DSLClock: DSLWallpaper { }

struct DSLSpacer: DSLWallpaper { }

struct DSLVStack: DSLWallpaper { }


@resultBuilder
struct WallpaperBuilder {
    
    static func buildlBlock() -> EmptyWallpaper {
        EmptyWallpaper()
    }
    
    static func buildBlock<Content: DSLWallpaper>(_ content: Content) -> Content {
        content
    }
    
    static func buildBlock<Content: DSLWallpaper>(_ content: Content...) -> Content {
        content.first!
    }
    
    static func buildExpression<Content: DSLWallpaper>(_ content: Content) -> Content {
        content
    }
}

