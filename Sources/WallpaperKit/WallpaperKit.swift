// The Swift Programming Language
// https://docs.swift.org/swift-book

import AVFoundation

#if os(macOS)
import Cocoa
#elseif os(iOS)
import UIKit
#endif

import SwiftUI
import Combine

import OSLog

/// Log reporter object for this framework outputing its information
let logger = Logger()
