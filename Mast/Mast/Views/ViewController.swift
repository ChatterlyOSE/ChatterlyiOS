//
//  ViewController.swift
//  Mast
//
//  Created by Shihab Mehboob on 11/09/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import UIKit
import CoreHaptics
import SafariServices
import SwiftyStoreKit

class ViewController: UITabBarController, UITabBarControllerDelegate {
    
    public var isSplitOrSlideOver: Bool {
        let windows = UIApplication.shared.windows
        for x in windows {
            if let z = self.view.window {
                if x == z {
                    if x.frame.width == x.screen.bounds.width || x.frame.width == x.screen.bounds.height {
                        return false
                    } else {
                        return true
                    }
                }
            }
        }
        return false
    }
//    var engine: CHHapticEngine?
    
    var tabOne = UINavigationController()
    var tabTwo = UINavigationController()
    var tabThree = UINavigationController()
    var tabFour = UINavigationController()
    var tabFive = UINavigationController()
    
    var firstView = FirstViewController()
    var secondView = SecondViewController()
    var thirdView = ThirdViewController()
    var fourthView = FourthViewController()
    var fifthView = FifthViewController()
    
    var statusBarView = UIView()
    var safariVC: SFSafariViewController?
    var statusBar = UIView()
    
    @objc func notifChangeTint() {
        self.statusBar.backgroundColor = GlobalStruct.baseDarkTint
        self.createTabBar()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        statusBar.frame = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
    }
    
    func openLink() {
//        #if targetEnvironment(macCatalyst)
//        NSWorkspace.shared.openURL(GlobalStruct.tappedURL!)
//        #elseif !targetEnvironment(macCatalyst)
        if UserDefaults.standard.value(forKey: "sync-chosenBrowser") as? Int == 0 {
            UIApplication.shared.openURL(GlobalStruct.tappedURL!)
        }
        if UserDefaults.standard.value(forKey: "sync-chosenBrowser") as? Int == 1 {
            let newLink = String(String(GlobalStruct.tappedURL?.absoluteString.replacingOccurrences(of: "https://", with: "googlechrome://") ?? "").replacingOccurrences(of: "http://", with: "googlechrome://"))
            if UIApplication.shared.canOpenURL(URL(string: newLink)!) {
                UIApplication.shared.openURL(URL(string: newLink)!)
            } else {
                UIApplication.shared.openURL(GlobalStruct.tappedURL!)
            }
        }
        if UserDefaults.standard.value(forKey: "sync-chosenBrowser") as? Int == 2 {
            let newLink = String(String(GlobalStruct.tappedURL?.absoluteString.replacingOccurrences(of: "https://", with: "firefox://open-url?url=https://") ?? "").replacingOccurrences(of: "http://", with: "firefox://open-url?url=http://"))
            if UIApplication.shared.canOpenURL(URL(string: newLink)!) {
                UIApplication.shared.openURL(URL(string: newLink)!)
            } else {
                UIApplication.shared.openURL(GlobalStruct.tappedURL!)
            }
        }
        if UserDefaults.standard.value(forKey: "sync-chosenBrowser") as? Int == 3 {
            let newLink = String(String(GlobalStruct.tappedURL?.absoluteString.replacingOccurrences(of: "https://", with: "opera://open-url?url=https://") ?? "").replacingOccurrences(of: "http://", with: "opera://open-url?url=http://"))
            if UIApplication.shared.canOpenURL(URL(string: newLink)!) {
                UIApplication.shared.openURL(URL(string: newLink)!)
            } else {
                UIApplication.shared.openURL(GlobalStruct.tappedURL!)
            }
        }
        if UserDefaults.standard.value(forKey: "sync-chosenBrowser") as? Int == 4 {
            let newLink = String(String(GlobalStruct.tappedURL?.absoluteString.replacingOccurrences(of: "https://", with: "dolphin://") ?? "").replacingOccurrences(of: "http://", with: "dolphin://"))
            if UIApplication.shared.canOpenURL(URL(string: newLink)!) {
                UIApplication.shared.openURL(URL(string: newLink)!)
            } else {
                UIApplication.shared.openURL(GlobalStruct.tappedURL!)
            }
        }
        if UserDefaults.standard.value(forKey: "sync-chosenBrowser") as? Int == 5 {
            let newLink = String(String(GlobalStruct.tappedURL?.absoluteString.replacingOccurrences(of: "https://", with: "brave://open-url?url=https://") ?? "").replacingOccurrences(of: "http://", with: "brave://open-url?url=http://"))
            if UIApplication.shared.canOpenURL(URL(string: newLink)!) {
                UIApplication.shared.openURL(URL(string: newLink)!)
            } else {
                UIApplication.shared.openURL(GlobalStruct.tappedURL!)
            }
        }
        if UserDefaults.standard.value(forKey: "sync-chosenBrowser") as? Int == 6 {
            if let x = GlobalStruct.tappedURL {
                self.safariVC = SFSafariViewController(url: x)
                getTopMostViewController()?.present(self.safariVC!, animated: true, completion: nil)
            }
        }
//        #endif
    }
    
