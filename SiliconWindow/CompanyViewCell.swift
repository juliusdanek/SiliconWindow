//
//  CompanyViewCell.swift
//  SiliconWindow
//
//  Created by Matthew Sniff on 8/6/15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class CompanyViewCell: PFTableViewCell {
    
    //TODO: on left side, next to image, implement some measure of popularity -> number, or percentage, etc.
    
    //setting up outlets for company view cell. Image, name and location
    @IBOutlet weak var companyImage: PFImageView!
    @IBOutlet weak var companyName: UILabel!
    @IBOutlet weak var companyLocation: UILabel!

}
