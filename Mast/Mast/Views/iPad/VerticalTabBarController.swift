//
//  VerticalTabBarController.swift
//  Mast
//
//  Created by Shihab Mehboob on 27/09/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit

class VerticalTabBarController: UIViewController {
    
    var button1 = UIButton()
    var button2 = UIButton()
    var button3 = UIButton()
    
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
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 21, weight: .regular)
        
        #if targetEnvironment(macCatalyst)
        self.button1.frame = CGRect(x: 10, y: 30, width: 60, height: 60)
        self.button2.frame = CGRect(x: 10, y: 100, width: 60, height: 60)
        self.button3.frame = CGRect(x: 10, y: 170, width: 60, height: 60)
        #elseif !targetEnvironment(macCatalyst)
        self.button1.frame = CGRect(x: 10, y: self.view.bounds.height - 90, width: 60, height: 60)
        self.button2.frame = CGRect(x: 10, y: self.view.bounds.height - 160, width: 60, height: 60)
        self.button3.frame = CGRect(x: 10, y: self.view.bounds.height - 230, width: 60, height: 60)
        #endif
        
        self.button1.backgroundColor = .clear
        self.button1.setImage(UIImage(systemName: "plus", withConfiguration: symbolConfig)?.withTintColor(UIColor(named: "baseBlack")!.withAlphaComponent(1), renderingMode: .alwaysOriginal), for: .normal)
        self.button1.adjustsImageWhenHighlighted = false
        self.button1.addTarget(self, action: #selector(self.compose), for: .touchUpInside)
        self.button1.accessibilityLabel = "Create".localized
        self.view.addSubview(self.button1)
        
        self.button2.backgroundColor = .clear
        self.button2.setImage(UIImage(systemName: "magnifyingglass", withConfiguration: symbolConfig)?.withTintColor(UIColor(named: "baseBlack")!.withAlphaComponent(1), renderingMode: .alwaysOriginal), for: .normal)
        self.button2.adjustsImageWhenHighlighted = false
        self.button2.addTarget(self, action: #selector(self.search), for: .touchUpInside)
        self.button2.accessibilityLabel = "Search".localized
        self.view.addSubview(self.button2)
        
        self.button3.backgroundColor = .clear
        self.button3.setImage(UIImage(systemName: "gear", withConfiguration: symbolConfig)?.withTintColor(UIColor(named: "baseBlack")!.withAlphaComponent(1), renderingMode: .alwaysOriginal), for: .normal)
        self.button3.adjustsImageWhenHighlighted = false
        self.button3.addTarget(self, action: #selector(self.settings), for: .touchUpInside)
        self.button3.accessibilityLabel = "Settings".localized
        self.view.addSubview(self.button3)
        
        var offset: Int = 0
        var tag: Int = 0
        for x in Account.getAccounts() {
            let b1 = UIButton()
            b1.frame = CGRect(x: 20, y: 30 + offset, width: 40, height: 40)
            b1.backgroundColor = UIColor.systemBackground
            b1.layer.cornerRadius = 20
            guard let imageURL = URL(string: x.avatar) else { return }
            b1.sd_setImage(with: imageURL, for: .normal, completed: nil)
            b1.layer.masksToBounds = true
            b1.tag = tag
            b1.addTarget(self, action: #selector(self.profileTapped), for: .touchUpInside)
            self.view.addSubview(b1)
            offset += 60
            tag += 1
        }
    }
    
    @objc func profileTapped(_ sender: UIButton) {
        DispatchQueue.main.async {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "updateLayout1"), object: nil)
            
            let instances = InstanceData.getAllInstances()
            if instances.isEmpty || Account.getAccounts().isEmpty {
                
            } else {
                let curr = InstanceData.getCurrentInstance()
                if curr?.clientID == instances[sender.tag].clientID {
                    
                } else {
                    InstanceData.setCurrentInstance(instance: instances[sender.tag])
                    GlobalStruct.client = Client(
                        baseURL: "https://\(instances[sender.tag].returnedText)",
                        accessToken: instances[sender.tag].accessToken
                    )
                    
                    NotificationCenter.default.post(name: Notification.Name(rawValue: "fromSidebar"), object: nil)
                    
                    #if targetEnvironment(macCatalyst)
                    let rootController = ColumnViewController()
                    let nav0 = VerticalTabBarController()
                    let nav1 = ScrollMainViewController()
                    
                    let nav01 = UINavigationController(rootViewController: FirstViewController())
                    let nav02 = UINavigationController(rootViewController: SecondViewController())
                    let nav03 = UINavigationController(rootViewController: ThirdViewController())
                    let nav04 = UINavigationController(rootViewController: FourthViewController())
                    let nav05 = UINavigationController(rootViewController: FifthViewController())
                    nav1.viewControllers = [nav01, nav02, nav03, nav04, nav05]
                    
                    rootController.viewControllers = [nav0, nav1]
                    UIApplication.shared.keyWindow?.rootViewController = rootController
                    UIApplication.shared.keyWindow?.makeKeyAndVisible()
                    #elseif !targetEnvironment(macCatalyst)
                    if UIDevice.current.userInterfaceIdiom == .pad && self.isSplitOrSlideOver == false {
                        let rootController = ColumnViewController()
                        let nav0 = VerticalTabBarController()
                        let nav1 = ScrollMainViewController()
                        
                        let nav01 = UINavigationController(rootViewController: FirstViewController())
                        let nav02 = UINavigationController(rootViewController: SecondViewController())
                        let nav03 = UINavigationController(rootViewController: ThirdViewController())
                        let nav04 = UINavigationController(rootViewController: FourthViewController())
                        let nav05 = UINavigationController(rootViewController: FifthViewController())
                        nav1.viewControllers = [nav01, nav02, nav03, nav04, nav05]
                        
                        rootController.viewControllers = [nav0, nav1]
                        UIApplication.shared.keyWindow?.rootViewController = rootController
                        UIApplication.shared.keyWindow?.makeKeyAndVisible()
                    } else {
                        UIApplication.shared.keyWindow?.rootViewController = ViewController()
                    }
                    #endif
                }
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "lighterBaseWhite")
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.compose), name: NSNotification.Name(rawValue: "composea"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.search), name: NSNotification.Name(rawValue: "searcha"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.settings), name: NSNotification.Name(rawValue: "settingsa"), object: nil)
    }
    
    @objc func settings() {
        #if targetEnvironment(macCatalyst)
        GlobalStruct.macWindow = 3
        let userActivity = NSUserActivity(activityType: "com.shi.Mast.openSettings")
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil) { (e) in
          print("error", e)
        }
        #elseif !targetEnvironment(macCatalyst)
        let vc = SettingsViewController()
        self.show(UINavigationController(rootViewController: vc), sender: self)
        #endif
    }
    
    @objc func search() {
        let alert = UIAlertController(style: .actionSheet, message: nil)
        alert.addLocalePicker(type: .country) { info in
            // action with selected object
            GlobalStruct.macWindow = 4
            UIApplication.shared.windows.first?.becomeKey()
        }
        alert.addAction(title: "Dismiss", style: .cancel) { info in
            GlobalStruct.macWindow = 4
            UIApplication.shared.windows.first?.becomeKey()
        }
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = self.button2
            presenter.sourceRect = self.button2.bounds
        }
        alert.show()
    }
    
    @objc func compose() {
        #if targetEnvironment(macCatalyst)
        GlobalStruct.macWindow = 1
        let userActivity = NSUserActivity(activityType: "com.shi.Mast.openComposer")
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil) { (e) in
          print("error", e)
        }
        #elseif !targetEnvironment(macCatalyst)
        let vc = TootViewController()
        self.show(UINavigationController(rootViewController: vc), sender: self)
        #endif
    }
}
