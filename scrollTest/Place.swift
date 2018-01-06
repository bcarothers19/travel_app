//
//  Place.swift
//  scrollTest
//
//  Created by Brian Carothers on 1/1/18.
//  Copyright © 2018 Brian Carothers. All rights reserved.
//

import UIKit
import os.log

class Place: NSObject, NSCoding {
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("places")
    
    // MARK: Properties
    var name: String
    var photo: UIImage?
    var address: String?
    var url: String?
    var date: String?
    var bucketList: Bool
    var visited: Bool
    
    // MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let address = "address"
        static let url = "url"
        static let date = "date"
        static let bucketList = "bucketList"
        static let visited = "visited"
    }
    
    init?(name: String, photo: UIImage?, address: String?, url: String?, date: String?, bucketList: Bool, visited: Bool) {
        // Must have a name
        guard !name.isEmpty else {
            return nil
        }
        // Initialize stored properties
        self.name = name
        self.photo = photo
        self.address = address
        self.url = url
        self.date = date
        self.bucketList = bucketList
        self.visited = visited
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(address, forKey: PropertyKey.address)
        aCoder.encode(url, forKey: PropertyKey.url)
        aCoder.encode(date, forKey: PropertyKey.date)
        aCoder.encode(bucketList, forKey: PropertyKey.bucketList)
        aCoder.encode(visited, forKey: PropertyKey.visited)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        // The name is required. If we can't decode a name string, the initializer should fail
        guard let name = aDecoder.decodeObject(forKey: PropertyKey.name) as? String else {
            os_log("Unable to decode the name for a Place object", log: OSLog.default, type: .debug)
            return nil
        }
        
        // The rest of the variables are optional properties, so just use a conditional cast
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photo) as? UIImage
        let address = aDecoder.decodeObject(forKey: PropertyKey.address) as? String
        let url = aDecoder.decodeObject(forKey: PropertyKey.url) as? String
        let date = aDecoder.decodeObject(forKey: PropertyKey.date) as? String
        let bucketList = aDecoder.decodeBool(forKey: PropertyKey.bucketList)
        let visited = aDecoder.decodeBool(forKey: PropertyKey.visited)

        // Must call the designated initializer
        self.init(name: name, photo: photo, address: address, url: url, date: date, bucketList: bucketList, visited: visited)
        
    }
    
}
