import Foundation
import XCTest
@testable import Player

final class DownloadStateTests: XCTestCase {
    func testDownloadStateRawValues() {
        // Verify the enum raw values are consistent with what we expect
        XCTAssertEqual(DownloadState.PENDING.rawValue, "PENDING")
        XCTAssertEqual(DownloadState.IN_PROGRESS.rawValue, "IN_PROGRESS")
        XCTAssertEqual(DownloadState.PAUSED.rawValue, "PAUSED")
        XCTAssertEqual(DownloadState.FAILED.rawValue, "FAILED")
        XCTAssertEqual(DownloadState.COMPLETED.rawValue, "COMPLETED")
        XCTAssertEqual(DownloadState.CANCELLED.rawValue, "CANCELLED")
    }
    
    func testDownloadStateCoding() throws {
        // Test encoding and decoding of the enum
        let states: [DownloadState] = [.PENDING, .IN_PROGRESS, .PAUSED, .FAILED, .COMPLETED, .CANCELLED]
        
        for originalState in states {
            // Encode the state
            let encoder = JSONEncoder()
            let data = try encoder.encode(originalState)
            
            // Decode the state
            let decoder = JSONDecoder()
            let decodedState = try decoder.decode(DownloadState.self, from: data)
            
            // Verify the decoded state matches the original
            XCTAssertEqual(decodedState, originalState)
        }
    }
    
    func testAllCasesAccessible() {
        // Verify CaseIterable works correctly
        let allStates = DownloadState.allCases
        
        XCTAssertEqual(allStates.count, 6)
        XCTAssertTrue(allStates.contains(.PENDING))
        XCTAssertTrue(allStates.contains(.IN_PROGRESS))
        XCTAssertTrue(allStates.contains(.PAUSED))
        XCTAssertTrue(allStates.contains(.FAILED))
        XCTAssertTrue(allStates.contains(.COMPLETED))
        XCTAssertTrue(allStates.contains(.CANCELLED))
    }
}