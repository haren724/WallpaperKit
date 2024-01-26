//
//  VideoWallpaperView.swift
//  
//
//  Created by Haren on 2024/1/17.
//

import SwiftUI
import AVKit

struct VideoWallpaperView: NSViewRepresentable {
    
    @ObservedObject var wallpaper: VideoWallpaper
    
    func makeNSView(context: Context) -> AVPlayerView {
        let view = AVPlayerView()
        
        view.player = wallpaper.player
        
        // make the video boundary extends to fit the full screen without black background border
        view.videoGravity = .resizeAspectFill
        
        // hide any unneeded ui component, we want just the video output
        view.controlsStyle = .none
        
        // make sure this video player won't show any info in the system control center
        view.updatesNowPlayingInfoCenter = false
        
        // mark the flag as unneeded, improve performance and reduce power drain
        view.allowsVideoFrameAnalysis = false
        
        return view
    }
    
    func updateNSView(_ nsView: AVPlayerView, context: Context) {
        
    }
}
