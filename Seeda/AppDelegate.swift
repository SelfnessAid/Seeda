//
//  AppDelegate.swift
//  UPWorkApp
//
//  Created by Роман Макаров on 13.04.16.   
//  Copyright © 2016 Roman. All rights reserved.
//

import UIKit
import DropDown

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        UIApplication.sharedApplication().idleTimerDisabled = true
        let defaults = NSUserDefaults.standardUserDefaults()
        DropDown.startListeningToKeyboard()
        
        //Purchase
        defaults.setObject(true, forKey: "payed")
        //
        
        if (defaults.objectForKey("payed") == nil){
            defaults.setObject(false, forKey: "payed")
        }
        if (defaults.objectForKey("points") == nil){
            defaults.setObject([Point](), forKey: "points")
        }
        if (defaults.objectForKey("distance") as? String != "mi") {
            defaults.setObject("km", forKey: "distance")
        }
        if (defaults.objectForKey("language") == nil) {
            defaults.setObject("english", forKey: "language")
        }
        if (defaults.objectForKey("history") == nil) {
            defaults.setObject([Point](), forKey: "history")
        }
        if (defaults.objectForKey("SAFL") == nil) {    //SAFL = Show All Favorite Location
            defaults.setObject(false, forKey: "SAFL")
        }
        if (defaults.objectForKey("USR") == nil) {    //USR = Use the Same Route
            defaults.setObject(false, forKey: "USR")
        }
        if (defaults.objectForKey("lastPoint") == nil ) {
            defaults.setObject([Point](), forKey: "lastPoint")
        }
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }
    
    func application(application: UIApplication, handleOpenURL url: NSURL) -> Bool {
        let query = url.query
        if let query = query{
            let params = query.componentsSeparatedByString("&")
            let latitude = params[0].componentsSeparatedByString("=")[1]
            let longtitude = params[1].componentsSeparatedByString("=")[1]
            ViewController.startLat = latitude
            ViewController.startLong = longtitude
            ViewController.fromLink = true
        }
        return true
    }
    func application(application: UIApplication, openURL url: NSURL, sourceApplication: String?, annotation: AnyObject) -> Bool {
        let query = url.query
        
        if let query = query{
            let params = query.componentsSeparatedByString("&")
            let latitude = params[0].componentsSeparatedByString("=")[1]
            let longtitude = params[1].componentsSeparatedByString("=")[1]
            ViewController.startLat = latitude
            ViewController.startLong = longtitude
            ViewController.fromLink = true
        }
        return true
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


}

