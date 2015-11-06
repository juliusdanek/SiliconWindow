//
//  SecondViewController.swift
//  SiliconWindow
//
//  Created by Julius Danek on 8/6/15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

//MARK: General Comments
/*
This is the the VC that shows details about a post
It shows an image of the post & the text of the post. 
*/

//TODO: the layout of the post needs to be changed
//TODO: Add reporting button in top right. 

import UIKit
import Parse
import ParseUI

class PostViewController: UIViewController {
    
    // public vars
    var postId: String!
    var timeString: String!
    var companyLogo: PFFile?
    var postTitle: String = ""

    // connections
    @IBOutlet var companyIcon: PFImageView!
    @IBOutlet var postText: UITextView!
    @IBOutlet var time: UILabel!
    @IBOutlet var containerView: UIView!
    @IBOutlet var commentField: UITextField!
   
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {

        super.viewDidLoad()
       
        // set outlets
        self.title = "Post Details"
        //
        self.postText.text = postTitle
        //being passed from other controller
        self.time.text = timeString
        
        // set padding or comment field
        let paddingView = UIView(frame: CGRectMake(0, 0, 10, self.commentField.frame.height))
        self.commentField.leftView = paddingView
        self.commentField.leftViewMode = UITextFieldViewMode.Always

        // set icon image
        self.companyIcon.file = companyLogo
        self.companyIcon.loadInBackground()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //Segue for container screen --> prepare data before showing next screen.
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // go to post screen
        if segue.identifier == "commentsEmbed" {
            let commentsTable: CommentsTableVC = segue.destinationViewController as! CommentsTableVC
            commentsTable.postId = postId as String
        }
        
    }

    // post a comment
    //TODO: The commenting system seems to be working but should double check and test
    @IBAction func postComment(sender: AnyObject) {
        
        let comment = PFObject(className:"Comments")
        comment["commentString"] = self.commentField.text
        comment["postId"] = self.postId
        comment.saveInBackgroundWithBlock {
            (success: Bool, error: NSError?) -> Void in
            if (success) {
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    //reload the table view below once the comment has been successfully posted
                    let tableVC : CommentsTableVC = self.childViewControllers[0] as! CommentsTableVC
                    tableVC.viewDidLoad()
                    //reset the commentField to empty
                    self.commentField.text = ""
                })
                
            } else {
                // There was a problem, check error.description
            }
        }

        
    }
    
}

