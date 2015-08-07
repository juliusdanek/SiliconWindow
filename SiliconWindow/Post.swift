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
    
    @NSManaged var title: String
    @NSManaged var post: String
    @NSManaged var sentiment: Int
    @NSManaged var votes: Int
    @NSManaged var news: Bool
    
    //relations to other PFObjects
    @NSManaged var company: Company
    @NSManaged var comments: [Comment]
}