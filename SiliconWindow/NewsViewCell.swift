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
    var timeString: String = ""
    var upTapped: Bool = false
    var downTapped: Bool = false
    var icon: PFFile = PFFile()
   
    
    // vote post up
    @IBAction func upVote(sender: AnyObject) {
        
        // already voted down
        if(downTapped) {
            
            upTapped = true
            downTapped = false
            
            // change button image
            let image = UIImage(named: "upArrowRed") as UIImage!
            self.upArrow.setImage(image, forState: .Normal)
            let imageDown = UIImage(named: "downArrow") as UIImage!
            self.downArrow.setImage(imageDown, forState: .Normal)
            
            // change text
            let numVotes:Int? = (self.numberOfVotes.text)?.toInt()
            self.numberOfVotes.text = String(numVotes! + 2)
            
            // save vote
            saveVotes("upVotes", add: true)
            saveVotes("downVotes", add: false)
            
        }
        
        // already voted up
        else if(upTapped) {
            
            upTapped = false
            
            // change button image
            let image = UIImage(named: "upArrow") as UIImage!
            self.upArrow.setImage(image, forState: .Normal)
            
            // change text
            let numVotes:Int? = (self.numberOfVotes.text)?.toInt()
            self.numberOfVotes.text = String(numVotes! - 1)
            
            // save vote
            saveVotes("upVotes", add: false)
            
            
        } else {
            
            upTapped = true
            
            // change button image
            let image = UIImage(named: "upArrowRed") as UIImage!
            self.upArrow.setImage(image, forState: .Normal)
            
            // change text
            let numVotes:Int? = (self.numberOfVotes.text)?.toInt()
            self.numberOfVotes.text = String(numVotes! + 1)

            // save vote
            saveVotes("upVotes", add: true)
            
        }
        
    }
    
    // vote post down
    @IBAction func downVote(sender: AnyObject) {
        
        // already voted up
        if(upTapped) {
            
            upTapped = false
            downTapped = true
            
            // change button image
            let image = UIImage(named: "upArrow") as UIImage!
            self.upArrow.setImage(image, forState: .Normal)
            let imageDown = UIImage(named: "downArrowRed") as UIImage!
            self.downArrow.setImage(imageDown, forState: .Normal)
            
            // change text
            let numVotes:Int? = (self.numberOfVotes.text)?.toInt()
            self.numberOfVotes.text = String(numVotes! - 2)
            
            // save vote
            saveVotes("downVotes", add: true)
            saveVotes("upVotes", add: false)
            
        }

        // already down voted
        else if(downTapped) {
            
            downTapped = false
            
            // change button image
            let image = UIImage(named: "downArrow") as UIImage!
            self.downArrow.setImage(image, forState: .Normal)
            
            // change text
            let numVotes:Int? = (self.numberOfVotes.text)?.toInt()
            self.numberOfVotes.text = String(numVotes! + 1)
            
            // save vote
            saveVotes("downVotes", add: false)
            
            
        } else {
            
            downTapped = true
            
            // change button image
            let image = UIImage(named: "downArrowRed") as UIImage!
            self.downArrow.setImage(image, forState: .Normal)
            
            // change text
            let numVotes:Int? = (self.numberOfVotes.text)?.toInt()
            self.numberOfVotes.text = String(numVotes! - 1)
            
            // save vote
            saveVotes("downVotes", add: true)
            
        }
    }
    
    func saveVotes(relation: String, add: Bool) {

        var saveVote = PFQuery(className:"Posts")
        
        saveVote.getObjectInBackgroundWithId(cellId) { (Post: PFObject?, error: NSError?) -> Void in
            
            if error == nil && Post != nil {
                var relation = Post!.relationForKey(relation)
                if add {
                    relation.addObject(PFUser.currentUser()!)
                } else {
                    relation.removeObject(PFUser.currentUser()!)
                }
                Post!.saveInBackgroundWithBlock {
                    (success: Bool, error: NSError?) -> Void in
                    if (success) {
                    } else { }
                }
            }
            else {  println(error) }
        }
    }
    
}
