//
//  IconSettingsViewController.swift
//  Mast
//
//  Created by Shihab Mehboob on 09/11/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit

class IconSettingsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    var collectionView: UICollectionView!
    var appArrayIcons = ["icon1", "icon33", "icon34", "icon35", "icon36", "icon37", "icon38", "icon39", "icon40"]
    var appArray = ["AppIcon-1", "AppIcon-33", "AppIcon-34", "AppIcon-35", "AppIcon-36", "AppIcon-37", "AppIcon-38", "AppIcon-39", "AppIcon-40"]
    
    override func viewDidLayoutSubviews() {
        self.collectionView.frame = CGRect(x: self.view.safeAreaInsets.left, y: 0, width: self.view.bounds.width - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right, height: self.view.bounds.height)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(named: "lighterBaseWhite")
        self.title = "App Icon".localized
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor(named: "baseBlack")!]

        if UIDevice.current.userInterfaceIdiom == .pad {
            let layout = ColumnFlowLayout(
                cellsPerRow: 7,
                minimumInteritemSpacing: 5,
                minimumLineSpacing: 5,
                sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            )
            self.collectionView = UICollectionView(frame: CGRect(x: self.view.safeAreaInsets.left, y: 0, width: self.view.bounds.width - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right, height: self.view.bounds.height), collectionViewLayout: layout)
        } else {
            let layout = ColumnFlowLayout(
                cellsPerRow: 4,
                minimumInteritemSpacing: 5,
                minimumLineSpacing: 5,
                sectionInset: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            )
            self.collectionView = UICollectionView(frame: CGRect(x: self.view.safeAreaInsets.left, y: 0, width: self.view.bounds.width - self.view.safeAreaInsets.left - self.view.safeAreaInsets.right, height: self.view.bounds.height), collectionViewLayout: layout)
        }
        self.collectionView.backgroundColor = UIColor.clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.showsVerticalScrollIndicator = false
        self.collectionView.register(ImageCell.self, forCellWithReuseIdentifier: "ImageCell")
        self.view.addSubview(self.collectionView)
        self.collectionView.reloadData()
    }
    
    //MARK: CollectionView
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.appArrayIcons.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if UIDevice.current.userInterfaceIdiom == .pad {
            let x = 7
            let y = (self.view.bounds.width) - 20
            let z = CGFloat(y)/CGFloat(x)
            return CGSize(width: z - 5, height: z - 5)
        } else {
            let x = 4
            let y = (self.view.bounds.width) - 20
            let z = CGFloat(y)/CGFloat(x)
            return CGSize(width: z - 5, height: z - 5)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCell", for: indexPath) as! ImageCell
        cell.configure()
        cell.image.image = nil
        cell.image.image = UIImage(named: self.appArrayIcons[indexPath.row])
        cell.image.contentMode = .scaleAspectFill
        cell.layer.cornerRadius = 20
        cell.layer.cornerCurve = .continuous
        cell.image.layer.cornerRadius = 20
        cell.image.layer.cornerCurve = .continuous
        cell.image.layer.masksToBounds = true
        cell.imageCountTag.alpha = 0
        cell.image.frame.size.width = cell.frame.size.width
        cell.image.frame.size.height = cell.frame.size.height
        cell.backgroundColor = UIColor.clear
        cell.backgroundColor = UIColor(named: "baseGray")
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        #if !targetEnvironment(macCatalyst)
//        if GlobalStruct.iapPurchased {
            let imp = UIImpactFeedbackGenerator(style: .light)
            imp.impactOccurred()
            if indexPath.item == 0 {
                UIApplication.shared.setAlternateIconName(nil)
            } else {
                UIApplication.shared.setAlternateIconName(self.appArray[indexPath.row])
            }
//        } else {
//            let vc = IAPSettingsViewController()
//            self.navigationController?.pushViewController(vc, animated: true)
//        }
        #elseif targetEnvironment(macCatalyst)
        let imp = UIImpactFeedbackGenerator(style: .light)
        imp.impactOccurred()
        if indexPath.item == 0 {
            UIApplication.shared.setAlternateIconName(nil)
        } else {
            UIApplication.shared.setAlternateIconName(self.appArray[indexPath.row])
        }
        #endif
    }
}






