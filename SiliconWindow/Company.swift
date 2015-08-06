//
//  Company.swift
//  SiliconWindow
//
//  Created by Julius Danek on 8/6/15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import Foundation
import Parse

class Company: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "Companies"
    }
    
    @NSManaged var name: String
    @NSManaged var imageFile: PFFile?
    @NSManaged var companyDescription: String?
    @NSManaged var location: String?
    @NSManaged var searchText: String?
}