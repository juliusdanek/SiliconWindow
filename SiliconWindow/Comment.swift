//
//  Comment.swift
//  SiliconWindow
//
//  Created by Julius Danek on 8/6/15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

//MARK: General comments
/*
This is the comment view cell. 
TODO: Think about adding an upvote button here. 
TODO: Add flagging buttons
*/


import Foundation
import Parse

class Comment: PFObject, PFSubclassing {
    
    static func parseClassName() -> String {
        return "Comments"
    }
    
    @NSManaged var commentString: String
    @NSManaged var votes: Int
    @NSManaged var postID: Post
}