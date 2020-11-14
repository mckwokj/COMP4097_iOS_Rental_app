//
//  AppDelegate.swift
//  EstateRental
//
//  Created by Man Chun Kwok on 3/11/2020.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    static var dataController: DataController?
    
//    func application(_ application: UIApplication, willFinishLaunchingWithOptions: [UIApplication.LaunchOptionsKey : Any]?) -> Bool {
//        print("willFinishLaunchingWithOptions")
//
//        dataController = DataController() {
//            print("Core Data stack has been initialized.")
//        }
//
//        return true
//    }
    
//    func application(_ application: UIApplication, handleEventsForBackgroundURLSession: String, completionHandler: () -> Void) {
//        
//        print("URLSession")
//        
//        AppDelegate.dataController = nil
//        
//        AppDelegate.dataController = DataController() {
//            print("Core Data stack has been initialized.")
//        }
//    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        AppDelegate.dataController = DataController() {
            print("Core Data stack has been initialized.")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

