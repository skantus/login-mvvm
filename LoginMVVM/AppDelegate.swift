//
//  AppDelegate.swift
//  LoginMVVM
//
//  Created by Alejo Castaño on 07/11/2020.
//

import UIKit
import SwiftyBeaver

let log = SwiftyBeaver.self

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        setupSwiftyBeaver()
        
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
    
    private func setupSwiftyBeaver() {
        // add log destinations. at least one is needed!
        // log to Xcode Console
        let console = ConsoleDestination()
        // log to default swiftybeaver.log file
        let file = FileDestination()
        // to cloud
        let cloud = SBPlatformDestination(appID: "2kYOJ5",
                                          appSecret: "nugedUkvCnwts3LllqwwecaVrAjtixmQ",
                                          encryptionKey: "wbgmocxodQHnd9dbkr9SbbdizkvhuoEg")
        
        console.levelString.verbose = "💜 VERBOSE"
        console.levelString.debug = "💚 DEBUG"
        console.levelString.info = "💙 INFO"
        console.levelString.warning = "💛 WARNING"
        console.levelString.error = "❤️ ERROR"
        
        // use custom format and set console output to short time, log level & message
        console.format = "$DHH:mm:ss$d $L $M"
        // or use this for JSON output: console.format = "$J"
        
        // add the destinations to SwiftyBeaver
        log.addDestination(console)
        log.addDestination(file)
        log.addDestination(cloud)
    }
}

