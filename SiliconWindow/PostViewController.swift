//
//  SecondViewController.swift
//  SiliconWindow
//
//  Created by Julius Danek on 8/6/15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class PostViewController: UIViewController {
    
    // public vars
    var postId: String = ""
    var companyLogo: PFFile = PFFile()
    var postTitle: String = ""
    
    // connections
    @IBOutlet var companyIcon: PFImageView!
    @IBOutlet var postText: UITextView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Details"
        println(postId)
        
        // set outlets
        postText.text = postTitle
        companyIcon.file = companyLogo
        companyIcon.loadInBackground()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

