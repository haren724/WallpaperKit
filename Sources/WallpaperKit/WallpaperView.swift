//
//  WallpaperView.swift
//
//
//  Created by Haren on 2023/10/30.
//
import Cocoa
import SwiftUI
import AVKit

@available(macOS, introduced: 13.0)
struct GifImage: NSViewRepresentable {
    
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


struct VideoWallpaperInspector: View {
    
    @ObservedObject var wallpaper: VideoWallpaper
    
    @State private var saveDate: Date?
    
    var body: some View {
        Form {
            GifImage(contentsOf: wallpaper.bundleURL.appending(path: "preview.gif"), animates: true)
                .resizable()
                .aspectRatio(contentMode: .fit)
            Text(wallpaper.title)
                .frame(maxWidth: .infinity)
                .textSelection(.enabled)
            Section("General") {
                Slider(value: $wallpaper.speed, in: 0.25...2, step: 0.25) {
                    Text("Playback Speed")
                    Text(String(format: "%.2f", wallpaper.speed) + "x")
                } minimumValueLabel: {
                    Image(systemName: "tortoise.fill")
                        .font(.system(size: 10))
                } maximumValueLabel: {
                    Image(systemName: "hare.fill")
                        .font(.system(size: 10))
                }
                
                Slider(value: $wallpaper.volume, in: 0...1) {
                    Text("Volume")
                    Text(String(format: "%.0f", wallpaper.volume * 100) + "%")
                } minimumValueLabel: {
                    Image(systemName: "speaker.minus.fill")
                        .font(.system(size: 10))
                } maximumValueLabel: {
                    Image(systemName: "speaker.plus.fill")
                        .font(.system(size: 10))
                }
                
                Slider(value: $wallpaper.size, in: 0.5...5, step: 0.5) {
                    Text("Size")
                    Text(String(format: "%.1f", wallpaper.size) + "x")
                } minimumValueLabel: {
                    Image(systemName: "arrow.up.forward.and.arrow.down.backward")
                        .font(.system(size: 10))
                } maximumValueLabel: {
                    Image(systemName: "arrow.up.backward.and.arrow.down.forward")
                        .font(.system(size: 10))
                }
            }
            
            Section {
                HStack {
                    Text("""
                         Last Saved:
                         \(saveDate == nil ? "None" : saveDate!.formatted())
                         """)
                        .foregroundStyle(.secondary)
                    Spacer()
                    Button { 
                        try! wallpaper.saveProperties()
                        saveDate = .now
                    } label: {
                        Text("Save").frame(width: 80)
                    }.buttonStyle(.borderedProminent)
                }
                
            }
        }.formStyle(.grouped)
    }
}

//protocol WallpaperView: View {
//    associatedtype W: Wallpaper
//    
//    var wallpaper: W { get }
//}

public struct WallpaperView<W: Wallpaper>: View {
    
    @ObservedObject var wallpaper: W
    
    public init(wallpaper: W) {
        self.wallpaper = wallpaper
    }
    
    public var body: some View {
        if let wallpaper = wallpaper as? VideoWallpaper {
            VideoPlayer(player: wallpaper.player)
        } else {
            Text("Unsupported Wallpaper Type.")
        }
    }
}
