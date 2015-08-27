//
//  FeedViewCell.swift
//  SiliconWindow
//
//  Created by Matthew Sniff on 8/6/15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class NewsViewCell: PFTableViewCell {

    @IBOutlet weak var companyImage: PFImageView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet var upArrow: UIButton!
    @IBOutlet var downArrow: UIButton!
    
    @IBOutlet var newsLabel: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var timePosted: UILabel!
    @IBOutlet weak var numberOfComments: UILabel!
    @IBOutlet weak var numberOfVotes: UILabel!
    var cellId: String = ""
   
    // vote post up
    @IBAction func upVote(sender: AnyObject) {
        
        // change button image
        let image = UIImage(named: "upArrowRed") as UIImage!
        self.upArrow.setImage(image, forState: .Normal)
        
        // change text
        let numVotes:Int? = (self.numberOfVotes.text)?.toInt()
        self.numberOfVotes.text = String(numVotes! + 1)
        
        // save vote
        var saveVote = PFQuery(className:"Posts")
        saveVote.getObjectInBackgroundWithId(cellId) { (Post: PFObject?, error: NSError?) -> Void in
            
            if error == nil && Post != nil {
                Post!.incrementKey("votes")
                Post!.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                        
                    } else {
                    }
                }
            }
            else {  println(error) }
            
        }
        
    }
    
    // vote post down
    @IBAction func downVote(sender: AnyObject) {
        
        // change button image
        let image = UIImage(named: "downArrowRed") as UIImage!
        self.downArrow.setImage(image, forState: .Normal)
        
        // change text
        let numVotes:Int? = (self.numberOfVotes.text)?.toInt()
        self.numberOfVotes.text = String(numVotes! - 1)
        
        var saveVote = PFQuery(className:"Posts")
        saveVote.getObjectInBackgroundWithId(cellId) { (Post: PFObject?, error: NSError?) -> Void in
            
            if error == nil && Post != nil {
                Post!.incrementKey("votes", byAmount: -1)
                Post!.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                    } else {
                    }
                }
            }
            else {  println(error) }
            
        }
        
    }
    
}
