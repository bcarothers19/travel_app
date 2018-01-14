//
//  Place.swift
//  scrollTest
//
//  Created by Brian Carothers on 1/1/18.
//  Copyright © 2018 Brian Carothers. All rights reserved.
//

import UIKit
import os.log
import GooglePlaces

class Place: NSObject, NSCoding {
    
    // MARK: Archiving Paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("places")
    
    // MARK: Properties
    var name: String
    var photo: UIImage?
    var address: String?
    var url: String?
    
    var coords: CLLocationCoordinate2D?
    var viewpoint: GMSCoordinateBounds?
    var country: String?
    var city: String?

    var bucketList: Bool
    var visited: Bool

    var dateRangeText: String?
    var startSelected: Bool
    var startMonth: String
    var startDay: String
    var startYear: String
    var startText: String
    var endSelected: Bool
    var endMonth: String
    var endDay: String
    var endYear: String
    var endText: String

    
    // MARK: Types
    struct PropertyKey {
        static let name = "name"
        static let photo = "photo"
        static let address = "address"
        static let url = "url"
        
        static let coords = "coords"
        static let viewpoint = "viewpoint"
        static let country = "country"
        static let city = "city"
        
        static let bucketList = "bucketList"
        static let visited = "visited"
        
        static let dateRangeText = "dateRangeText"
        static let startSelected = "startSelected"
        static let startMonth = "startMonth"
        static let startDay = "startDay"
        static let startYear = "startYear"
        static let startText = "startText"
        static let endSelected = "endSelected"
        static let endMonth = "endMonth"
        static let endDay = "endDay"
        static let endYear = "endYear"
        static let endText = "endText"
    }
    
    init?(name: String, photo: UIImage?, address: String?, url: String?, coords: CLLocationCoordinate2D?, viewpoint: GMSCoordinateBounds?, country: String?, city: String?, bucketList: Bool, visited: Bool, dateRangeText: String?, startSelected: Bool, startMonth: String, startDay: String, startYear: String, startText: String, endSelected: Bool, endMonth: String, endDay: String, endYear: String, endText: String) {
        // Must have a name
        guard !name.isEmpty else {
            return nil
        }
        // Initialize stored properties
        self.name = name
        self.photo = photo
        self.address = address
        self.url = url
        
        self.coords = coords
        self.viewpoint = viewpoint
        self.country = country
        self.city = city
        
        self.bucketList = bucketList
        self.visited = visited
        
        self.dateRangeText = dateRangeText
        self.startSelected = startSelected
        self.startMonth = startMonth
        self.startDay = startDay
        self.startYear = startYear
        self.startText = startText
        self.endSelected = endSelected
        self.endMonth = endMonth
        self.endDay = endDay
        self.endYear = endYear
        self.endText = endText

        
    }
    
    // MARK: NSCoding
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.name)
        aCoder.encode(photo, forKey: PropertyKey.photo)
        aCoder.encode(address, forKey: PropertyKey.address)
        aCoder.encode(url, forKey: PropertyKey.url)
        
        aCoder.encode(coords, forKey: PropertyKey.coords)
        aCoder.encode(viewpoint, forKey: PropertyKey.viewpoint)
        aCoder.encode(country, forKey: PropertyKey.country)
        aCoder.encode(city, forKey: PropertyKey.city)

        aCoder.encode(bucketList, forKey: PropertyKey.bucketList)
        aCoder.encode(visited, forKey: PropertyKey.visited)
        
        aCoder.encode(dateRangeText, forKey: PropertyKey.dateRangeText)
        aCoder.encode(startSelected, forKey: PropertyKey.startSelected)
        aCoder.encode(startMonth, forKey: PropertyKey.startMonth)
        aCoder.encode(startDay, forKey: PropertyKey.startDay)
        aCoder.encode(startYear, forKey: PropertyKey.startYear)
        aCoder.encode(startText, forKey: PropertyKey.startText)
        aCoder.encode(endSelected, forKey: PropertyKey.endSelected)
        aCoder.encode(endMonth, forKey: PropertyKey.endMonth)
        aCoder.encode(endDay, forKey: PropertyKey.endDay)
        aCoder.encode(endYear, forKey: PropertyKey.endYear)
        aCoder.encode(endText, forKey: PropertyKey.endText)
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
        
        let coords = aDecoder.decodeObject(forKey: PropertyKey.coords) as? CLLocationCoordinate2D
        let viewpoint = aDecoder.decodeObject(forKey: PropertyKey.viewpoint) as? GMSCoordinateBounds
        let country = aDecoder.decodeObject(forKey: PropertyKey.country) as? String
        let city = aDecoder.decodeObject(forKey: PropertyKey.city) as? String

        let dateRangeText = aDecoder.decodeObject(forKey: PropertyKey.dateRangeText) as? String
        let bucketList = aDecoder.decodeBool(forKey: PropertyKey.bucketList)
        let visited = aDecoder.decodeBool(forKey: PropertyKey.visited)

        let startSelected = aDecoder.decodeBool(forKey: PropertyKey.startSelected)
        guard let startMonth = aDecoder.decodeObject(forKey: PropertyKey.startMonth) as? String else {
            os_log("Unable to decode the startMonth for a Place object", log: OSLog.default, type: .debug)
            return nil
        }
        guard let startDay = aDecoder.decodeObject(forKey: PropertyKey.startDay) as? String else {
            os_log("Unable to decode the startDay for a Place object", log: OSLog.default, type: .debug)
            return nil
        }
        guard let startYear = aDecoder.decodeObject(forKey: PropertyKey.startYear) as? String else {
            os_log("Unable to decode the startYear for a Place object", log: OSLog.default, type: .debug)
            return nil
        }
        guard let startText = aDecoder.decodeObject(forKey: PropertyKey.startText) as? String else {
            os_log("Unable to decode the startText for a Place object", log: OSLog.default, type: .debug)
            return nil
        }
        let endSelected = aDecoder.decodeBool(forKey: PropertyKey.endSelected)
        guard let endMonth = aDecoder.decodeObject(forKey: PropertyKey.endMonth) as? String else {
            os_log("Unable to decode the endMonth for a Place object", log: OSLog.default, type: .debug)
            return nil
        }
        guard let endDay = aDecoder.decodeObject(forKey: PropertyKey.endDay) as? String else {
            os_log("Unable to decode the endDay for a Place object", log: OSLog.default, type: .debug)
            return nil
        }
        guard let endYear = aDecoder.decodeObject(forKey: PropertyKey.endYear) as? String else {
            os_log("Unable to decode the endYear for a Place object", log: OSLog.default, type: .debug)
            return nil
        }
        guard let endText = aDecoder.decodeObject(forKey: PropertyKey.endText) as? String else {
            os_log("Unable to decode the endText for a Place object", log: OSLog.default, type: .debug)
            return nil
        }

        
        // Must call the designated initializer
        self.init(name: name, photo: photo, address: address, url: url, coords: coords, viewpoint: viewpoint, country: country, city: city, bucketList: bucketList, visited: visited, dateRangeText: dateRangeText, startSelected: startSelected, startMonth: startMonth, startDay: startDay, startYear: startYear, startText: startText, endSelected: endSelected, endMonth: endMonth, endDay: endDay, endYear: endYear, endText: endText)
    }
    
}
