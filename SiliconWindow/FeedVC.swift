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
        let logo = UIImage(named: "word_logo")
        let imageView = UIImageView(image:logo)
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        imageView.frame = CGRectMake(0,0, 100, 50)
        self.navigationItem.titleView = imageView
        
        // set table cell height
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "Posts")
        query.orderByDescending("createdAt")
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let post = object as! Post
        
        // news cell
        if post.news {
            
            var cell = tableView.dequeueReusableCellWithIdentifier("NewsViewCell") as! NewsViewCell
            
            // getting the title and images
            if let post = object as? Post {
                
                cell.postTitle.text = post.title
                cell.numberOfVotes.text = "\(post.votes)"
                cell.companyImage.image = UIImage(named: "placeholder")
                cell.cellId = post.objectId!
                
                // convert date to hrs/mins
                let calendar = NSCalendar.currentCalendar()
                let comp = calendar.components((.CalendarUnitDay | .CalendarUnitHour | .CalendarUnitMinute), fromDate: post.createdAt!)
                let day = comp.day
                let hour = comp.hour
                let minute = comp.minute
                cell.timePosted.text = String(format: "◷ %d %@ %d %@ %d %@", day, "days", hour, "hrs", minute, "mins ago")
                var string:String

                // find associated company name & icon
                let retrieveCompany = PFQuery(className:"Companies")
                if let companyId = post.company.objectId {
                    retrieveCompany.whereKey("objectId", equalTo: companyId)
                    retrieveCompany.findObjectsInBackgroundWithBlock {
                        (objects: [AnyObject]?, error: NSError?) -> Void in
                        if error == nil {
                            // The find succeeded.
                            if let objects = objects as? [Company] {
                                for object in objects {
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        // cell.companyName.text = object.name
                                        if object.imageFile != nil {
                                            cell.icon = object.imageFile!
                                            cell.companyImage.file = object.imageFile!
                                            cell.companyImage.loadInBackground()
                                        }
                                    })
                                }
                            }
                        } else {
                            println("Error: \(error!) \(error!.userInfo!)")
                        }
                    }
                }
                
            }
            
            return cell
        }
        
        // post cell
        else {
            
            var cell = tableView.dequeueReusableCellWithIdentifier("NewsViewCell") as! NewsViewCell
            
            // getting the title and images
            if let post = object as? Post {
                
                cell.postTitle.text = post.title
                cell.newsLabel.hidden = true
                cell.numberOfVotes.text = "\(post.votes)"
                cell.companyImage.image = UIImage(named: "placeholder")
                cell.cellId = post.objectId!
                
                // convert date to hrs/mins
                let calendar = NSCalendar.currentCalendar()
                let comp = calendar.components((.CalendarUnitHour | .CalendarUnitMinute), fromDate: post.createdAt!)
                let hour = comp.hour
                let minute = comp.minute
                cell.timePosted.text = String(format: "◷ %d %@ %d %@", hour, "hrs", minute, "mins ago")
                
                // find associated company name & icon
                let retrieveCompany = PFQuery(className:"Companies")
                if let companyId = post.company.objectId {
                    retrieveCompany.whereKey("objectId", equalTo: companyId)
                    retrieveCompany.findObjectsInBackgroundWithBlock {
                        (objects: [AnyObject]?, error: NSError?) -> Void in
                        if error == nil {
                            // The find succeeded.
                            if let objects = objects as? [Company] {
                                for object in objects {
                                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        // cell.companyName.text = object.name
                                        if object.imageFile != nil {
                                            cell.icon = object.imageFile!
                                            cell.companyImage.file = object.imageFile!
                                            cell.companyImage.loadInBackground()
                                        }
                                    })
                                }
                            }
                        } else {
                            println("Error: \(error!) \(error!.userInfo!)")
                        }
                    }
                }
                
            }
            
            return cell
        }
        
        
    }
    
    // selected a cell --> go to post page
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = self.tableView.cellForRowAtIndexPath(indexPath) as! NewsViewCell
        self.performSegueWithIdentifier("feedToPost", sender: cell)
    }
    
    // segue performed --> prepare data before showing next  screen
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        
        // go to post screen
        if segue.identifier == "feedToPost" {
            let postPage: PostViewController = segue.destinationViewController as! PostViewController
            let cell = sender as! NewsViewCell
            postPage.postId = cell.cellId as String
            postPage.postTitle = cell.postTitle.text! as String
            postPage.timeString = cell.timePosted.text
            postPage.companyLogo = cell.icon as PFFile
        }
        
    }
    
    //pushing a new navcontroller onto navcontroller with modal view
    func createPost () {
        let createVC = storyboard?.instantiateViewControllerWithIdentifier("CreatePostVC") as! CreatePostVC
        let navController = UINavigationController(rootViewController: createVC)
        navigationController?.presentViewController(navController, animated: true, completion: nil)
        
    }


}

