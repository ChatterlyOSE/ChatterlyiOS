//
//  IAPSettingsViewController.swift
//  Mast
//
//  Created by Shihab Mehboob on 20/11/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit
import StoreKit
import SwiftyStoreKit

class IAPSettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var tableView = UITableView()
    var bgView = UIView()
    let firstSection = ["Your contribution goes a long way".localized]
    let firstSectionDescriptions = ["\nThe tip jar helps keep Mast running, and supports the developer in getting awesome updates to you.\n\nVersion 2 was entirely re-written from the ground up with a whole new design (and is what you're seeing here).\n\nIf you enjoy using this app and want to support the developer (that's me, Shihab - a young indie developer trying his best to make cool products), please consider one of the tip jar options below.\n\nThank you for being awesome!".localized]
    let firstSectionImage = ["heart"]
    var button1 = UIButton()
    var button1Title = UILabel()
    var button1Title2 = UILabel()
    var button2 = UIButton()
    var button2Title = UILabel()
    var button2Title2 = UILabel()
    var tandc = UILabel()
    var button4 = UIButton()
    var button5 = UIButton()
    let starButton = UIButton()
    let tandctext = "The tip jar is either an auto-renewing subscription, or a one-off payment.".localized
    
    var productID = ""
    var lifetimeProduct : SKProduct?
    var annualProduct : SKProduct?
    var monthlyProduct : SKProduct?
    var price1 = "---"
    var price2 = "---"
    var price3 = "---"
    
    var shouldShowX: Bool = false
    
    override func viewDidLayoutSubviews() {
        self.tableView.frame = CGRect(x: self.view.safeAreaInsets.left, y: 0, width: self.view.bounds.width - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right, height: self.view.bounds.height - 210)
        self.bgView.frame = CGRect(x: 0, y: self.view.bounds.height - 210, width: self.view.bounds.width - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right, height: 210)
        self.button1.frame = CGRect(x: 25, y: 20, width: (self.view.bounds.width - 75)/2, height: 80)
        self.button2.frame = CGRect(x: (self.view.bounds.width - 75)/2 + 50, y: 20, width: (self.view.bounds.width - 75)/2, height: 80)
        
        self.starButton.frame = CGRect(x: self.button2.frame.width - 22, y: -10, width: 30, height: 30)
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            self.tandc.frame = CGRect(x: 25, y: 91, width: (self.view.bounds.width - 50), height: 100 - self.view.safeAreaInsets.bottom)
            self.button4.frame = CGRect(x: (self.view.bounds.width/3) - 75, y: 158, width: 150, height: 40)
            self.button5.frame = CGRect(x: ((self.view.bounds.width/3)*2) - 75, y: 158, width: 150, height: 40)
        } else {
            if self.view.safeAreaInsets.bottom > 0 {
                self.tandc.frame = CGRect(x: 25, y: 90, width: (self.view.bounds.width - 50), height: 120 - self.view.safeAreaInsets.bottom)
                self.button4.frame = CGRect(x: (self.view.bounds.width/3) - 75, y: 148, width: 150, height: 40)
                self.button5.frame = CGRect(x: ((self.view.bounds.width/3)*2) - 75, y: 148, width: 150, height: 40)
            } else {
                self.tandc.frame = CGRect(x: 25, y: 81, width: (self.view.bounds.width - 50), height: 120 - self.view.safeAreaInsets.bottom)
                self.button4.frame = CGRect(x: (self.view.bounds.width/3) - 75, y: 158, width: 150, height: 40)
                self.button5.frame = CGRect(x: ((self.view.bounds.width/3)*2) - 75, y: 158, width: 150, height: 40)
            }
        }
        
        self.button1Title.frame = CGRect(x: (((self.view.bounds.width - 75)/2)/2) - 110, y: 10, width: 220, height: 40)
        self.button2Title.frame = CGRect(x: (((self.view.bounds.width - 75)/2)/2) - 110, y: 10, width: 220, height: 40)
        
        self.button1Title2.frame = CGRect(x: (((self.view.bounds.width - 75)/2)/2) - 110, y: 33, width: 220, height: 40)
        self.button2Title2.frame = CGRect(x: (((self.view.bounds.width - 75)/2)/2) - 110, y: 33, width: 220, height: 40)
    }
    
    @objc func dismissAll() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "baseWhite")!
        self.title = "Tip Jar".localized
        
        if self.shouldShowX {
            let dismiss = UIBarButtonItem(image: UIImage(systemName: "xmark")!, style: .plain, target: self, action: #selector(dismissAll))
            self.navigationItem.setRightBarButtonItems([dismiss], animated: true)
        }
        
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(named: "baseBlack")!]
        
        self.fetchAvailableProducts()
        self.fetchAvailableProducts()
        
        self.tableView = UITableView(frame: .zero, style: .insetGrouped)
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "settingsCell")
        self.tableView.register(IAPOptionsCell.self, forCellReuseIdentifier: "IAPOptionsCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.layer.masksToBounds = true
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.separatorStyle = .none
        self.view.addSubview(self.tableView)
        self.tableView.reloadData()
        
        self.bgView.backgroundColor = UIColor(named: "lighterBaseWhite")!
        self.view.addSubview(self.bgView)
        let border = UIView()
        border.backgroundColor = UIColor(named: "baseBlack")!.withAlphaComponent(0.28)
        border.autoresizingMask = [.flexibleWidth, .flexibleBottomMargin]
        border.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 0.52)
        self.bgView.addSubview(border)
        
        self.button1.backgroundColor = UIColor.clear
        self.button1.layer.cornerCurve = .continuous
        self.button1.layer.cornerRadius = 10
        self.button1.layer.borderColor = GlobalStruct.baseTint.cgColor
        self.button1.layer.borderWidth = 2
        self.button1.addTarget(self, action: #selector(self.b1Tap), for: .touchUpInside)
        self.bgView.addSubview(button1)
        
        self.button1Title.text = "Monthly Tip".localized
        self.button1Title.textColor = GlobalStruct.baseTint
        self.button1Title.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize)
        self.button1Title.textAlignment = .center
        self.button1.addSubview(self.button1Title)
        
        self.button1Title2.text = "\(self.price1)/mo".localized
        self.button1Title2.textColor = GlobalStruct.baseTint
        self.button1Title2.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
        self.button1Title2.textAlignment = .center
        self.button1.addSubview(self.button1Title2)
        
        self.button2.backgroundColor = GlobalStruct.baseTint
        self.button2.layer.cornerCurve = .continuous
        self.button2.layer.cornerRadius = 10
        self.button2.layer.borderColor = GlobalStruct.baseTint.cgColor
        self.button2.layer.borderWidth = 0
        self.button2.addTarget(self, action: #selector(self.b2Tap), for: .touchUpInside)
        self.bgView.addSubview(button2)
        
        self.button2.layer.shadowColor = UIColor(named: "alwaysBlack")!.cgColor
        self.button2.layer.shadowOffset = CGSize(width: 0, height: 14)
        self.button2.layer.shadowRadius = 21
        self.button2.layer.shadowOpacity = 0.24
        
        self.button2Title.text = "One-Off Tip".localized
        self.button2Title.textColor = UIColor(named: "alwaysWhite")!
        self.button2Title.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .title2).pointSize)
        self.button2Title.textAlignment = .center
        self.button2.addSubview(self.button2Title)
        
        self.button2Title2.text = "\(self.price2)".localized
        self.button2Title2.textColor = UIColor(named: "alwaysWhite")!
        self.button2Title2.font = UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
        self.button2Title2.textAlignment = .center
        self.button2.addSubview(self.button2Title2)
        
        self.tandc.text = self.tandctext
        self.tandc.numberOfLines = 0
        self.tandc.textColor = UIColor(named: "baseBlack")!.withAlphaComponent(0.4)
        self.tandc.font = UIFont.preferredFont(forTextStyle: .footnote)
        self.tandc.textAlignment = .center
        self.tandc.numberOfLines = 2
        self.bgView.addSubview(self.tandc)
        
        self.button4.backgroundColor = UIColor.clear
        self.button4.setTitle("See More".localized, for: .normal)
        self.button4.setTitleColor(UIColor(named: "baseBlack")!.withAlphaComponent(0.75), for: .normal)
        self.button4.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .footnote).pointSize)
        self.button4.addTarget(self, action: #selector(self.seeMore), for: .touchUpInside)
        self.bgView.addSubview(button4)
        
        self.button5.backgroundColor = UIColor.clear
        self.button5.setTitle("Restore Purchases".localized, for: .normal)
        self.button5.setTitleColor(UIColor(named: "baseBlack")!.withAlphaComponent(0.75), for: .normal)
        self.button5.titleLabel?.font = UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .footnote).pointSize)
        self.button5.addTarget(self, action: #selector(self.restoreTap), for: .touchUpInside)
        self.bgView.addSubview(button5)
        
        self.starButton.backgroundColor = UIColor(named: "baseWhite")!
        self.starButton.layer.borderColor = GlobalStruct.baseTint.cgColor
        self.starButton.layer.borderWidth = 1.6
        self.starButton.layer.cornerRadius = 15
        self.starButton.isUserInteractionEnabled = false
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 13)
        self.starButton.setImage(UIImage(systemName: "star.fill", withConfiguration: symbolConfig)!.withTintColor(GlobalStruct.baseTint, renderingMode: .alwaysOriginal), for: .normal)
        self.button2.addSubview(self.starButton)
    }
    
    @objc func seeMore() {
        let imp = UIImpactFeedbackGenerator(style: .light)
        imp.impactOccurred()
        
        let alert = UIAlertController(title: nil, message: self.tandctext, preferredStyle: .actionSheet)
        let a1 = UIAlertAction(title: "Privacy Policy".localized, style: .default , handler:{ (UIAlertAction) in
            let z = URL(string: "https://www.allegoryapp.info/privacy")!
            UIApplication.shared.open(z)
        })
        a1.setValue(UIImage(systemName: "link")!, forKey: "image")
        a1.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        alert.addAction(a1)
        let a2 = UIAlertAction(title: "Terms of Service".localized, style: .default , handler:{ (UIAlertAction) in
            let z = URL(string: "https://www.allegoryapp.info/terms")!
            UIApplication.shared.open(z)
        })
        a2.setValue(UIImage(systemName: "link")!, forKey: "image")
        a2.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        alert.addAction(a2)
        alert.addAction(UIAlertAction(title: "Dismiss".localized, style: .cancel , handler:{ (UIAlertAction) in
            
        }))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        let messageText = NSMutableAttributedString(
            string: "The tip jar is either an auto-renewing subscription, or a one-off payment.".localized,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
            ]
        )
        alert.setValue(messageText, forKey: "attributedMessage")
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = self.button4
            presenter.sourceRect = self.button4.bounds
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func restoreTap() {
        let imp = UIImpactFeedbackGenerator(style: .light)
        imp.impactOccurred()
        
        SwiftyStoreKit.restorePurchases(atomically: true) { results in
            if results.restoreFailedPurchases.count > 0 {
                print("Restore Failed: \(results.restoreFailedPurchases)")
            } else if results.restoredPurchases.count > 0 {
                print("Restore Success: \(results.restoredPurchases)")
                GlobalStruct.iapPurchased = true
                UserDefaults.standard.set(1, forKey: "firstIAP")
                
                let alert = UIAlertController(title: "Thank you!".localized, message: "You're awesome, and your contribution means the world.".localized, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Dismiss".localized, style: .cancel , handler:{ (UIAlertAction) in
                    
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
                    
                    self.dismiss(animated: true, completion: nil)
                }))
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = NSTextAlignment.left
                let messageText = NSMutableAttributedString(
                    string: "You're awesome, and your contribution means the world.".localized,
                    attributes: [
                        NSAttributedString.Key.paragraphStyle: paragraphStyle,
                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
                    ]
                )
                alert.setValue(messageText, forKey: "attributedMessage")
                let titleText = NSMutableAttributedString(
                    string: "Thank you!".localized,
                    attributes: [
                        NSAttributedString.Key.paragraphStyle: paragraphStyle,
                        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize), NSAttributedString.Key.foregroundColor : UIColor(named: "baseBlack")!
                    ]
                )
                alert.setValue(titleText, forKey: "attributedTitle")
                if let presenter = alert.popoverPresentationController {
                    presenter.sourceView = self.button4
                    presenter.sourceRect = self.button4.bounds
                }
                self.present(alert, animated: true, completion: nil)
                
