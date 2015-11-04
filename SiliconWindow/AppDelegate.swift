//
//  AppDelegate.swift
//  SiliconWindow
//
//  Created by Julius Danek on 8/6/15.
//  Copyright (c) 2015 Julius Danek. All rights reserved.
//

import UIKit
import Parse
import Bolts


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

        // Initialize Parse.
        
        //Register subclasses
        Company.registerSubclass()
        Post.registerSubclass()
        Comment.registerSubclass()
//        User.registerSubclass()

        Parse.setApplicationId(Keys().appID,
            clientKey: Keys().clientID)

        signup()
        
        // [Optional] Track statistics around application opens.
        PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func signup() {
        print("signing up")
        //checking if there is a user cached
        let currentUser = PFUser.currentUser()
        if currentUser != nil {
            //simple return statements
            print("user still logged in")
            return
        } else {
            do {
                try PFUser.logInWithUsername(UIDevice.currentDevice().identifierForVendor!.UUIDString, password: "SiliconWindow")
            } catch _ {
                print("signing new user up")
                let user = PFUser()
                user.username = UIDevice.currentDevice().identifierForVendor!.UUIDString
                user.password = "SiliconWindow"
                do {
                    try user.signUp()
                } catch _ {
                    print("error signing in")
                }
                return
            }
            print("logged user in")
            return
        }
    }

}

