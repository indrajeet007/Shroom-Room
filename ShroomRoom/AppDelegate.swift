//
//  AppDelegate.swift
//  ShroomRoom
//
//  Created by Indrajit Chavan on 10/05/19.
//  Copyright © 2019 Indrajit Chavan. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_: UIApplication, didFinishLaunchingWithOptions _: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        return true
    }
}
