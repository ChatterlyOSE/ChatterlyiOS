//
//  AppDelegate.swift
//  Mast
//
//  Created by Shihab Mehboob on 11/09/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import UIKit
import SwiftyStoreKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        UNUserNotificationCenter.current().delegate = self
        
        #if !targetEnvironment(macCatalyst)
        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                        SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    GlobalStruct.iapPurchased = true
                    let center = UNUserNotificationCenter.current()
                    center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
                        DispatchQueue.main.async {
                            UserDefaults.standard.set(true, forKey: "pnmentions")
                            UserDefaults.standard.set(true, forKey: "pnlikes")
                            UserDefaults.standard.set(true, forKey: "pnboosts")
                            UserDefaults.standard.set(true, forKey: "pnfollows")
//                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                case .failed, .purchasing, .deferred:
                    break
                @unknown default:
                    break
                }
            }
        }
        #endif

//        UINavigationBar.appearance().shadowImage = UIImage()
//        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().backgroundColor = GlobalStruct.baseDarkTint
        UINavigationBar.appearance().barTintColor = UIColor(named: "baseBlack")
        UINavigationBar.appearance().tintColor = UIColor(named: "baseBlack")
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(named: "baseBlack")!]
        
        WatchSessionManager.sharedManager.startSession()
        
        return true
    }
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        if url.host == "success" {
            print("Response ==> \(url.absoluteString)")
            let x = url.absoluteString
            let y = x.split(separator: "=")
            GlobalStruct.authCode = y.last?.description ?? ""
            NotificationCenter.default.post(name: Notification.Name(rawValue: "logged"), object: nil)
            return true
        } else {
            return true
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // this only works when the app is active, the server should be setting the 'badge' field, as right now it's nil
//        print("notification badge - \(notification.request.content.badge ?? 0)")
//        let application = UIApplication.shared
//        if application.applicationState == .inactive || application.applicationState == .background {
//            if let co = notification.request.content.badge {
//                application.applicationIconBadgeNumber = Int(truncating: co)
//            } else {
//                application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
//            }
//        }
        completionHandler([.alert, .sound, .badge])
    }
    