//                let confettiView = SAConfettiView(frame: self.view.bounds)
//                confettiView.isUserInteractionEnabled = true
//                self.view.addSubview(confettiView)
//                confettiView.intensity = 0.9
//                confettiView.startConfetti()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    confettiView.stopConfetti()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
//                        confettiView.removeFromSuperview()
//                    }
//                }
            } else {
                let alert = UIAlertController(title: "Nothing to restore".localized, message: nil, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Dismiss".localized, style: .cancel , handler:{ (UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                }))
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = NSTextAlignment.left
                let titleText = NSMutableAttributedString(
                    string: "Nothing to restore".localized,
                    attributes: [
                        NSAttributedString.Key.paragraphStyle: paragraphStyle,
                        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize), NSAttributedString.Key.foregroundColor : UIColor(named: "baseBlack")!
                    ]
                )
                alert.setValue(titleText, forKey: "attributedTitle")
                if let presenter = alert.popoverPresentationController {
                    presenter.sourceView = self.button4
                    presenter.sourceRect = self.button4.bounds
                }
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func b1Tap() {
        let imp = UIImpactFeedbackGenerator(style: .medium)
        imp.impactOccurred()
        
        if let mon = self.monthlyProduct {
            if self.canMakePurchases() {
                makePurchase(mon)
            } else {
                self.purchaseError()
            }
        }
    }
    
    @objc func b2Tap() {
        let imp = UIImpactFeedbackGenerator(style: .medium)
        imp.impactOccurred()
        
        if let lif = self.lifetimeProduct {
            if self.canMakePurchases() {
                makePurchase(lif)
            } else {
                self.purchaseError()
            }
        }
    }
    
    //MARK: TableView
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.firstSection.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "IAPOptionsCell", for: indexPath) as! IAPOptionsCell
        cell.configure(self.firstSection[indexPath.row], str2: self.firstSectionDescriptions[indexPath.row], im: self.firstSectionImage[indexPath.row])
        cell.backgroundColor = UIColor.clear
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func canMakePurchases() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }
    
    func makePurchase(_ theProduct: SKProduct) {
        SwiftyStoreKit.purchaseProduct(theProduct, quantity: 1, atomically: true) { result in
            switch result {
            case .success(let purchase):
                print("Purchase Success: \(purchase.productId)")
                GlobalStruct.iapPurchased = true
                UserDefaults.standard.set(1, forKey: "firstIAP")
                
                let alert = UIAlertController(title: "Thank you!".localized, message: "You're awesome, and your contribution means the world.".localized, preferredStyle: .actionSheet)
                alert.addAction(UIAlertAction(title: "Dismiss".localized, style: .cancel , handler:{ (UIAlertAction) in
                    
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
                    
                    self.dismiss(animated: true, completion: nil)
                }))
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.alignment = NSTextAlignment.left
                let messageText = NSMutableAttributedString(
                    string: "You're awesome, and your contribution means the world.".localized,
                    attributes: [
                        NSAttributedString.Key.paragraphStyle: paragraphStyle,
                        NSAttributedString.Key.font: UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize)
                    ]
                )
                alert.setValue(messageText, forKey: "attributedMessage")
                let titleText = NSMutableAttributedString(
                    string: "Thank you!".localized,
                    attributes: [
                        NSAttributedString.Key.paragraphStyle: paragraphStyle,
                        NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize), NSAttributedString.Key.foregroundColor : UIColor(named: "baseBlack")!
                    ]
                )
                alert.setValue(titleText, forKey: "attributedTitle")
                if let presenter = alert.popoverPresentationController {
                    presenter.sourceView = self.button4
                    presenter.sourceRect = self.button4.bounds
                }
                self.present(alert, animated: true, completion: nil)
                
//                let confettiView = SAConfettiView(frame: self.view.bounds)
//                confettiView.isUserInteractionEnabled = true
//                self.view.addSubview(confettiView)
//                confettiView.intensity = 0.9
//                confettiView.startConfetti()
//                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
//                    confettiView.stopConfetti()
//                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.4) {
//                        confettiView.removeFromSuperview()
//                    }
//                }
            case .error(let error):
                switch error.code {
                case .unknown: print("Unknown error. Please contact support")
                case .clientInvalid: print("Not allowed to make the payment")
                case .paymentCancelled: break
                case .paymentInvalid: print("The purchase identifier was invalid")
                case .paymentNotAllowed: print("The device is not allowed to make the payment")
                case .storeProductNotAvailable: print("The product is not available in the current storefront")
                case .cloudServicePermissionDenied: print("Access to cloud service information is not allowed")
                case .cloudServiceNetworkConnectionFailed: print("Could not connect to the network")
                case .cloudServiceRevoked: print("User has revoked permission to use this cloud service")
                default: print((error as NSError).localizedDescription)
                }
            }
        }
    }
    
    func fetchAvailableProducts()  {
        SwiftyStoreKit.retrieveProductsInfo(["me.chatterly.mobile.lifes"]) { result in
            let numberFormatter = NumberFormatter()
            numberFormatter.formatterBehavior = .behavior10_4
            numberFormatter.numberStyle = .currency

            if let product = result.retrievedProducts.first {
                self.lifetimeProduct = product
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
                numberFormatter.locale = product.priceLocale
                DispatchQueue.main.async {
                    self.button2Title2.text = "\(priceString)".localized
                }
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            } else {
                print("Error: \(result.error)")
                self.fetchError()
            }
        }
        
        SwiftyStoreKit.retrieveProductsInfo(["me.chatterly.mobile.months"]) { result in
            let numberFormatter = NumberFormatter()
            numberFormatter.formatterBehavior = .behavior10_4
            numberFormatter.numberStyle = .currency

            if let product = result.retrievedProducts.first {
                self.monthlyProduct = product
                let priceString = product.localizedPrice!
                print("Product: \(product.localizedDescription), price: \(priceString)")
                numberFormatter.locale = product.priceLocale
                DispatchQueue.main.async {
                    self.button1Title2.text = "\(priceString)/mo".localized
                }
            } else if let invalidProductId = result.invalidProductIDs.first {
                print("Invalid product identifier: \(invalidProductId)")
            } else {
                print("Error: \(result.error)")
                self.fetchError()
            }
        }
        
    }
    
    func purchaseError() {
        let alert = UIAlertController(title: "Purchases are disabled on this device".localized, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Dismiss".localized, style: .cancel , handler:{ (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        let titleText = NSMutableAttributedString(
            string: "Purchases are disabled on this device".localized,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize), NSAttributedString.Key.foregroundColor : UIColor(named: "baseBlack")!
            ]
        )
        alert.setValue(titleText, forKey: "attributedTitle")
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    func fetchError() {
        let alert = UIAlertController(title: "There was an error fetching the products".localized, message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Dismiss".localized, style: .cancel , handler:{ (UIAlertAction) in
            self.dismiss(animated: true, completion: nil)
        }))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = NSTextAlignment.left
        let titleText = NSMutableAttributedString(
            string: "There was an error fetching the products".localized,
            attributes: [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .body).pointSize), NSAttributedString.Key.foregroundColor : UIColor(named: "baseBlack")!
            ]
        )
        alert.setValue(titleText, forKey: "attributedTitle")
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = self.view
            presenter.sourceRect = self.view.bounds
        }
        self.present(alert, animated: true, completion: nil)
    }
}

