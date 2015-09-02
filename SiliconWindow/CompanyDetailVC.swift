//
//  CompanyDetailVC.swift
//  SiliconWindow
//
//  Created by Julius Danek on 9/1/15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import Foundation
import UIKit
import Parse
import ParseUI

protocol CompanyDetailVCDelegate {
    func changeQuery(queryName: String)
}

class CompanyDetailVC: UIViewController {
    
    var delegate: CompanyDetailVCDelegate?
    

    @IBOutlet weak var imageView: PFImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var urlLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var segControl: UISegmentedControl!
    
    var company: Company?
    
    //TODO: Not all companies have location or high concept pitches. Might need to be unwrapped
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentCompany = company {
            
            imageView.file = currentCompany.imageFile
            imageView.image = UIImage(named: "placeholder")
            imageView.loadInBackground()
            
            nameLabel.text = (currentCompany.name + " " + currentCompany.location!)
            
            //need to unwrap optionals - not all companies have all fields filled in
            if let cWeb = currentCompany.website {
                urlLabel.text = cWeb
            } else {
                urlLabel.hidden = true
            }
            
            if let cPitch = currentCompany.highConceptPitch {
                textView.text = cPitch
            } else {
                textView.text = "No company description available"
            }
        }
    }
    
    @IBAction func indexIsChanged(sender: UISegmentedControl) {
        switch segControl.selectedSegmentIndex {
            case 0:
                delegate?.changeQuery("all")
            case 1:
                delegate?.changeQuery("news")
            case 2:
                delegate?.changeQuery("chatter")
            default:
                delegate?.changeQuery("all")
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "postEmbed" {
            let companyPosts = segue.destinationViewController as! CompanyPostsVC
            companyPosts.company = company
            self.delegate = companyPosts
        }
    }
}