/**
*  CollectionConcurrencyKit
*  Copyright (c) John Sundell 2021
*  MIT license, see LICENSE.md file for details
*/

import XCTest
import CollectionConcurrencyKit

final class CompactMapTests: XCTestCase {
    private static let array = Array(0..<5)
    
    func testNonThrowingAsyncCompactMap() async {
        let values = await Self.array.asyncCompactMap { int in
            return int == 3 ? nil : int
        }

        XCTAssertEqual(values, [0, 1, 2, 4])
    }

    func testThrowingAsyncCompactMapThatDoesNotThrow() async throws {
        let values = try await Self.array.asyncCompactMap { int -> Int? in
            if int == 1000 {
                throw TestError.theError
            }
            
            return int == 3 ? nil : int
        }

        XCTAssertEqual(values, [0, 1, 2, 4])
    }
    
    func testThrowingAsyncCompactMapThatDoesThrow() async throws {
        do {
            _ = try await Self.array.asyncCompactMap { int -> Int? in
                if int == 2 {
                    throw TestError.theError
                }
                
                return int == 3 ? nil : int
            }
        } catch TestError.theError {
            // expected error
            return
        }

        XCTFail()
    }
    
    func testNonThrowingConcurrentCompactMap() async {
        let values = await Self.array.concurrentCompactMap { int in
            return int == 3 ? nil : int
        }

        XCTAssertEqual(values, [0, 1, 2, 4])
    }

    func testThrowingConcurrentCompactMapThatDoesNotThrow() async throws {
        let values = try await Self.array.concurrentCompactMap { int -> Int? in
            if int == 1000 {
                throw TestError.theError
            }
            
            return int == 3 ? nil : int
        }

        XCTAssertEqual(values, [0, 1, 2, 4])
    }
    
    func testThrowingConcurrentCompactMapThatDoesThrow() async throws {
        do {
            _ = try await Self.array.concurrentCompactMap { int -> Int? in
                if int == 2 {
                    throw TestError.theError
                }
                
                return int == 3 ? nil : int
            }
        } catch TestError.theError {
            // expected error
            return
        }

        XCTFail()
    }
}