//    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
//        let application = UIApplication.shared
//        if application.applicationState == .inactive || application.applicationState == .background {
//            application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
//        }
//    }
      
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let application = UIApplication.shared
        if application.applicationState == .inactive {
            if let userDefaults = UserDefaults(suiteName: "group.me.chatterly.mobile.wormhole") {
                if userDefaults.value(forKey: "notidpush") != nil {
                    if let id = userDefaults.value(forKey: "notidpush") as? Int64 {
                        GlobalStruct.curIDNoti = "\(id)"
                        if GlobalStruct.currentTab == 1 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "gotoidnoti1"), object: self)
                        } else if GlobalStruct.currentTab == 2 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "gotoidnoti2"), object: self)
                        } else if GlobalStruct.currentTab == 3 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "gotoidnoti3"), object: self)
                        } else if GlobalStruct.currentTab == 4 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "gotoidnoti4"), object: self)
                        } else if GlobalStruct.currentTab == 5 {
                            NotificationCenter.default.post(name: Notification.Name(rawValue: "gotoidnoti5"), object: self)
                        }
                    }
                    userDefaults.set(nil, forKey: "notidpush")
                }
            }
        }
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "refpush1"), object: nil)
        
        completionHandler()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        var state: PushNotificationState!
        let receiver = try! PushNotificationReceiver()
        let subscription = PushNotificationSubscription(endpoint: URL(string:"https://pushrelay1.your.org/relay-to/production/\(token)")!, alerts: PushNotificationAlerts.init(favourite: UserDefaults.standard.object(forKey: "pnlikes") as? Bool ?? true, follow: UserDefaults.standard.object(forKey: "pnfollows") as? Bool ?? true, mention: UserDefaults.standard.object(forKey: "pnmentions") as? Bool ?? true, reblog: UserDefaults.standard.object(forKey: "pnboosts") as? Bool ?? true))
        let deviceToken = PushNotificationDeviceToken(deviceToken: deviceToken)
        state = PushNotificationState(receiver: receiver, subscription: subscription, deviceToken: deviceToken)
        PushNotificationReceiver.setState(state: state)
        #if DEBUG
        let requestParams = PushNotificationSubscriptionRequest(endpoint: "https://pushrelay-mast1-dev.your.org/relay-to/development/\(token)", receiver: receiver, alerts: PushNotificationAlerts.init(favourite: UserDefaults.standard.object(forKey: "pnlikes") as? Bool ?? true, follow: UserDefaults.standard.object(forKey: "pnfollows") as? Bool ?? true, mention: UserDefaults.standard.object(forKey: "pnmentions") as? Bool ?? true, reblog: UserDefaults.standard.object(forKey: "pnboosts") as? Bool ?? true))
        #else
        let requestParams = PushNotificationSubscriptionRequest(endpoint: "https://pushrelay-mast1.your.org/relay-to/production/\(token)", receiver: receiver, alerts: PushNotificationAlerts.init(favourite: UserDefaults.standard.object(forKey: "pnlikes") as? Bool ?? true, follow: UserDefaults.standard.object(forKey: "pnfollows") as? Bool ?? true, mention: UserDefaults.standard.object(forKey: "pnmentions") as? Bool ?? true, reblog: UserDefaults.standard.object(forKey: "pnboosts") as? Bool ?? true))
        #endif
        let url = URL(string: "https://\(GlobalStruct.currentInstance.returnedText)/api/v1/push/subscription")!
        let session = URLSession.shared
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let jsonEncoder = JSONEncoder()
        do {
            let jsonData = try jsonEncoder.encode(requestParams)
            request.httpBody = jsonData
        }
        catch {
            print(error.localizedDescription)
        }
        request.setValue("Bearer \(GlobalStruct.currentInstance.accessToken)", forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        let task = session.dataTask(with: request as URLRequest, completionHandler: { data, response, error in
            guard error == nil else {
                let requestParams2 = PushNotificationSubscriptionRequest(endpoint: "https://pushrelay-mast1.your.org/relay-to/development/\(token)", receiver: receiver, alerts: PushNotificationAlerts.init(favourite: UserDefaults.standard.object(forKey: "pnlikes") as? Bool ?? true, follow: UserDefaults.standard.object(forKey: "pnfollows") as? Bool ?? true, mention: UserDefaults.standard.object(forKey: "pnmentions") as? Bool ?? true, reblog: UserDefaults.standard.object(forKey: "pnboosts") as? Bool ?? true))
                let url2 = URL(string: "https://\(GlobalStruct.currentInstance.returnedText)/api/v1/push/subscription")!
                let session2 = URLSession.shared
                var request2 = URLRequest(url: url2)
                request2.httpMethod = "POST"
                let jsonEncoder2 = JSONEncoder()
                do {
                    let jsonData = try jsonEncoder2.encode(requestParams2)
                    request2.httpBody = jsonData
                }
                catch {
                    print(error.localizedDescription)
                }
                request2.setValue("Bearer \(GlobalStruct.currentInstance.accessToken)", forHTTPHeaderField: "Authorization")
                request2.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request2.addValue("application/json", forHTTPHeaderField: "Accept")
                let task2 = session2.dataTask(with: request2 as URLRequest, completionHandler: { data, response, error in
                    guard error == nil else {
                        return
                    }
                    guard let data = data else {
                        return
                    }
                    do {
                        if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                            print(json)
                        }
                    } catch let error {
                        print(error.localizedDescription)
                    }
                })
                task2.resume()
                return
                
            }
            guard let data = data else {
                return
            }
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any] {
                    print(json)
                }
            } catch let error {
                print(error.localizedDescription)
            }
        })
        task.resume()
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        if options.userActivities.first?.activityType == "me.chatterly.mobile.openComposer" {
            return UISceneConfiguration(name: "New Configuration", sessionRole: connectingSceneSession.role)
        }
        if options.userActivities.first?.activityType == "me.chatterly.mobile.openComposer2" {
            return UISceneConfiguration(name: "New Configuration 2", sessionRole: connectingSceneSession.role)
        }
        if options.userActivities.first?.activityType == "me.chatterly.mobile.openSettings" {
            return UISceneConfiguration(name: "New Configuration 3", sessionRole: connectingSceneSession.role)
        }
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    @objc func supportPage() {
        let url = URL(string: "https://www.thebluebird.app")!
        UIApplication.shared.openURL(url)
    }
    
    override func buildMenu(with builder: UIMenuBuilder) {
        super.buildMenu(with: builder)
        
        builder.remove(menu: .edit)
        builder.remove(menu: .format)
        builder.replaceChildren(ofMenu: .help) { oldChildren in
            var newChildren = oldChildren
            let newGameItem = UIKeyCommand(input: "", modifierFlags: [], action: #selector(supportPage))
            newGameItem.title = "Support"
            newChildren.remove(at: 0)
            newChildren.insert(newGameItem, at: 0)
            return newChildren
        }
        
        let command1 = UIKeyCommand(input: "N", modifierFlags: [.command], action: #selector(FirstViewController().compose))
        command1.title =  "New Toot".localized
        let command2 = UIKeyCommand(input: "F", modifierFlags: [.command], action: #selector(FirstViewController().search))
        command2.title =  "Search".localized
        let command3 = UIKeyCommand(input: ";", modifierFlags: [.command], action: #selector(FirstViewController().settings))
        command3.title =  "Settings".localized
        let formatDataMenuC = UIMenu(title: "Copy", image: nil, identifier: UIMenu.Identifier("format2"), options: .displayInline, children: [command1, command2, command3])
        builder.insertChild(formatDataMenuC, atStartOfMenu: .file)
    }
    
}