    func getTopMostViewController() -> UIViewController? {
        var topMostViewController = UIApplication.shared.keyWindow?.rootViewController
        while let presentedViewController = topMostViewController?.presentedViewController {
            topMostViewController = presentedViewController
        }
        return topMostViewController
    }
    
    @objc func viewNotifications() {
        self.viewControllers?.last?.tabBarController?.selectedIndex = 1
    }
    
    @objc func viewMessages() {
        self.viewControllers?.last?.tabBarController?.selectedIndex = 2
    }
    
    @objc func viewProfile() {
        self.viewControllers?.last?.tabBarController?.selectedIndex = 4
    }
    
    @objc func notifChangeBG() {
        GlobalStruct.baseDarkTint = (UserDefaults.standard.value(forKey: "sync-startDarkTint") == nil || UserDefaults.standard.value(forKey: "sync-startDarkTint") as? Int == 0) ? UIColor(named: "baseWhite")! : UIColor(named: "baseWhite2")!
        self.view.backgroundColor = GlobalStruct.baseDarkTint
        self.tabBar.barTintColor = GlobalStruct.baseDarkTint
        self.navigationController?.navigationBar.backgroundColor = GlobalStruct.baseDarkTint
        self.navigationController?.navigationBar.barTintColor = GlobalStruct.baseDarkTint
    }
    
    func showNotifBanner(_ title: String, subtitle: String, style: BannerStyle) {
        if UserDefaults.standard.value(forKey: "switchbanners") as? Bool == true {
            let banner = FloatingNotificationBanner(title: title, subtitle: subtitle, style: style)
            if UserDefaults.standard.value(forKey: "sync-haptics") as? Int == 0 {
                banner.haptic = .medium
            } else {
                banner.haptic = .none
            }
            banner.show(bannerPosition: .top,
                        queue: NotificationBannerQueue(maxBannersOnScreenSimultaneously: 1),
                        cornerRadius: 8,
                        shadowColor: UIColor.black.withAlphaComponent(0.25),
                        shadowBlurRadius: 14,
                        shadowEdgeInsets: UIEdgeInsets(top: 8, left: 8, bottom: 0, right: 8))
        }
    }
    
