//
//  WallpaperView.swift
//
//
//  Created by Haren on 2023/10/30.
//

import SwiftUI

struct EmptyWallpaperView: View {
    var body: some View {
        Text("Where is your wallpaper?")
            .bold()
            .font(.system(size: 64))
            .shadow(radius: 1, x: 4, y: 4)
    }
}

#Preview {
    EmptyWallpaperView()
        .frame(width: 640, height: 360)
}
