/**
*  CollectionConcurrencyKit
*  Copyright (c) John Sundell 2021
*  MIT license, see LICENSE.md file for details
*/

enum TestError: Error {
    case theError
}

actor Results {
    var set: Set<Int>
    
    init() {
        set = []
    }
    
    func insert(_ newMember: Int) {
        set.insert(newMember)
    }
}
