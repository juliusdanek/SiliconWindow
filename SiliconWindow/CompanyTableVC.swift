//
//  CompanyTableVC.swift
//  SiliconWindow
//
//  Created by Julius Danek on 8/6/15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class CompanyTableVC: PFQueryTableViewController, UISearchBarDelegate {

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.bounces = true
        
        //barbutton item to submit a company
        switchBarButton(true)
        
        navigationItem.leftBarButtonItem = editButtonItem()
        
        self.tableView.contentOffset = CGPointMake(0, searchBar.frame.height)
        searchBar.hidden = true
        
        //setting delegate
        searchBar.delegate = self
    
        let logo = UIImage(named: "word_logo")
        let imageView = UIImageView(image:logo)
        let screenSize: CGRect = UIScreen.mainScreen().bounds
        imageView.frame = CGRectMake(0,0, 100, 50)
        self.navigationItem.titleView = imageView
        
    }
    
    override init(style: UITableViewStyle, className: String!) {
        super.init(style: style, className: className)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = "Companies"
        self.pullToRefreshEnabled = false
        self.paginationEnabled = false
        self.placeholderImage = UIImage(named: "placeholder")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func queryForTable() -> PFQuery {
        
        //if searchbar text is active, query needs to change to search bar text
        if searchBar.text != "" {
            //here the query actually accesses all companies and searches them
            let query = PFQuery(className: "Companies")
            //Looking for query with key that has a regular expression to ignore casing
            query.whereKey("searchText", matchesRegex: searchBar.text!.lowercaseString, modifiers: "i")
            //sort by name
            query.orderByAscending("name")
            return query
        } else {
            //whereas here it only shows the companies that the user added
            let currentUser = PFUser.currentUser()
            //check for relational companies
            let relation = currentUser!.relationForKey("companies")
            //return query
            if self.objects?.count == 0 {
                //TODO: Implement a label that tells user to add / search for companies.
            }
            return relation.query()!
        }
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let company = objectAtIndexPath(indexPath) as! Company
        if searchBar.text != "" {
            let currentUser = PFUser.currentUser()
            let relation = currentUser!.relationForKey("companies")
            relation.addObject(company)
            currentUser!.saveInBackgroundWithBlock({ (success, error) -> Void in
                if success {
                    let cell = tableView.cellForRowAtIndexPath(indexPath)
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        cell?.accessoryType = .Checkmark
                        tableView.deselectRowAtIndexPath(indexPath, animated: true)
                    })
                }
            })
        } else {
            // if not selecting new companies, load details of the companies that we already have 
            performSegueWithIdentifier("showDetail", sender: self)
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CompanyViewCell") as! CompanyViewCell
        
        //setting the placeholder image
        cell.companyImage.image = UIImage(named: "placeholder")
        
        //setting name, location and image
        if let company = object as? Company {
            cell.companyName.text = company.name
            cell.companyLocation.text = company.location
            //making sure that label fits
            cell.companyName.adjustsFontSizeToFitWidth = true
            
            //download image in background, provided there is one
            if company.imageFile != nil {
                cell.companyImage.file = company.imageFile
                cell.companyImage.loadInBackground()
            }
        }
        
        if searchBar.text == "" {
            cell.accessoryType = .DisclosureIndicator
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            //remove relationship, then reload table to show updated companies in table
            let company = objectAtIndexPath(indexPath) as! Company
            let currentUser = PFUser.currentUser()
            let relation = currentUser?.relationForKey("companies")
            relation?.removeObject(company)
            currentUser?.saveInBackgroundWithBlock({ (success, error) -> Void in
                if success {
                    self.loadObjects()
                }
            })
        }
    }
    
    //MARK: Button functions
    
    func add() {
        searchBar.hidden = false
        self.tableView.scrollRectToVisible(CGRectMake(0, 0, 1, 1), animated: true)
        switchBarButton(false)
    }
    
    func done() {
        UIView.animateWithDuration(0.5, animations: { () -> Void in
            self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0), atScrollPosition: UITableViewScrollPosition(rawValue: 0)!, animated: false)
        }) { (success) -> Void in
            if success {
                self.searchBar.resignFirstResponder()
                self.switchBarButton(true)
                //need to clear the searchBar text before calling loadObjects since the searchBar texts determines query
                self.searchBar.text = ""
                self.hideSearchBar()
                self.loadObjects()
            }
        }
    }
    
    func switchBarButton(adding: Bool) {
        if adding {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "add")
            navigationItem.leftBarButtonItem?.enabled = true
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Done, target: self, action: "done")
            navigationItem.leftBarButtonItem?.enabled = false
        }
    }
    
    //MARK: Seguing functions
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier! == "showDetail" {
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedCompany = objectAtIndexPath(indexPath) as! Company
            let companyDetail = segue.destinationViewController as! CompanyDetailVC
            companyDetail.company = selectedCompany
        }
    }

    // MARK: Search Bar methods:
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        switchBarButton(false)
        self.loadObjects()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Force reload of table data
        self.loadObjects()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Force reload of table data
        self.loadObjects()
    }
    
    
    //hide function. First it sets new bounds for the table, then in animates the transition and hides the searchbar when complete
    func hideSearchBar () {
        var newBounds = self.tableView.bounds
        if (self.tableView.bounds.origin.y < 44) {
            newBounds.origin.y = newBounds.origin.y + self.searchBar.bounds.size.height
            UIView.animateWithDuration(0.3, animations: { () -> Void in
                self.tableView.bounds = newBounds
            }, completion: { (success) -> Void in
                if success {
                    self.searchBar.hidden = true
                }
            })
        }
    }

}
