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

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        //barbutton item to create a post
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Compose, target: self, action: "createPost")
        
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
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        // Configure the PFQueryTableView
        self.parseClassName = "Companies"
        self.pullToRefreshEnabled = true
        self.paginationEnabled = false
        self.placeholderImage = UIImage(named: "placeholder")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func queryForTable() -> PFQuery {
        //query concerns companies
        var query = PFQuery(className: "Companies")
        
        //if searchbar text is active, query needs to change to search bar text
        if searchBar.text != "" {
            query.whereKey("searchText", matchesRegex: searchBar.text.lowercaseString, modifiers: "i")
        }
        
        //order by name
        query.orderByAscending("name")
        
        return query
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("CompanyViewCell") as! CompanyViewCell
        
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
        
        return cell
    }

    // MARK: Search Bar methods:
    
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
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        
        // Clear any search criteria
        searchBar.text = ""
        
        // Dismiss the keyboard
        searchBar.resignFirstResponder()
        
        // Force reload of table data
        self.loadObjects()
    }

}
