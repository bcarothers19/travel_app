//
//  Globals.swift
//  scrollTest
//
//  Created by Brian Carothers on 1/7/18.
//  Copyright © 2018 Brian Carothers. All rights reserved.
//

import UIKit

class Globals {
    struct Countries {
        static var countries = NSMutableDictionary(dictionary: [String: Country]())
        static var visitedCountries = [String]()
        static var wantToVisitCountries = [String]()
    }
}
