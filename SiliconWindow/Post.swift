//
//  Post.swift
//  SiliconWindow
//
//  Created by Matthew Sniff on 8/6/15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import Foundation
import Parse

class Post: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "Posts"
    }
    
    @NSManaged var name: String
    @NSManaged var imageFile: PFFile?
    
}