    func receiptValidation() {
        let appleValidator = AppleReceiptValidator(service: .production, sharedSecret: "43b5e274d35e4357b706e1ecfd7fa17a")
        SwiftyStoreKit.verifyReceipt(using: appleValidator, forceRefresh: false) { result in
            switch result {
            case .success(let receipt):
                print("Verify receipt success")
                
                let purchaseResult0 = SwiftyStoreKit.verifySubscription(
                    ofType: .autoRenewable,
                    productId: "me.chatterly.mobile.months",
                    inReceipt: receipt)
                switch purchaseResult0 {
                case .purchased(let expiryDate, let items):
                    print("is valid until \(expiryDate)\n\(items)\n")
                    GlobalStruct.iapPurchased = true
                case .expired(let expiryDate, let items):
                    print("is expired since \(expiryDate)\n\(items)\n")
                case .notPurchased:
                    print("The user has never purchased")
                }
                
                let purchaseResult2 = SwiftyStoreKit.verifyPurchase(
                    productId: "me.chatterly.mobile.lifes",
                    inReceipt: receipt)
                switch purchaseResult2 {
                case .purchased:
                    print("purchased")
                    GlobalStruct.iapPurchased = true
                case .notPurchased:
                    print("The user has never purchased")
                }
                
            case .error(let error):
                print("Verify receipt failed: \(error)")
                let appleValidator2 = AppleReceiptValidator(service: .sandbox, sharedSecret: "43b5e274d35e4357b706e1ecfd7fa17a")
                SwiftyStoreKit.verifyReceipt(using: appleValidator2, forceRefresh: false) { result in
                    switch result {
                    case .success(let receipt):
                        print("Verify receipt success sandbox")
                        
                        let purchaseResult0 = SwiftyStoreKit.verifySubscription(
                            ofType: .autoRenewable,
                            productId: "me.chatterly.mobile.months",
                            inReceipt: receipt)
                        switch purchaseResult0 {
                        case .purchased(let expiryDate, let items):
                            print("is valid until \(expiryDate)\n\(items)\n")
                            GlobalStruct.iapPurchased = true
                        case .expired(let expiryDate, let items):
                            print("is expired since \(expiryDate)\n\(items)\n")
                        case .notPurchased:
                            print("The user has never purchased")
                        }
                        
                        let purchaseResult2 = SwiftyStoreKit.verifyPurchase(
                            productId: "me.chatterly.mobile.lifes",
                            inReceipt: receipt)
                        switch purchaseResult2 {
                        case .purchased:
                            print("purchased")
                            GlobalStruct.iapPurchased = true
                        case .notPurchased:
                            print("The user has never purchased")
                        }
                        
                    case .error(let error):
                        print("Verify receipt failed: \(error)")
                        GlobalStruct.iapPurchased = false
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = GlobalStruct.baseDarkTint
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.addTapped), name: NSNotification.Name(rawValue: "addTapped"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notifChangeTint), name: NSNotification.Name(rawValue: "notifChangeTint"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewNotifications), name: NSNotification.Name(rawValue: "viewNotifications"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewMessages), name: NSNotification.Name(rawValue: "viewMessages"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.viewProfile), name: NSNotification.Name(rawValue: "viewProfile"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notifChangeBG), name: NSNotification.Name(rawValue: "notifChangeBG"), object: nil)
        
        self.createTabBar()
        self.tabBar.barTintColor = GlobalStruct.baseDarkTint
        self.tabBar.isTranslucent = true
        
        if UserDefaults.standard.value(forKey: "sync-startTint") == nil {
            UserDefaults.standard.set(0, forKey: "sync-startTint")
            GlobalStruct.baseTint = GlobalStruct.arrayCols[0]
        } else {
            if let x = UserDefaults.standard.value(forKey: "sync-startTint") as? Int {
                GlobalStruct.baseTint = GlobalStruct.arrayCols[x]
            }
        }
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(tabButtonItemLongPressed(_:)))
        longPressRecognizer.minimumPressDuration = 0.4
        self.tabBar.addGestureRecognizer(longPressRecognizer)
    }

    @objc func tabButtonItemLongPressed(_ recognizer: UILongPressGestureRecognizer) {
        guard recognizer.state == .began else { return }
        guard let tabBar = recognizer.view as? UITabBar else { return }
        guard let tabBarItems = tabBar.items else { return }
        guard let viewControllers = viewControllers else { return }
        guard tabBarItems.count == viewControllers.count else { return }

        let loc = recognizer.location(in: tabBar)

        for (index, item) in tabBarItems.enumerated() {
            guard let view = item.value(forKey: "view") as? UIView else { continue }
            guard view.frame.contains(loc) else { continue }

            if let _ = viewControllers[index] as? UINavigationController {
                if index == 0 {
                    self.show(UINavigationController(rootViewController: TootViewController()), sender: self)
                }
                if index == 1 {
                    self.show(UINavigationController(rootViewController: TootViewController()), sender: self)
                }
                if index == 2 {
                    self.show(UINavigationController(rootViewController: TootViewController()), sender: self)
                }
                if index == 3 {
                    self.viewControllers?.last?.tabBarController?.selectedIndex = 3
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "searchTapped"), object: self)
                }
                if index == 4 {
                    self.displayAccounts()
                }
            }

            break
        }
    }
    
    func displayAccounts() {
        let instances = InstanceData.getAllInstances()
        let curr = InstanceData.getCurrentInstance()
        let alert = UIAlertController(title: "All Accounts".localized, message: nil, preferredStyle: .actionSheet)
        var count = 0
        for (z, x) in Account.getAccounts().enumerated() {
            var instance: InstanceData? = nil
            if InstanceData.getAllInstances().count == 0 {} else {
                instance = InstanceData.getAllInstances()[z]
            }
            let instanceAndAccount = "@\(instance?.returnedText ?? "")"
            
            let op1 = UIAlertAction(title: "\(x.displayName) (@\(x.username)\(instanceAndAccount))", style: .default , handler:{ (UIAlertAction) in
                if curr?.clientID == instances[z].clientID {
                    
                } else {
                    InstanceData.setCurrentInstance(instance: instances[z])
                    GlobalStruct.client = Client(
                        baseURL: "https://\(instances[z].returnedText)",
                        accessToken: instances[z].accessToken
                    )
                    FirstViewController().initialFetches()
                    UIApplication.shared.keyWindow?.rootViewController = ViewController()
                }
            })
            if curr?.clientID == instances[z].clientID {
                op1.setValue(UIImage(systemName: "checkmark.circle.fill")!, forKey: "image")
            } else {
                op1.setValue(UIImage(systemName: "circle")!, forKey: "image")
            }
            op1.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            alert.addAction(op1)
            count += 1
        }
        
        alert.addAction(UIAlertAction(title: "Dismiss".localized, style: .cancel , handler:{ (UIAlertAction) in
            
        }))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        let messageText = NSMutableAttributedString(
            string: "All Accounts".localized,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
            ]
        )
        alert.setValue(messageText, forKey: "attributedTitle")
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        if UserDefaults.standard.value(forKey: "sync-haptics") as? Int == 0 {
            let selectionFeedbackGenerator = UISelectionFeedbackGenerator()
            selectionFeedbackGenerator.selectionChanged()
        }
        if item.tag == 1 && GlobalStruct.currentTab == 1 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollTop1"), object: nil)
        }
        if item.tag == 2 && GlobalStruct.currentTab == 2 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollTop2"), object: nil)
        }
        if item.tag == 3 && GlobalStruct.currentTab == 3 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollTop3"), object: nil)
        }
        if item.tag == 4 && GlobalStruct.currentTab == 4 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollTop4"), object: nil)
        }
        if item.tag == 5 && GlobalStruct.currentTab == 5 {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "scrollTop5"), object: nil)
        }
    }
    
    @objc func addTapped() {
        self.show(UINavigationController(rootViewController: TootViewController()), sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        
        if UserDefaults.standard.value(forKey: "firstIAP") as? Int == 1 {
            self.receiptValidation()
        }
        
        statusBar.frame = UIApplication.shared.windows.first?.windowScene?.statusBarManager?.statusBarFrame ?? CGRect(x: 0, y: 0, width: 0, height: 0)
        statusBar.backgroundColor = GlobalStruct.baseDarkTint
        self.view.addSubview(statusBar)
    }
    
    func createTabBar() {
        DispatchQueue.main.async {
            let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .regular)
            
            let im1 = UIImage(systemName: "text.bubble", withConfiguration: symbolConfig)?.withTintColor(UIColor(named: "baseBlack")!.withAlphaComponent(0.45), renderingMode: .alwaysOriginal)
            let im1b = UIImage(systemName: "text.bubble.fill", withConfiguration: symbolConfig)?.withTintColor(GlobalStruct.baseTint.withAlphaComponent(1), renderingMode: .alwaysOriginal)
            
            let im2 = UIImage(systemName: "bell", withConfiguration: symbolConfig)?.withTintColor(UIColor(named: "baseBlack")!.withAlphaComponent(0.45), renderingMode: .alwaysOriginal)
            let im2b = UIImage(systemName: "bell.fill", withConfiguration: symbolConfig)?.withTintColor(GlobalStruct.baseTint.withAlphaComponent(1), renderingMode: .alwaysOriginal)
            
            let im3 = UIImage(systemName: "paperplane", withConfiguration: symbolConfig)?.withTintColor(UIColor(named: "baseBlack")!.withAlphaComponent(0.45), renderingMode: .alwaysOriginal)
            let im3b = UIImage(systemName: "paperplane.fill", withConfiguration: symbolConfig)?.withTintColor(GlobalStruct.baseTint.withAlphaComponent(1), renderingMode: .alwaysOriginal)
            
            let im4 = UIImage(systemName: "magnifyingglass.circle", withConfiguration: symbolConfig)?.withTintColor(UIColor(named: "baseBlack")!.withAlphaComponent(0.45), renderingMode: .alwaysOriginal)
            let im4b = UIImage(systemName: "magnifyingglass.circle.fill", withConfiguration: symbolConfig)?.withTintColor(GlobalStruct.baseTint.withAlphaComponent(1), renderingMode: .alwaysOriginal)
            
            let im5 = UIImage(systemName: "person.crop.circle", withConfiguration: symbolConfig)?.withTintColor(UIColor(named: "baseBlack")!.withAlphaComponent(0.45), renderingMode: .alwaysOriginal)
            let im5b = UIImage(systemName: "person.crop.circle.fill", withConfiguration: symbolConfig)?.withTintColor(GlobalStruct.baseTint.withAlphaComponent(1), renderingMode: .alwaysOriginal)
            
            // Create Tab one
            self.tabOne = UINavigationController(rootViewController: self.firstView)
            self.tabOne.tabBarItem = UITabBarItem(title: "Feed".localized, image: im1, selectedImage: im1b)
            self.tabOne.navigationBar.backgroundColor = GlobalStruct.baseDarkTint
            self.tabOne.navigationBar.barTintColor = GlobalStruct.baseDarkTint
            self.tabOne.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: GlobalStruct.baseTint], for: .selected)
            self.tabOne.accessibilityLabel = "Feed".localized
            self.tabOne.tabBarItem.tag = 1
            
            // Create Tab two
            self.tabTwo = UINavigationController(rootViewController: self.secondView)
            self.tabTwo.tabBarItem = UITabBarItem(title: "Notifications".localized, image: im2, selectedImage: im2b)
            self.tabTwo.navigationBar.backgroundColor = GlobalStruct.baseDarkTint
            self.tabTwo.navigationBar.barTintColor = GlobalStruct.baseDarkTint
            self.tabTwo.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: GlobalStruct.baseTint], for: .selected)
            self.tabTwo.accessibilityLabel = "Notifications".localized
            self.tabTwo.tabBarItem.tag = 2
            
            // Create Tab three
            self.tabThree = UINavigationController(rootViewController: self.thirdView)
            self.tabThree.tabBarItem = UITabBarItem(title: "Messages".localized, image: im3, selectedImage: im3b)
            self.tabThree.navigationBar.backgroundColor = GlobalStruct.baseDarkTint
            self.tabThree.navigationBar.barTintColor = GlobalStruct.baseDarkTint
            self.tabThree.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: GlobalStruct.baseTint], for: .selected)
            self.tabThree.accessibilityLabel = "Messages".localized
            self.tabThree.tabBarItem.tag = 3
            
            // Create Tab four
            self.tabFour = UINavigationController(rootViewController: self.fourthView)
            self.tabFour.tabBarItem = UITabBarItem(title: "Explore".localized, image: im4, selectedImage: im4b)
            self.tabFour.navigationBar.backgroundColor = GlobalStruct.baseDarkTint
            self.tabFour.navigationBar.barTintColor = GlobalStruct.baseDarkTint
            self.tabFour.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: GlobalStruct.baseTint], for: .selected)
            self.tabFour.accessibilityLabel = "Explore".localized
            self.tabFour.tabBarItem.tag = 4
            
            // Create Tab five
            self.tabFive = UINavigationController(rootViewController: self.fifthView)
            self.tabFive.tabBarItem = UITabBarItem(title: "Profile".localized, image: im5, selectedImage: im5b)
            self.tabFive.navigationBar.backgroundColor = GlobalStruct.baseDarkTint
            self.tabFive.navigationBar.barTintColor = GlobalStruct.baseDarkTint
            self.tabFive.tabBarItem.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: GlobalStruct.baseTint], for: .selected)
            self.tabFive.accessibilityLabel = "Profile".localized
            self.tabFive.tabBarItem.tag = 5
            
            self.viewControllers = [self.tabOne, self.tabTwo, self.tabThree, self.tabFour, self.tabFive]
        }
    }
    
}

