//
//  PostViewCell.swift
//  SiliconWindow
//
//  Created by Julius Danek on 8/6/15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PostViewCell: PFTableViewCell {
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var timePosted: UILabel!
    
    @IBOutlet weak var numberOfComments: UILabel!
    @IBOutlet weak var numberOfVotes: UILabel!
}