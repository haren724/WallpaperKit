//
//  Common.swift
//  
//
//  Created by Haren on 2024/1/28.
//

import XCTest

/// A subclass of ``XCTestCase`` which is dedicated for testing specific
/// type of  ``Wallpaper`` objects and their relavant models.
///
/// - Note: Use this protocol ONLY for test targets. It shouldn't be shown in your release target code.
public protocol WallpaperTestable: XCTestCase {
    
    /// Test the wallpaper's models
    func testImportModel() throws
    
    /// Test the wallpaper's render logic
    func testRenderer() throws
    
    /// Test the wallpaper properties' persistence
    func testEditingProperties() throws
}

public extension WallpaperTestable {
    func testImportModel() throws { }
    
    func testRenderer() throws { }
    
    func testEditingProperties() throws { }
}
