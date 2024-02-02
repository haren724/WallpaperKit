//
//  AnimatedImage.swift
//
//
//  Created by Haren on 2024/2/1.
//

import Cocoa
import SwiftUI

@available(macOS, introduced: 13.0)
struct AnimatedImage: NSViewRepresentable {
    
    var gifName: String?
    var gifUrl: URL?
    
    var isResizable: Bool = false
    var contentMode: ContentMode = .fill
    
    var animates: Bool
    
    init(_ gifName: String, animates: Bool = true) {
        self.gifName = gifName
        self.animates = animates
    }
    
    init(contentsOf url: URL, animates: Bool = true) {
        self.gifUrl = url
        self.animates = animates
    }
    
    func makeNSView(context: Context) -> NSImageView {
        let nsView = NSImageView()
        
        nsView.canDrawSubviewsIntoLayer = true
        nsView.imageScaling = .scaleProportionallyUpOrDown
        nsView.animates = animates
        
        if let gifName = self.gifName {
            if let url = Bundle.main.url(forResource: gifName, withExtension: "gif") {
                if let image = NSImage(contentsOf: url) {
                    let gifRep = image.representations[0] as? NSBitmapImageRep
                    gifRep?.setProperty(.loopCount, withValue: 0)
                    nsView.image = image
                }
            }
        }
        if let gifUrl = self.gifUrl {
            if let image = NSImage(contentsOf: gifUrl) {
                let gifRep = image.representations[0] as? NSBitmapImageRep
                gifRep?.setProperty(.loopCount, withValue: 0)
                nsView.image = image
            }
        }
        
        return nsView
    }
    
    func updateNSView(_ nsView: NSImageView, context: Context) {
        nsView.animates = animates
        updateModifiers(nsView)
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, nsView: NSImageView, context: Context) -> CGSize? {
        if !self.isResizable {
            return nsView.sizeThatFits(nsView.frame.size)
        } else {
            guard let width = proposal.width, let height = proposal.height else { return nil }
            return CGSize(width: width, height: height)
        }
    }
    
    private func updateModifiers(_ nsView: NSImageView) {
        if let gifName = self.gifName {
            if let url = Bundle.main.url(forResource: gifName, withExtension: "gif") {
                if let image = NSImage(contentsOf: url) {
                    let gifRep = image.representations[0] as? NSBitmapImageRep
                    gifRep?.setProperty(.loopCount, withValue: 0)
                    nsView.image = image
                }
            }
        }
        if let gifUrl = self.gifUrl {
            if let image = NSImage(contentsOf: gifUrl) {
                let gifRep = image.representations[0] as? NSBitmapImageRep
                gifRep?.setProperty(.loopCount, withValue: 0)
                nsView.image = image
            }
        }
        if self.isResizable {
            switch self.contentMode {
            case .fill:
                nsView.imageScaling = .scaleAxesIndependently
            case .fit:
                nsView.imageScaling = .scaleProportionallyUpOrDown
            }
        }
    }
    
    func resizable(capInsets: EdgeInsets = EdgeInsets(), resizingMode: Image.ResizingMode = .stretch) -> Self {
        var view = self
        view.isResizable = true
        return view
    }
    
    func aspectRatio(_ aspectRatio: CGFloat? = nil, contentMode: ContentMode) -> Self {
        var view = self
        view.contentMode = contentMode
        return view
    }
}

public struct WallpaperView<W: Wallpaper>: View {
    
    @ObservedObject var wallpaper: W
    
    public init(wallpaper: W) {
        self.wallpaper = wallpaper
    }
    
    public var body: some View {
        if let wallpaper = wallpaper as? VideoWallpaper {
            VideoWallpaperView(wallpaper: wallpaper)
        } else {
            Text("Unsupported Wallpaper Type.")
        }
    }
}
