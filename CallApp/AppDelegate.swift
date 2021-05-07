//
//  AppDelegate.swift
//  CallApp
//
//  Created by hau on 4/5/21.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var providerDelegate: ProviderDelegate!
    let callManager = CallManager()

    class var shared: AppDelegate {
        return UIApplication.shared.delegate as! AppDelegate
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        FirebaseApp.configure()
        providerDelegate = ProviderDelegate(callManager: callManager)
        return true
    }
}

