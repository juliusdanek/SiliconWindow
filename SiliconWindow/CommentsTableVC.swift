//
//  CommentsTableVC.swift
//  SiliconWindow
//
//  Created by Matthew Sniff on 8/30/15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class CommentsTableVC: PFQueryTableViewController {
    
    var postId: String!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.parseClassName = "Comments"
        self.textKey = "comment"
        self.pullToRefreshEnabled = true
        self.objectsPerPage = 200
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()

        // set table cell height
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func queryForTable() -> PFQuery {
        let query = PFQuery(className: "Comments")
        query.whereKey("postId", equalTo: postId)
        query.orderByDescending("createdAt")
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CommentCell") as! CommentCell
        
        if let comment = object as? Comment {
            
            cell.comment.text = comment.commentString
            // convert date to hrs/mins
            let calendar = NSCalendar.currentCalendar()
            let comp = calendar.components([.Hour , .Minute], fromDate: comment.createdAt!)
            let hour = comp.hour
            let minute = comp.minute
            cell.time.text = String(format: "◷ 8%d %@ %d %@", hour, "hrs", minute, "mins ago")
        }
        return cell
    }
    
}
