//
//  VideoWallpaperInspector.swift
//  
//
//  Created by Haren on 2024/1/17.
//

import SwiftUI

public struct VideoWallpaperInspector: View {
    
    @ObservedObject private var viewModel: VideoWallpaper
    
    @State private var saveDate: Date?
    
    public init?(url: URL) {
        guard let wallpaper = VideoWallpaper(contentsOf: url) else { return nil }
        self.viewModel = wallpaper
    }
    
    public init(wallpaper: VideoWallpaper) {
        self.viewModel = wallpaper
    }
    
    public var body: some View {
        Form(content: {
            if let previewURL = viewModel.bundleURL?.appending(path: "preview.gif") {
                AnimatedImage(contentsOf: previewURL, animates: true)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            } else {
                Color.secondary
                    .aspectRatio(contentMode: .fit)
            }
            Text(viewModel.wallpaper.title)
                .frame(maxWidth: .infinity)
                .textSelection(.enabled)
            Section("General") {
                Slider(value: $viewModel.wallpaper.config.rate, in: 0.25...2, step: 0.25) {
                    Text("Playback Speed")
                    Text(String(format: "%.2f", viewModel.wallpaper.config.rate) + "x")
                } minimumValueLabel: {
                    Image(systemName: "tortoise.fill")
                        .font(.system(size: 10))
                } maximumValueLabel: {
                    Image(systemName: "hare.fill")
                        .font(.system(size: 10))
                }
                
                Slider(value: $viewModel.wallpaper.config.volume, in: 0...1) {
                    Text("Volume")
                    Text(String(format: "%.0f", viewModel.wallpaper.config.volume * 100) + "%")
                } minimumValueLabel: {
                    Image(systemName: "speaker.minus.fill")
                        .font(.system(size: 10))
                } maximumValueLabel: {
                    Image(systemName: "speaker.plus.fill")
                        .font(.system(size: 10))
                }
                
                Slider(value: $viewModel.wallpaper.config.size, in: 0.5...5, step: 0.5) {
                    Text("Size")
                    Text(String(format: "%.1f", viewModel.wallpaper.config.size) + "x")
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
                        saveDate = .now
                    } label: {
                        Text("Save").frame(width: 80)
                    }.buttonStyle(.borderedProminent)
                }
                
            }
        }).formStyle(.grouped)
    }
}

#Preview("Video Wallpaper Inspector") {
    VideoWallpaperInspector(url: URL(filePath: "/Users/haren724/Library/Containers/com.haren724.wallpaper-player/Data/Documents/2854415058"))
        .frame(width: 350, height: 600)
}

#Preview("Web Wallpaper Inspector") {
    VideoWallpaperInspector(url: URL(filePath: "/Users/haren724/Library/Containers/com.haren724.wallpaper-player/Data/Documents/1748506393"))
        .frame(width: 350, height: 600)
}
