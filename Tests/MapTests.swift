/**
*  CollectionConcurrencyKit
*  Copyright (c) John Sundell 2021
*  MIT license, see LICENSE.md file for details
*/

import XCTest
import CollectionConcurrencyKit

final class MapTests: XCTestCase {
    private static let array = Array(0..<5)
    
    func testNonThrowingAsyncMap() async {
        let values = await Self.array.asyncMap { int in
            return int + 1
        }

        XCTAssertEqual(values, [1, 2, 3, 4, 5])
    }

    func testThrowingAsyncMapThatDoesNotThrow() async throws {
        let values = try await Self.array.asyncMap { int -> Int in
            if int == 1000 {
                throw TestError.theError
            }
            
            return int + 1
        }

        XCTAssertEqual(values, [1, 2, 3, 4, 5])
    }
   
    func testThrowingAsyncMapThatDoesThrow() async throws {
        do {
            _ = try await Self.array.asyncMap { int -> Int in
                if int == 2 {
                    throw TestError.theError
                }
                
                return int + 1
            }
        } catch TestError.theError {
            // expected error
            return
        }

        XCTFail()
    }
    
    func testNonThrowingConcurrentMap() async {
        let values = await Self.array.concurrentMap { int in
            return int + 1
        }

        XCTAssertEqual(values, [1, 2, 3, 4, 5])
    }

    func testThrowingConcurrentMapThatDoesNotThrow() async throws {
        let values = try await Self.array.concurrentMap { int -> Int in
            if int == 1000 {
                throw TestError.theError
            }
            
            return int + 1
        }

        XCTAssertEqual(values, [1, 2, 3, 4, 5])
    }
    
    func testThrowingConcurrentMapThatDoesThrow() async throws {
        do {
            _ = try await Self.array.concurrentMap { int -> Int? in
                if int == 2 {
                    throw TestError.theError
                }
                
                return int + 1
            }
        } catch TestError.theError {
            // expected error
            return
        }

        XCTFail()
    }
}
