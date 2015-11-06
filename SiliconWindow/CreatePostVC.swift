//
//  PostVC.swift
//  SiliconWindow
//
//  Created by Julius Danek on 9/1/15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import Foundation
import UIKit

class PostVC: UIViewController {
    
    //Outlets
    @IBOutlet weak var newsSwitch: UISwitch!
    @IBOutlet weak var segControl: UISegmentedControl!
    @IBOutlet weak var titleField: UITextField!
    @IBOutlet weak var textField: UITextView!
    @IBOutlet weak var newsLabel: UILabel!
    @IBOutlet weak var chatterLabel: UILabel!
    
    var company: Company!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Submit", style: .Plain, target: self, action: "submit")
        navigationItem.title = company.name
        
        newsSwitch.addTarget(self, action: "switchPost:", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    //switching between news and chatter
    func switchPost (switchState: UISwitch) {
        if switchState.on {
            chatterSegmenter(true)
//            UIView.transitionWithView(titleField, duration: 0.4, options: UIViewAnimationOptions.TransitionCrossDissolve, animations: nil, completion: { (success) -> Void in
//                if success {
//                    self.titleField.hidden = true
//                }
//            })
        } else {
            chatterSegmenter(false)
        }
    }
    
    //Configuring labels and segment control for switch
    func chatterSegmenter (chatter: Bool) {
        segControl.setEnabled(chatter, forSegmentAtIndex: 0)
        segControl.setEnabled(chatter, forSegmentAtIndex: 2)
        if chatter {
            chatterLabel.backgroundColor = UIColor(red:0.93, green:0.30, blue:0.36, alpha:1.0)
            chatterLabel.textColor = UIColor.whiteColor()
            newsLabel.textColor = UIColor.blackColor()
            newsLabel.backgroundColor = UIColor.clearColor()
        } else {
            newsLabel.backgroundColor = UIColor(red:0.93, green:0.30, blue:0.36, alpha:1.0)
            newsLabel.textColor = UIColor.whiteColor()
            chatterLabel.textColor = UIColor.blackColor()
            chatterLabel.backgroundColor = UIColor.clearColor()
            segControl.selectedSegmentIndex = 1
        }
    }
    
    func submit () {
        let newPost = Post()
        newPost.sentiment = segControl.selectedSegmentIndex
        newPost.company = company
        newPost.post = textField.text
        newPost.title = titleField.text!
        if newsSwitch.on {
            newPost.news = false
        } else {
            newPost.news = true
        }
        newPost.votes = 0
        newPost.saveInBackgroundWithBlock { (success, error) -> Void in
            if success {
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
    }
}