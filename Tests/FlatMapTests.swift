/**
*  CollectionConcurrencyKit
*  Copyright (c) John Sundell 2021
*  MIT license, see LICENSE.md file for details
*/

import XCTest
import CollectionConcurrencyKit

final class FlatMapTests: XCTestCase {
    private static let array = Array(0..<5)
    
    func testNonThrowingAsyncFlatMap() async {
        let values = await Self.array.asyncFlatMap { int in
            return [int, int]
        }

        XCTAssertEqual(values, Self.array.flatMap { [$0, $0] })
    }

    func testThrowingAsyncFlatMapThatDoesNotThrow() async throws {
        let values = try await Self.array.asyncFlatMap { int -> [Int] in
            if int == 1000 {
                throw TestError.theError
            }
            
            return [int, int]
        }

        XCTAssertEqual(values, Self.array.flatMap { [$0, $0] })
    }

    func testThrowingAsyncFlatMapThatThrows() async throws {
        do {
            _ = try await Self.array.asyncFlatMap { int -> [Int] in
                if int == 2 {
                    throw TestError.theError
                }
                
                return [int, int]
            }
        } catch TestError.theError {
            // expected error
            return
        }

        XCTFail()
    }

    func testNonThrowingConcurrentFlatMap() async {
        let values = await Self.array.concurrentFlatMap { int in
            return [int, int]
        }

        XCTAssertEqual(values, Self.array.flatMap { [$0, $0] })
    }

    func testThrowingConcurrentFlatMapThatDoesNotThrow() async throws {
        let values = try await Self.array.concurrentFlatMap { int -> [Int] in
            if int == 1000 {
                throw TestError.theError
            }
            
            return [int, int]
        }

        XCTAssertEqual(values, Self.array.flatMap { [$0, $0] })
    }

    func testThrowingConcurrentFlatMapThatThrows() async throws {
        do {
            _ = try await Self.array.concurrentFlatMap { int -> [Int] in
                if int == 2 {
                    throw TestError.theError
                }
                
                return [int, int]
            }
        } catch TestError.theError {
            // expected error
            return
        }

        XCTFail()
    }
}
