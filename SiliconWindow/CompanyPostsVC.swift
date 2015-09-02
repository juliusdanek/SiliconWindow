//
//  CompanyPostsVC.swift
//  SiliconWindow
//
//  Created by Julius Danek on 9/1/15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import Foundation
import ParseUI
import Parse
import UIKit

class CompanyPostsVC: PFQueryTableViewController, CompanyDetailVCDelegate {
    
    var company: Company?
    var queryType: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        queryType = "all"
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.parseClassName = "Posts"
        self.textKey = "post"
        self.pullToRefreshEnabled = false
        self.objectsPerPage = 20
        self.paginationEnabled = true
    }
    
    //query for table depending on what type is looked for (controlled by segmented control and delegate methods)
    override func queryForTable() -> PFQuery {
        var query = PFQuery(className: "Posts")
        query.whereKey("company", equalTo: company!)
        if queryType == "news" {
            query.whereKey("news", equalTo: true)
        } else if queryType == "chatter" {
            query.whereKey("news", equalTo: false)
        }
        query.orderByDescending("createdAt")
        return query
    }
    
    
    //MARK: Loading functions
    override func objectsWillLoad() {
        super.objectsWillLoad()
        loading = true
    }
    
    override func objectsDidLoad(error: NSError?) {
        super.objectsDidLoad(error)
        loading = false
    }
    
    //Delegate method to account for switches in segemented control
    func changeQuery(queryName: String) {
        clear()
        switch queryName {
            case "news":
                queryType = "news"
            case "chatter":
                queryType = "chatter"
            default:
                queryType = "all"
        }
        loadObjects()
    }
}