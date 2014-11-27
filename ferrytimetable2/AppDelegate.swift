//
//  AppDelegate.swift
//  ferrytimetable2
//
//  Created by b123400 on 27/6/14.
//  Copyright (c) 2014 b123400. All rights reserved.
//

import UIKit
import Crashlytics
import FerryKit

let ApplicationDidRegisterUserNotification = "ApplicationDiDRegisterUserNotification"

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
                            
    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool {
        // Override point for customization after application launch.
        
        // Because some stupid compiler bug, we need to reference MasterViewController or else it will be ignored.
        MasterViewController.nothing()
        NSUserDefaults.standardUserDefaults().registerDefaults(["autoScroll":false])
        NSUserDefaults.standardUserDefaults().synchronize()
        
        // Crashlytics
        Crashlytics.startWithAPIKey("be3de76eb1918a93b4d68a8e87b983750d738aed")
        
        // Mixpanel
        Mixpanel.sharedInstanceWithToken("5f7ac8807b7080e6ad4c04811451f32f")
        
        let autoScroll = NSUserDefaults.standardUserDefaults().valueForKey("autoScroll") as Bool?
        let autoScrollString = autoScroll == true ? "true" : "false"
        Mixpanel.sharedInstance().track("autoScroll", properties: ["enabled":autoScrollString])
        
        let splitViewController = self.window!.rootViewController as UISplitViewController
        let navigationController = splitViewController.viewControllers[0] as UINavigationController
        splitViewController.delegate = navigationController.topViewController as MasterViewController
        splitViewController.preferredDisplayMode = UISplitViewControllerDisplayMode.AllVisible
        
        if let notification = launchOptions?[UIApplicationLaunchOptionsLocalNotificationKey] as? UILocalNotification {
            handleLocalNotification(notification)
        }
        
        return true
    }
    
    func application(application: UIApplication!,
        didReceiveLocalNotification notification: UILocalNotification!) {
           
        handleLocalNotification(notification)
    }
    
    func handleLocalNotification(notification:UILocalNotification) {
        let dict = notification.userInfo as [String:AnyObject]
        let ferry = Ferry.fromDict(dictionaryRepresentation: dict)
        let navController = self.window!.rootViewController!.storyboard!.instantiateViewControllerWithIdentifier("ferryNavigationController") as UINavigationController
        let controller = navController.topViewController as FerryViewController
        controller.ferry = ferry
        let delay = 0.5 * Double(NSEC_PER_SEC)
        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
        dispatch_after(time, dispatch_get_main_queue()) {
            self.window!.rootViewController!.presentViewController(navController, animated: true, completion: nil)
        }
    }
    
    func application(application: UIApplication!,
        didRegisterUserNotificationSettings notificationSettings: UIUserNotificationSettings!){
        
            NSNotificationCenter.defaultCenter().postNotificationName(ApplicationDidRegisterUserNotification, object: nil, userInfo: ["setting":notificationSettings])
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


}