// EXTENSIONS

extension String {
    var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: "")
    }
}

extension Array where Element: Equatable {
    func removeDuplicates() -> [Element] {
        var result = [Element]()
        for value in self {
            if result.contains(value) == false {
                result.append(value)
            }
        }
        return result
    }
}

public func timeAgoSince(_ date: Date) -> String {
    let calendar = Calendar.current
    let now = Date()
    let unitFlags: NSCalendar.Unit = [.second, .minute, .hour, .day, .weekOfYear, .month, .year]
    let components = (calendar as NSCalendar).components(unitFlags, from: date, to: now, options: [])
    
    if let year = components.year, year >= 2 {
        return "\(year)y"
    }
    
    if let year = components.year, year >= 1 {
        return "1y"
    }
    
    if let month = components.month, month >= 2 {
        return "\(month)M"
    }
    
    if let month = components.month, month >= 1 {
        return "1M"
    }
    
    if let week = components.weekOfYear, week >= 2 {
        return "\(week)w"
    }
    
    if let week = components.weekOfYear, week >= 1 {
        return "1w"
    }
    
    if let day = components.day, day >= 2 {
        return "\(day)d"
    }
    
    if let day = components.day, day >= 1 {
        return "1d"
    }
    
    if let hour = components.hour, hour >= 2 {
        return "\(hour)h"
    }
    
    if let hour = components.hour, hour >= 1 {
        return "1h"
    }
    
    if let minute = components.minute, minute >= 2 {
        return "\(minute)m"
    }
    
    if let minute = components.minute, minute >= 1 {
        return "1m"
    }
    
    if let second = components.second, second >= 3 {
        return "\(second)s"
    }
    
    return "Just now"
}

