//
//  WebWallpaperTests.swift
//
//
//  Created by Haren on 2024/1/28.
//

import XCTest
import Common
@testable import WallpaperKit

final class VideoWallpaperTests: XCTestCase, WallpaperTestable {
    func testImportModel() throws {
        let projectURL = try XCTUnwrap(Bundle.module.url(forResource: "project", withExtension: "json"))
        let project = try JSONDecoder().decode(WallpaperEngine.Project.self, from: Data(contentsOf: projectURL))
        print(project)
    }
}
