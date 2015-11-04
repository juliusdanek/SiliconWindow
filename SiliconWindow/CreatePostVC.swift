//
//  FirstViewController.swift
//  SiliconWindow
//
//  Created by Julius Danek on 8/6/15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class CreatePostVC: PFQueryTableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.placeholderImage = UIImage(named: "placeholder")
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Cancel, target: self, action: "dismiss")
    }
    
    override func queryForTable() -> PFQuery {
        //here it only shows the companies that the user added
        let currentUser = PFUser.currentUser()
        //check for relational companies
        let relation = currentUser!.relationForKey("companies")
        //return query
        if self.objects?.count == 0 {
            //TODO: Implement a label that tells user to add / search for companies.
        }
        return relation.query()!
    }
    
    //functions to show tableviewcell
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath, object: PFObject?) -> PFTableViewCell? {
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CompanyViewCell") as! CompanyViewCell
        
        
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let destVC = segue.destinationViewController as! PostVC
        let indexPath = tableView.indexPathForSelectedRow!
        let selectedCompany = objectAtIndexPath(indexPath) as! Company
        destVC.company = selectedCompany
    }
    
    func dismiss () {
        dismissViewControllerAnimated(true, completion: nil)
    }
}

