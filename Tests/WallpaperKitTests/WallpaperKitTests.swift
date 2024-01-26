import XCTest
@testable import WallpaperKit

import Quartz

final class WallpaperKitTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods
    }
    
    func testQuartz() throws {
        print(CGMainDisplayID())
        
        let maxDisplays: UInt32 = 8
        
        let activeDisplays = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: Int(maxDisplays))
        let onlineDisplays = UnsafeMutablePointer<CGDirectDisplayID>.allocate(capacity: Int(maxDisplays))
        let displayCount = UnsafeMutablePointer<UInt32>.allocate(capacity: Int(maxDisplays))
        
        CGGetActiveDisplayList(maxDisplays, activeDisplays, displayCount)
        print(activeDisplays[1], displayCount[1])
        
        CGGetOnlineDisplayList(maxDisplays, onlineDisplays, displayCount)
        print(onlineDisplays.pointee, displayCount.pointee)
        
        print("Serial Number:", String(CGDisplaySerialNumber(1), radix: 16).uppercased())
        print("Model Number:", String(CGDisplayModelNumber(1), radix: 16).uppercased())
        print("Vendor Number:", String(CGDisplayVendorNumber(1), radix: 16).uppercased())
        
//        CGDisplayIOServicePort(<#T##CGDirectDisplayID#>)
//        IODisplayCreateInfoDictionary(<#T##framebuffer: io_service_t##io_service_t#>, <#T##options: IOOptionBits##IOOptionBits#>)
        
        CGDisplayMoveCursorToPoint(1, .zero)
        
        
    }
}
