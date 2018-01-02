//
//  Place.swift
//  scrollTest
//
//  Created by Brian Carothers on 1/1/18.
//  Copyright © 2018 Brian Carothers. All rights reserved.
//

import UIKit

class Place {
    
    // MARK: Properties
    
    var name: String
    var photo: UIImage?
    var address: String?
    var url: String?
    var date: String?
    var bucketList: Bool
    var visited: Bool
    
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
}
