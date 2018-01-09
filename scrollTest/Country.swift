//
//  Country.swift
//  mapbox test
//
//  Created by Brian Carothers on 1/6/18.
//  Copyright © 2018 Brian Carothers. All rights reserved.
//

import UIKit
import os.log

class Country: NSObject, NSCoding {
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("countries")
    
    // MARK: Properties
    var name: String
    var flag: UIImage?
    var hasVisited: Bool
    var wantToVisit: Bool
    
    
    // MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let flag = "flag"
        static let hasVisited = "hasVisited"
        static let wantToVisit = "wantToVisit"
    }
    
    init?(name: String, flag: UIImage?, hasVisited: Bool, wantToVisit: Bool) {
        // Must have a name
        guard !name.isEmpty else {
            return nil
        }
        
        // Initialize stored properties
        self.name = name
        self.flag = flag
        self.hasVisited = hasVisited
        self.wantToVisit = wantToVisit
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(flag, forKey: PropertyKey.flag)
        aCoder.encode(hasVisited, forKey: PropertyKey.hasVisited)
        aCoder.encode(wantToVisit, forKey: PropertyKey.wantToVisit)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name, hasVisited, wantToVisit fields are required
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Country object", log: OSLog.default, type: .debug)
            return nil
        }
        guard let hasVisited = aDecoder.decodeObject(forKey: PropertyKey.hasVisited) as? Bool else {
            os_log("Unable to decode hasVisited for a Country object", log: OSLog.default, type: .debug)
            return nil
        }
        guard let wantToVisit = aDecoder.decodeObject(forKey: PropertyKey.wantToVisit) as? Bool else {
            os_log("Unable to decode wantToVisit for a Country object", log: OSLog.default, type: .debug)
            return nil
        }
        
        // The rest of the variable are optional properties, use a conditional cast
        let flag = aDecoder.decodeObject(forKey: PropertyKey.flag) as? UIImage
        
        // Must call the designated initializer
        self.init(name: name, flag: flag, hasVisited: hasVisited, wantToVisit: wantToVisit)
    }
}

