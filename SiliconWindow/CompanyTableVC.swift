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

class CompanyTableVC: PFQueryTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        var query = PFQuery(className: "Companies")
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
        /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