let imageCache = NSCache<NSString, AnyObject>()

extension NSTextAttachment {
    func loadImageUsingCache(withUrl urlString : String) {
        let url = URL(string: urlString)
        self.image = nil
        
        // check cached image
        if let cachedImage = imageCache.object(forKey: urlString as NSString) as? UIImage {
            self.image = cachedImage
            return
        }
        
        // if not, download image from url
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
            if error != nil {
                print(error!)
                return
            }
            
            DispatchQueue.main.async {
                if let image = UIImage(data: data!) {
                    self.image = image
                    imageCache.setObject(image, forKey: urlString as NSString)
                }
            }
            
        }).resume()
    }
}

extension UITextView {
    #if targetEnvironment(macCatalyst)
    @objc(_focusRingType)
    var focusRingType: UInt {
        return 1
    }
    #endif
}

extension UITextField {
    #if targetEnvironment(macCatalyst)
    @objc(_focusRingType)
    var focusRingType: UInt {
        return 1
    }
    #endif
}

extension TimeInterval {
    func stringFromTimeInterval() -> String {
        let time = NSInteger(self)
        let seconds = time % 60
        let minutes = (time / 60) % 60
//        let hours = (time / 3600)
        return String(format: "%0.2d:%0.2d",minutes,seconds)
    }
}

extension UITableView {
    func hasRowAtIndexPath(indexPath: NSIndexPath) -> Bool {
        return indexPath.section < self.numberOfSections && indexPath.row < self.numberOfRows(inSection: indexPath.section)
    }
}
