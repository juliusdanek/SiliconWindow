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
    @IBOutlet var newsLabel: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var timePosted: UILabel!
    @IBOutlet weak var numberOfComments: UILabel!
    @IBOutlet weak var numberOfVotes: UILabel!
    
    var cellId: String = ""
    var timeString: String = ""
    var upTapped: Bool = false
    var icon: PFFile?
    var post: Post?
   
    
    // vote post up
    @IBAction func upVote(sender: AnyObject) {
        
        if upTapped {
            saveVotes(false, completionHandler: { (success, error) -> Void in
                if success {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.changeArrow(false)
                    })
                }
            })
        } else {
            saveVotes(true, completionHandler: { (success, error) -> Void in
                if success {
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.changeArrow(true)
                    })
                }
            })
        }
    }
    
    //saving votes to parse in both the post as well as the user class
    func saveVotes(add: Bool, completionHandler: (success: Bool, error: NSError?) -> Void) {
        
        //get current user
        let currentUser = PFUser.currentUser()
        //get the relation for likedPosts
        let relation = currentUser!.relationForKey("likedPosts")
        
        if add {
            //if we are adding, increment votes on posts by 1 and add post to user likes
            post!.incrementKey("votes")
            relation.addObject(post!)
        } else {
            //else, decrement votes on posts by 1 and remove post from user likes
            post!.incrementKey("votes", byAmount: -1)
            relation.removeObject(post!)
        }
        //save in background
        currentUser?.saveInBackgroundWithBlock({ (success, error) -> Void in
            if error != nil{
                completionHandler(success: false, error: error)
            } else {
                //if sucess, save the post as well
                self.post!.saveInBackgroundWithBlock({ (success, error) -> Void in
                    if success {
                        //if success, call the completion Handler
                        completionHandler(success: true, error: nil)
                    } else {
                        completionHandler(success: false, error: error)
                    }
                })
            }
        })
    }
    
    func changeArrow (add: Bool) {
        
        //change selector for cell
        upTapped = add
        
        if add {
            
            //change arrow color
            let image = UIImage(named: "upArrowRed") as UIImage!
            self.upArrow.setImage(image, forState: .Normal)
            
            // change text
            let numVotes:Int? = Int((self.numberOfVotes.text)!)
            self.numberOfVotes.text = String(numVotes! + 1)
        } else {
            //change arrow color
            let image = UIImage(named: "upArrow") as UIImage!
            self.upArrow.setImage(image, forState: .Normal)
            
            // change text
            let numVotes:Int? = Int((self.numberOfVotes.text)!)
            self.numberOfVotes.text = String(numVotes! - 1)
            
        }
    }
}
