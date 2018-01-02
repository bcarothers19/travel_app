//
//  scrollTestTests.swift
//  scrollTestTests
//
//  Created by Brian Carothers on 12/31/17.
//  Copyright © 2017 Brian Carothers. All rights reserved.
//

import XCTest
@testable import scrollTest

class scrollTestTests: XCTestCase {
    
    // MARK: Place Class Tests
    
    // Confirm the Place initializaer returns a Place object when passed valid parameters
    func testPlaceInitializationSucceeds() {
        let normalPlace = Place.init(name: "Lappland", photo: nil, address: "123 North St, Lappland Finland", url: "www.lappland.fl", date: "Dec - March", bucketList: true, visited: false)
        XCTAssertNotNil(normalPlace)
        
        let onlyNamePlace = Place.init(name: "Lappland", photo: nil, address: nil, url: nil, date: nil, bucketList: true, visited: false)
        XCTAssertNotNil(onlyNamePlace)
    }

    func testPlaceInitializationFails() {
        let emptyName = Place.init(name: "", photo: nil, address: "123 North St, Lappland Finland", url: "www.lappland.fl", date: "Dec - March", bucketList: true, visited: false)
        XCTAssertNil(emptyName)
    }
    
}
