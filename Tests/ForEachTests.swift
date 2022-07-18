/**
*  CollectionConcurrencyKit
*  Copyright (c) John Sundell 2021
*  MIT license, see LICENSE.md file for details
*/

import XCTest
import CollectionConcurrencyKit

final class ForEachTests: XCTestCase {
    private static let array = Array(0..<5)
    
    func testNonThrowingAsyncForEach() async {
        let results = Results()
        
        await Self.array.asyncForEach { int in
            await results.insert(int)
        }

        let values = await results.set
        XCTAssertEqual(values, Set(Self.array))
    }

    func testThrowingAsyncForEachThatDoesNotThrow() async throws {
        let results = Results()
        
        try await Self.array.asyncForEach { int in
            if int == 1000 {
                throw TestError.theError
            }
            
            await results.insert(int)
        }

        let values = await results.set
        XCTAssertEqual(values, Set(Self.array))
    }
    
    func testThrowingAsyncForEachThatDoesThrow() async throws {
        let results = Results()
        
        do {
            try await Self.array.asyncForEach { int in
                if int == 2 {
                    throw TestError.theError
                }
                
                await results.insert(int)
            }
        } catch TestError.theError {
            // expected error
            return
        }

        XCTFail()
    }
    
    func testNonThrowingConcurrentForEach() async {
        let results = Results()
        
        await Self.array.concurrentForEach { int in
            await results.insert(int)
        }

        let values = await results.set
        XCTAssertEqual(values, Set(Self.array))
    }

    func testThrowingConcurrentForEachThatDoesNotThrow() async throws {
        let results = Results()
        
        try await Self.array.concurrentForEach { int in
            if int == 1000 {
                throw TestError.theError
            }
            
            await results.insert(int)
        }

        let values = await results.set
        XCTAssertEqual(values, Set(Self.array))
    }

    func testThrowingConcurrentForEachThatDoesThrow() async throws {
        let results = Results()
        
        do {
            _ = try await Self.array.concurrentForEach { int in
                if int == 2 {
                    throw TestError.theError
                }
                
                await results.insert(int)
            }
        } catch TestError.theError {
            // expected error
            return
        }

        XCTFail()
    }
}
