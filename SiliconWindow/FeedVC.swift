//
//  ViewController.swift
//  SiliconWindow
//
//  Created by Julius Danek on 8/6/15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//


//MARK: General comments
/*
The feed displays all posts and news that the user has subscribed to
It queries all posts and then checks the ones that correspond to the ones that the user has subscribed to
In addition, it needs to check whether a certain user already upvoted a post or not
This process takes a long time and should be optimized in some way
*/

//TODO: Think about only allowing upvotes, thereby limiting the amount of time that the user
//TODO: Center vote label, not centered currently
//TODO: Change post layouts
        //In the case of a simple post, the post should show the entire post. In the case of news, it should simply show the title and provide the weblink




import UIKit
import Parse
import ParseUI

class FeedVC: PFQueryTableViewController {
    
 
    @IBOutlet weak var segControl: UISegmentedControl!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.parseClassName = "Posts"
        self.pullToRefreshEnabled = true
        self.objectsPerPage = 200
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        //barbutton item to create a post
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "createPost")
//        let logo = UIImage(named: "word_logo")
//        let imageView = UIImageView(image:logo)
//        let screenSize: CGRect = UIScreen.mainScreen().bounds
//        imageView.frame = CGRectMake(0,0, 100, 50)
//        self.navigationItem.titleView = imageView
        
        // set table cell height
        tableView.estimatedRowHeight = 68.0
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func objectsWillLoad() {
        super.objectsWillLoad()
//        print("almost loaded")
//        print(self.objects!.count)
    }
    
    override func objectsDidLoad(error: NSError?) {
        super.objectsDidLoad(error)
        
//        print("objects did load")
//        print(self.objects!.count)
    }
    
    override func queryForTable() -> PFQuery {
        let currentUser = PFUser.currentUser()
        //check for relational companies
        let query = PFQuery(className: "Posts")
        //finding the companies the user likes
        let relation = currentUser!.relationForKey("companies")
        //unfortunately this needs to be run on the main thread - we need the companies array before we are able to be sure what companies the user has liked
        do {
            let companies = try relation.query()?.findObjects() as! [Company]
                
            //now let's check the posts that correspond to the companies that the user is looking for
            query.whereKey("company", containedIn: companies)
            
            if self.segControl.selectedSegmentIndex == 0 {
                //if new is selected, order by new date
                query.orderByDescending("createdAt")
            } else {
                //else order by number of votes
                query.orderByDescending("votes")
            }
            //first checking cache, then the network
            query.cachePolicy = PFCachePolicy.CacheThenNetwork
        } catch _ {
            print("error finding companies")
        }
        print(query.hasCachedResult())
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let post = object as! Post
        
        
        let currentDate = NSDate()
        let postDate = post.createdAt
        let interval = currentDate.timeIntervalSinceDate(postDate!)
        var timePosted: String
        
        // news cell
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsViewCell") as! NewsViewCell
        
        // getting the title and images
        if let post = object as? Post {
            
            //Setting the post in the cell to the current post, important for saving relation to current user
            cell.post = post
            
            cell.postTitle.text = post.title
            
            if post.news {
                cell.newsLabel.text = "from \(post.post)"
            } else {
                cell.newsLabel.hidden = true
            }
            //TODO: It would probably be easier to save the posts the user likes to an array that he has and then play the posts again it than fetching the list of users for each post!
            //TODO: Do above, everything else is already rewritten. Fetch all the posts that the user likes!!
            let relationUp = post.relationForKey("upVotes")
            let queryUp = relationUp.query()
            queryUp?.findObjectsInBackgroundWithBlock({ (usersUp, error) -> Void in
                if error == nil {
                    let usersUpArray = usersUp as! [PFUser]
                    cell.numberOfVotes.text = "\(usersUpArray.count)"
                    for user in usersUpArray {
                        if user.username == PFUser.currentUser()!.username! {
                            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                cell.upTapped = true
                                let image = UIImage(named: "upArrowRed") as UIImage!
                                cell.upArrow.setImage(image, forState: .Normal)
                            })
                            break
                        }
                    }
                }
            })
            
            cell.companyImage.image = UIImage(named: "placeholder")
            cell.cellId = post.objectId!
            
            //Converting the timeintervals into meaningful chunks
            if interval < 3600 {
                timePosted = "\(Int(floor(interval/60))) minutes ago"
            } else if interval < 86400 {
                timePosted = "\(Int(floor(interval/3600))) hours ago"
            } else {
                timePosted = "\(Int(floor(interval/86400))) days ago"
            }
            
            cell.timePosted.text = timePosted
            
            
            //TODO: Attach company name & image file to the post.
            /* 
            The process of adding another query is very painful and slow. Instead, it would be easier to simply add a link to the imageURL and create a PFFile view from that. Can see how it pans out when changing post objects in Parse website and playing with it
            */
            //find associated company name & icon
            let retrieveCompany = PFQuery(className:"Companies")
            retrieveCompany.cachePolicy = .CacheThenNetwork
            if let companyId = post.company.objectId {
                retrieveCompany.whereKey("objectId", equalTo: companyId)
                retrieveCompany.findObjectsInBackgroundWithBlock {
                    (objects, error) -> Void in
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
                        print("Error: \(error!) \(error!.userInfo)")
                    }
                }
            }
            
        }
        
        return cell
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
            postPage.companyLogo = cell.icon as PFFile!
        }
    }
    
    //Segmented Control to switch between hot and new posts
    @IBAction func switchedType(sender: UISegmentedControl) {
        loadObjects()
        tableView.reloadData()
        tableView.reloadSections(NSIndexSet(index: 0), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    //pushing a new navcontroller onto navcontroller with modal view
    func createPost () {
        let createVC = storyboard?.instantiateViewControllerWithIdentifier("CreatePostVC") as! CreatePostVC
        let navController = UINavigationController(rootViewController: createVC)
        navigationController?.presentViewController(navController, animated: true, completion: nil)
    }


}

