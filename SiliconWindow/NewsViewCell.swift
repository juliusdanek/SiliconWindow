//
//  FeedViewCell.swift
//  SiliconWindow
//
//  Created by Matthew Sniff on 8/6/15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class NewsViewCell: PFTableViewCell {

    @IBOutlet weak var companyImage: PFImageView!
    @IBOutlet weak var companyName: UILabel!
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var timePosted: UILabel!
    @IBOutlet weak var numberOfComments: UILabel!
    @IBOutlet weak var numberOfVotes: UILabel!
}
