//
//  ViewController.swift
//  SiliconWindow
//
//  Created by Julius Danek on 8/6/15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class FeedVC: PFQueryTableViewController {
    
 
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.parseClassName = "Posts"
        self.textKey = "post"
        self.pullToRefreshEnabled = true
        self.objectsPerPage = 200
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //barbutton item to create a post
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "createPost")
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "Posts")
        query.orderByDescending("post")
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let post = object as! Post
        
        if post.news {
            var cell = tableView.dequeueReusableCellWithIdentifier("NewsViewCell") as! NewsViewCell
            
            cell.companyImage.hidden = true
            cell.companyName.hidden = true
            
            //getting the title and images
            if let post = object as? Post {
                cell.postTitle.text = post.title
                cell.postTitle.adjustsFontSizeToFitWidth = true
                
                cell.numberOfVotes.text = "\(post.votes)"
                
                //            if post.company.imageFile != nil {
                //                cell.companyImage.file = post.company.imageFile!
                //                cell.companyImage.loadInBackground()
                //            }
            }
            
            return cell
        } else {
            var cell = tableView.dequeueReusableCellWithIdentifier("PostViewCell") as! PostViewCell
            
            cell.postTitle.text = post.title
            
            return cell
        }
        
        
    }
    
    
    //pushing a new navcontroller onto navcontroller with modal view
    func createPost () {
        let createVC = storyboard?.instantiateViewControllerWithIdentifier("CreatePostVC") as! CreatePostVC
        let navController = UINavigationController(rootViewController: createVC)
        navigationController?.presentViewController(navController, animated: true, completion: nil)
        
    }


}

