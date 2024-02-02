//
//  WallpaperWindowController.swift
//
//
//  Created by Haren on 2024/1/23.
//

import Cocoa
import SwiftUI

public final class WallpaperWindowController<W: Wallpaper>: NSWindowController {
    
    private let wallpaper: W
    
    init(wallpaper: W) {
        self.wallpaper = wallpaper
        super.init(windowNibName: "")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func loadWindow() {
        let window = NSWindow(contentRect: NSRect(origin: .zero,
                                                  size: CGSize(width: NSScreen.main!.visibleFrame.size.width,
                                                               height: NSScreen.main!.visibleFrame.size.height + NSScreen.main!.visibleFrame.origin.y + 1)
                                                 ),
                              styleMask: [.borderless],
                              backing: .buffered,
                              defer: false)
        
        // Adjust window level so that it can stay at desktop image layer
        window.level = NSWindow.Level(Int(CGWindowLevelForKey(.desktopWindow)))
        
        // Avoid being collasped when using mission control
        window.collectionBehavior = .stationary
        
        // Letting this window draggable isn't what we expected
        window.isMovable = false
        
        // We don't need a window title
        window.titleVisibility = .hidden
        
        // And also it can't be hidden
        window.canHide = false
        
        self.window = window
    }
    
    public override func windowDidLoad() {
        super.windowDidLoad()
        
        contentViewController = NSHostingController(rootView: WallpaperView(wallpaper: wallpaper))
        
        window?.setFrame(NSRect(origin: .zero,
                                size: CGSize(width: NSScreen.main!.visibleFrame.size.width,
                                             height: NSScreen.main!.visibleFrame.size.height + NSScreen.main!.visibleFrame.origin.y + 1)
                               ), display: true)
    }
}
