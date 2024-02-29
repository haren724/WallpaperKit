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
        
//        CGDisplayMoveCursorToPoint(1, .zero)
    }
    
    func testDictionaryModel() throws {
        struct Screen: Hashable, Equatable, Identifiable, Codable {
            public var id: Int { self.hashValue }
            
            public var serialNumber: String
            public var modelNumber: String
            public var vendorNumber: String
        }
        
        
        
        struct MultiDisplayConfig: Codable {
            var version: Int
            var config: [Screen: Models.ScreenConfig]
        }
        
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        
        let encodedData = try encoder.encode([Screen(serialNumber: "1", modelNumber: "", vendorNumber: ""): 23, Screen(serialNumber: "", modelNumber: "", vendorNumber: ""): 13])
        print(String(data: encodedData, encoding: .utf8)!)
    }
}

