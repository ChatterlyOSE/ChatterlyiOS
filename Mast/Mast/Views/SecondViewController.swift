//
//  SecondViewController.swift
//  Mast
//
//  Created by Shihab Mehboob on 11/09/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import Foundation
import UIKit

class SecondViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
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
    var tableView = UITableView()
    var tableView2 = UITableView()
    let segment: UISegmentedControl = UISegmentedControl(items: ["Activity".localized, "Metrics".localized])
    var refreshControl = UIRefreshControl()
    let top1 = UIButton()
    let btn2 = UIButton(type: .custom)
    var notTypes: [NotificationType] = []
    var notifications: [Notificationt] = []
    var gapLastID = ""
    var gapLastStat: Notificationt? = nil
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let tab0 = (self.navigationController?.navigationBar.bounds.height ?? 0) + (self.segment.bounds.height) + 10
        let startHeight = (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + tab0
        self.top1.frame = CGRect(x: Int(self.view.bounds.width) - 48, y: Int(startHeight + 6), width: 38, height: 38)
        
        #if targetEnvironment(macCatalyst)
        self.segment.frame = CGRect(x: 15, y: (self.navigationController?.navigationBar.bounds.height ?? 0) + 5, width: self.view.bounds.width - 30, height: segment.bounds.height)
        
        // Table
        let tableHeight = (self.navigationController?.navigationBar.bounds.height ?? 0) + (self.segment.bounds.height) + 10
        self.tableView.frame = CGRect(x: 0, y: tableHeight, width: self.view.bounds.width, height: (self.view.bounds.height) - tableHeight)
        self.tableView2.frame = CGRect(x: 0, y: tableHeight, width: self.view.bounds.width, height: (self.view.bounds.height) - tableHeight)
        #elseif !targetEnvironment(macCatalyst)
        if UIDevice.current.userInterfaceIdiom == .pad && self.isSplitOrSlideOver == false {
            self.segment.frame = CGRect(x: 15, y: (self.navigationController?.navigationBar.bounds.height ?? 0) + 5, width: self.view.bounds.width - 30, height: segment.bounds.height)
            
            // Table
            let tableHeight = (self.navigationController?.navigationBar.bounds.height ?? 0) + (self.segment.bounds.height) + 10
            self.tableView.frame = CGRect(x: 0, y: tableHeight, width: self.view.bounds.width, height: (self.view.bounds.height) - tableHeight)
            self.tableView2.frame = CGRect(x: 0, y: tableHeight, width: self.view.bounds.width, height: (self.view.bounds.height) - tableHeight)
        } else {
            self.segment.frame = CGRect(x: 15, y: (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + (self.navigationController?.navigationBar.bounds.height ?? 0) + 5, width: self.view.bounds.width - 30, height: segment.bounds.height)
            
            // Table
            let tab0 = (self.navigationController?.navigationBar.bounds.height ?? 0) + (self.segment.bounds.height) + 10
            let tableHeight = (UIApplication.shared.windows.first?.safeAreaInsets.top ?? 0) + tab0
            self.tableView.frame = CGRect(x: 0, y: tableHeight, width: self.view.bounds.width, height: (self.view.bounds.height) - tableHeight)
            self.tableView2.frame = CGRect(x: 0, y: tableHeight, width: self.view.bounds.width, height: (self.view.bounds.height) - tableHeight)
        }
        #endif
    }
    
    @objc func scrollTop2() {
        if self.tableView.alpha == 1 && !self.notifications.isEmpty {
            if self.notifications.isEmpty {
                
            } else {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
                UIView.animate(withDuration: 0.18, delay: 0, options: .curveEaseOut, animations: {
                    self.top1.alpha = 0
                    self.top1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                }) { (completed: Bool) in
                }
            }
        }
        if self.tableView2.alpha == 1 {
            self.tableView2.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        }
    }
    
    func scrollViewShouldScrollToTop(_ scrollView: UIScrollView) -> Bool {
        self.scrollTop2()
        return false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        self.view.backgroundColor = GlobalStruct.baseDarkTint
        GlobalStruct.currentTab = 2
        
        self.markersGet()
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 21, weight: .regular)
        #if targetEnvironment(macCatalyst)
        let btn1 = UIButton(type: .custom)
        btn1.setImage(UIImage(systemName: "square.on.square", withConfiguration: symbolConfig)?.withTintColor(UIColor(named: "baseBlack")!.withAlphaComponent(1), renderingMode: .alwaysOriginal), for: .normal)
        btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn1.addTarget(self, action: #selector(self.newWindow), for: .touchUpInside)
        btn1.accessibilityLabel = "New Window".localized
        let addButton = UIBarButtonItem(customView: btn1)
//        self.navigationItem.setRightBarButton(addButton, animated: true)
        #elseif !targetEnvironment(macCatalyst)
        if UIDevice.current.userInterfaceIdiom == .pad && self.isSplitOrSlideOver == false {
            let btn1 = UIButton(type: .custom)
            btn1.setImage(UIImage(systemName: "square.on.square", withConfiguration: symbolConfig)?.withTintColor(UIColor(named: "baseBlack")!.withAlphaComponent(1), renderingMode: .alwaysOriginal), for: .normal)
            btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn1.addTarget(self, action: #selector(self.newWindow), for: .touchUpInside)
            btn1.accessibilityLabel = "New Window".localized
            let addButton = UIBarButtonItem(customView: btn1)
//            self.navigationItem.setRightBarButton(addButton, animated: true)
        } else {
            let btn1 = UIButton(type: .custom)
            btn1.setImage(UIImage(systemName: "plus", withConfiguration: symbolConfig)?.withTintColor(UIColor(named: "baseBlack")!.withAlphaComponent(1), renderingMode: .alwaysOriginal), for: .normal)
            btn1.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            btn1.addTarget(self, action: #selector(self.addTapped), for: .touchUpInside)
            btn1.accessibilityLabel = "Create".localized
            let addButton = UIBarButtonItem(customView: btn1)
            self.navigationItem.setRightBarButton(addButton, animated: true)
        }
        #endif
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if let cell = self.tableView.indexPathsForVisibleRows?.first {
            self.markersPost(self.notifications[cell.row].id)
        }
    }
    
    func markersPost(_ notificationsID: String) {
        let urlStr = "\(GlobalStruct.client.baseURL)/api/v1/markers"
        let url: URL = URL(string: urlStr)!
        var request01 = URLRequest(url: url)
        request01.httpMethod = "POST"
        request01.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request01.addValue("application/json", forHTTPHeaderField: "Accept")
        request01.addValue("Bearer \(GlobalStruct.client.accessToken ?? "")", forHTTPHeaderField: "Authorization")
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let paraHome: [String: Any?] = [
            "last_read_id": notificationsID
        ]
        let params: [String: Any?] = [
            "notifications": paraHome,
        ]
        do {
            request01.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
        } catch let error {
            print(error.localizedDescription)
        }
        let task = session.dataTask(with: request01) { data, response, err in
            do {
                let model = try JSONDecoder().decode(Marker.self, from: data ?? Data())
                print("marker1 - \(model.notifications?.lastReadID ?? "")")
            } catch {
                print("error")
            }
        }
        task.resume()
    }
    
    func markersGet() {
        let urlStr = "\(GlobalStruct.client.baseURL)/api/v1/markers/?timeline=notifications"
        let url: URL = URL(string: urlStr)!
        var request01 = URLRequest(url: url)
        request01.httpMethod = "GET"
        request01.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request01.addValue("application/json", forHTTPHeaderField: "Accept")
        request01.addValue("Bearer \(GlobalStruct.client.accessToken ?? "")", forHTTPHeaderField: "Authorization")
        let sessionConfig = URLSessionConfiguration.default
        let session = URLSession(configuration: sessionConfig)
        let task = session.dataTask(with: request01) { data, response, err in
            do {
                let model = try JSONDecoder().decode(Marker.self, from: data ?? Data())
                let request0 = Notifications.notification(id: model.notifications?.lastReadID ?? "")
                GlobalStruct.client.run(request0) { (statuses) in
                    if let stat = (statuses.value) {
                        DispatchQueue.main.async {
                            self.notifications = [stat]
                            let request = Notifications.all(range: .max(id: model.notifications?.lastReadID ?? "", limit: 5000))
                            GlobalStruct.client.run(request) { (statuses) in
                                if let stat = (statuses.value) {
                                    DispatchQueue.main.async {
                                        if stat.isEmpty {
                                            if self.notifications.isEmpty {
                                                let request4 = Notifications.all(range: .default, typesToExclude: self.notTypes)
                                                GlobalStruct.client.run(request4) { (statuses) in
                                                    if let stat = (statuses.value) {
                                                        DispatchQueue.main.async {
                                                            self.notifications = stat
                                                            self.tableView.reloadData()
                                                            self.tableView2.reloadData()
                                                        }
                                                    }
                                                }
                                            }
                                        } else {
                                            self.notifications = self.notifications + stat
                                            self.tableView.reloadData()
                                            self.tableView2.reloadData()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            } catch {
                if self.notifications.isEmpty {
                    let request4 = Notifications.all(range: .default, typesToExclude: self.notTypes)
                    GlobalStruct.client.run(request4) { (statuses) in
                        if let stat = (statuses.value) {
                            DispatchQueue.main.async {
                                self.notifications = stat
                                self.tableView.reloadData()
                                self.tableView2.reloadData()
                            }
                        }
                    }
                }
            }
        }
        task.resume()
    }
    
    func fetchGap() {
        let request = Notifications.all(range: .max(id: self.gapLastID, limit: nil))
        GlobalStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                if stat.isEmpty {
                    DispatchQueue.main.async {
                        self.refreshControl.endRefreshing()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.refreshControl.endRefreshing()
                        self.top1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                        UIView.animate(withDuration: 0.18, delay: 0, options: .curveEaseOut, animations: {
                            self.top1.alpha = 1
                            self.top1.transform = CGAffineTransform(scaleX: 1, y: 1)
                        }) { (completed: Bool) in
                        }
                        
                        let y = self.notifications.split(separator: self.gapLastStat ?? self.notifications.last!)
                        
                        if self.notifications.contains(stat.last!) || stat.count < 15 {
                            
                        } else {
                            self.gapLastID = stat.last?.id ?? ""
                            let z = stat.last!
                            z.id = "loadmorehere"
                            self.gapLastStat = z
                        }
                        
                        let fi = (y.first?.count ?? 0)
                        let indexPaths = (fi..<(fi + stat.count - 1)).map {
                            IndexPath(row: $0, section: 0)
                        }
                        if y.first?.isEmpty ?? true {
                            if y.last?.isEmpty ?? true {
                                self.notifications = stat
                            } else {
                                self.notifications = stat + y.last!
                            }
                        } else if y.last?.isEmpty ?? true {
                            self.notifications = y.first! + stat
                        } else {
                            self.notifications = y.first! + stat + y.last!
                        }
                        UIView.setAnimationsEnabled(false)
                        let _ = indexPaths.map {
                            if let cell = self.tableView.cellForRow(at: $0) as? LoadMoreCell {
                                cell.configureBack()
                            }
                        }
                        self.tableView.reloadData()
                        UIView.setAnimationsEnabled(true)
                    }
                }
            }
        }
    }
    
    @objc func refreshTable() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    @objc func notifChangeTint() {
        self.tableView.reloadData()
        
        self.tableView.reloadInputViews()
    }
    
    @objc func newWindow() {
        
    }
    
    @objc func openTootDetail() {
        let vc = DetailViewController()
        vc.isPassedID = true
        vc.passedID = GlobalStruct.thePassedID
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func notifChangeBG() {
        GlobalStruct.baseDarkTint = (UserDefaults.standard.value(forKey: "sync-startDarkTint") == nil || UserDefaults.standard.value(forKey: "sync-startDarkTint") as? Int == 0) ? UIColor(named: "baseWhite")! : UIColor(named: "baseWhite2")!
        self.view.backgroundColor = GlobalStruct.baseDarkTint
        self.navigationController?.navigationBar.backgroundColor = GlobalStruct.baseDarkTint
        self.navigationController?.navigationBar.barTintColor = GlobalStruct.baseDarkTint
        self.tableView.reloadData()
    }
    
    @objc func goToIDNoti() {
        sleep(2)
        let request = Notifications.notification(id: GlobalStruct.curIDNoti)
        GlobalStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                DispatchQueue.main.async {
                    if let x = stat.status {
                        let vc = DetailViewController()
                        vc.pickedStatusesHome = [x]
                        self.navigationController?.pushViewController(vc, animated: true)
                    } else {
                        let vc = FifthViewController()
                        vc.isYou = false
                        vc.isTapped = true
                        vc.userID = stat.account.id
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                }
            }
        }
    }
    
    @objc func initialTimelineLoads() {
        let request4 = Notifications.all(range: .default, typesToExclude: self.notTypes)
        GlobalStruct.client.run(request4) { (statuses) in
            if let stat = (statuses.value) {
                DispatchQueue.main.async {
                    print("notifstat - \(stat)")
                    self.notifications = stat
                    self.tableView.reloadData()
                    self.tableView2.reloadData()
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = GlobalStruct.baseDarkTint
        self.title = "Notifications".localized
//        self.removeTabbarItemsText()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.scrollTop2), name: NSNotification.Name(rawValue: "scrollTop2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTable), name: NSNotification.Name(rawValue: "refreshTable"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notifChangeTint), name: NSNotification.Name(rawValue: "notifChangeTint"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.openTootDetail), name: NSNotification.Name(rawValue: "openTootDetail2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.notifChangeBG), name: NSNotification.Name(rawValue: "notifChangeBG"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToIDNoti), name: NSNotification.Name(rawValue: "gotoidnoti2"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.initialTimelineLoads), name: NSNotification.Name(rawValue: "initialTimelineLoads"), object: nil)
        
        // Segmented control
        self.segment.selectedSegmentIndex = 0
        self.segment.addTarget(self, action: #selector(changeSegment(_:)), for: .valueChanged)
        self.view.addSubview(self.segment)

        // Add button
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 21, weight: .regular)
        btn2.setImage(UIImage(systemName: "line.horizontal.3.decrease", withConfiguration: symbolConfig)?.withTintColor(UIColor(named: "baseBlack")!.withAlphaComponent(1), renderingMode: .alwaysOriginal), for: .normal)
        btn2.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
        btn2.addTarget(self, action: #selector(self.sortTapped), for: .touchUpInside)
        btn2.accessibilityLabel = "Sort".localized
        let settingsButton = UIBarButtonItem(customView: btn2)
        self.navigationItem.setLeftBarButton(settingsButton, animated: true)
        
        if UserDefaults.standard.value(forKey: "filterNotifications") as? Int == 0 {
            self.notTypes = []
        } else if UserDefaults.standard.value(forKey: "filterNotifications") as? Int == 1 {
            self.notTypes = GlobalStruct.notTypes.filter {$0 != NotificationType.mention}
        } else if UserDefaults.standard.value(forKey: "filterNotifications") as? Int == 2 {
            self.notTypes = GlobalStruct.notTypes.filter {$0 != NotificationType.favourite}
        } else if UserDefaults.standard.value(forKey: "filterNotifications") as? Int == 3 {
            self.notTypes = GlobalStruct.notTypes.filter {$0 != NotificationType.reblog}
        } else if UserDefaults.standard.value(forKey: "filterNotifications") as? Int == 4 {
            self.notTypes = GlobalStruct.notTypes.filter {$0 != NotificationType.direct}
        } else if UserDefaults.standard.value(forKey: "filterNotifications") as? Int == 5 {
            self.notTypes = GlobalStruct.notTypes.filter {$0 != NotificationType.follow}
        } else if UserDefaults.standard.value(forKey: "filterNotifications") as? Int == 6 {
            self.notTypes = GlobalStruct.notTypes.filter {$0 != NotificationType.poll}
        }
        
        self.markersGet()
        
        // Table
        self.tableView.register(NotificationsCell.self, forCellReuseIdentifier: "NotificationsCell")
        self.tableView.register(NotificationsImageCell.self, forCellReuseIdentifier: "NotificationsImageCell")
        self.tableView.register(LoadMoreCell.self, forCellReuseIdentifier: "LoadMoreCell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.separatorStyle = .singleLine
        self.tableView.separatorColor = UIColor(named: "baseBlack")?.withAlphaComponent(0.24)
        self.tableView.backgroundColor = UIColor.clear
        self.tableView.layer.masksToBounds = true
        self.tableView.estimatedRowHeight = UITableView.automaticDimension
        self.tableView.rowHeight = UITableView.automaticDimension
        self.tableView.showsVerticalScrollIndicator = true
        self.tableView.tableFooterView = UIView()
        self.view.addSubview(self.tableView)
        self.tableView.reloadData()
        
        self.refreshControl.addTarget(self, action: #selector(refresh(_:)), for: UIControl.Event.valueChanged)
        self.tableView.addSubview(self.refreshControl)
        
        self.tableView2 = UITableView(frame: .zero, style: .insetGrouped)
        self.tableView2.register(GraphCell.self, forCellReuseIdentifier: "GraphCell")
        self.tableView2.register(GraphCell2.self, forCellReuseIdentifier: "GraphCell2")
        self.tableView2.delegate = self
        self.tableView2.dataSource = self
        self.tableView2.separatorStyle = .singleLine
        self.tableView2.separatorColor = UIColor(named: "baseBlack")?.withAlphaComponent(0.24)
        self.tableView2.backgroundColor = UIColor(named: "lighterBaseWhite")!
        self.tableView2.layer.masksToBounds = true
        self.tableView2.estimatedRowHeight = UITableView.automaticDimension
        self.tableView2.rowHeight = UITableView.automaticDimension
        self.tableView2.showsVerticalScrollIndicator = true
        self.tableView2.tableFooterView = UIView()
        self.tableView2.alpha = 0
        self.view.addSubview(self.tableView2)
        self.tableView2.reloadData()
        
        // Top buttons
        let symbolConfig2 = UIImage.SymbolConfiguration(pointSize: 30, weight: .regular)
        
        self.top1.setImage(UIImage(systemName: "chevron.up.circle.fill", withConfiguration: symbolConfig2)?.withTintColor(GlobalStruct.baseTint, renderingMode: .alwaysOriginal), for: .normal)
        self.top1.backgroundColor = GlobalStruct.baseDarkTint
        self.top1.layer.cornerRadius = 30
        self.top1.alpha = 0
        self.top1.addTarget(self, action: #selector(self.didTouchTop1), for: .touchUpInside)
        self.top1.accessibilityLabel = "Top".localized
        self.view.addSubview(self.top1)
    }
    
    @objc func didTouchTop1() {
        self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
        UIView.animate(withDuration: 0.18, delay: 0, options: .curveEaseOut, animations: {
            self.top1.alpha = 0
            self.top1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (completed: Bool) in
        }
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        UIView.animate(withDuration: 0.18, delay: 0, options: .curveEaseOut, animations: {
            self.top1.alpha = 0
            self.top1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (completed: Bool) in
        }
    }
    
    @objc func refresh(_ sender: AnyObject) {
        let request = Notifications.all(range: .since(id: self.notifications.first?.id ?? "", limit: nil), typesToExclude: self.notTypes)
        GlobalStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                if stat.isEmpty {
                    DispatchQueue.main.async {
                        self.refreshControl.endRefreshing()
                    }
                } else {
                    DispatchQueue.main.async {
                        self.refreshControl.endRefreshing()
                        self.top1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                        UIView.animate(withDuration: 0.18, delay: 0, options: .curveEaseOut, animations: {
                            self.top1.alpha = 1
                            self.top1.transform = CGAffineTransform(scaleX: 1, y: 1)
                        }) { (completed: Bool) in
                        }
                        
                        if self.notifications.contains(stat.last!) || stat.count < 15 {
                            
                        } else {
                            self.gapLastID = stat.last?.id ?? ""
                            let z = stat.last!
                            z.id = "loadmorehere"
                            self.gapLastStat = z
                        }
                        
                        let indexPaths = (0..<stat.count).map {
                            IndexPath(row: $0, section: 0)
                        }
                        self.notifications = stat + self.notifications
                        self.tableView.beginUpdates()
                        UIView.setAnimationsEnabled(false)
                        var heights: CGFloat = 0
                        let _ = indexPaths.map {
                            if let cell = self.tableView.cellForRow(at: $0) as? NotificationsCell {
                                heights += cell.bounds.height
                            }
                            if let cell = self.tableView.cellForRow(at: $0) as? NotificationsImageCell {
                                heights += cell.bounds.height
                            }
                            if let cell = self.tableView.cellForRow(at: $0) as? LoadMoreCell {
                                heights += cell.bounds.height
                            }
                        }
                        self.tableView.insertRows(at: indexPaths, with: UITableView.RowAnimation.none)
                        self.tableView.setContentOffset(CGPoint(x: 0, y: heights), animated: false)
                        self.tableView.endUpdates()
                        UIView.setAnimationsEnabled(true)
                    }
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == self.tableView2 {
            return 230
        } else {
            return UITableView.automaticDimension
        }
    }
    
    @objc func changeSegment(_ segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            self.tableView.alpha = 1
            self.tableView2.alpha = 0
            self.tableView.reloadData()
        }
        if segment.selectedSegmentIndex == 1 {
            self.tableView.alpha = 0
            self.tableView2.alpha = 1
            self.tableView2.reloadData()
        }
        UIView.animate(withDuration: 0.18, delay: 0, options: .curveEaseOut, animations: {
            self.top1.alpha = 0
            self.top1.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
        }) { (completed: Bool) in
        }
    }
    
    func filterNots() {
        DispatchQueue.main.async {
            self.notifications = []
            self.tableView.reloadData()
        }
        let request = Notifications.all(range: .default, typesToExclude: self.notTypes)
        GlobalStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                DispatchQueue.main.async {
                    self.notifications = stat
                    if stat.count > 0 {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    @objc func sortTapped() {
        if UserDefaults.standard.value(forKey: "sync-haptics") as? Int == 0 {
            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
            impactFeedbackgenerator.prepare()
            impactFeedbackgenerator.impactOccurred()
        }
        let alert = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let op1 = UIAlertAction(title: "All".localized, style: .default , handler:{ (UIAlertAction) in
            self.notTypes = []
            self.filterNots()
            UserDefaults.standard.set(0, forKey: "filterNotifications")
        })
        if UserDefaults.standard.value(forKey: "filterNotifications") as? Int == 0 {
            op1.setValue(UIImage(systemName: "checkmark.circle.fill")!, forKey: "image")
        } else {
            op1.setValue(UIImage(systemName: "circle")!, forKey: "image")
        }
        op1.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        alert.addAction(op1)
        let op2 = UIAlertAction(title: "Mentions".localized, style: .default , handler:{ (UIAlertAction) in
            self.notTypes = GlobalStruct.notTypes.filter {$0 != NotificationType.mention}
            self.filterNots()
            UserDefaults.standard.set(1, forKey: "filterNotifications")
        })
        if UserDefaults.standard.value(forKey: "filterNotifications") as? Int == 1 {
            op2.setValue(UIImage(systemName: "checkmark.circle.fill")!, forKey: "image")
        } else {
            op2.setValue(UIImage(systemName: "circle")!, forKey: "image")
        }
        op2.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        alert.addAction(op2)
        let op3 = UIAlertAction(title: "Likes".localized, style: .default , handler:{ (UIAlertAction) in
            self.notTypes = GlobalStruct.notTypes.filter {$0 != NotificationType.favourite}
            self.filterNots()
            UserDefaults.standard.set(2, forKey: "filterNotifications")
        })
        if UserDefaults.standard.value(forKey: "filterNotifications") as? Int == 2 {
            op3.setValue(UIImage(systemName: "checkmark.circle.fill")!, forKey: "image")
        } else {
            op3.setValue(UIImage(systemName: "circle")!, forKey: "image")
        }
        op3.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        alert.addAction(op3)
        let op4 = UIAlertAction(title: "Boosts".localized, style: .default , handler:{ (UIAlertAction) in
            self.notTypes = GlobalStruct.notTypes.filter {$0 != NotificationType.reblog}
            self.filterNots()
            UserDefaults.standard.set(3, forKey: "filterNotifications")
        })
        if UserDefaults.standard.value(forKey: "filterNotifications") as? Int == 3 {
            op4.setValue(UIImage(systemName: "checkmark.circle.fill")!, forKey: "image")
        } else {
            op4.setValue(UIImage(systemName: "circle")!, forKey: "image")
        }
        op4.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        alert.addAction(op4)
        let op5 = UIAlertAction(title: "Messages".localized, style: .default , handler:{ (UIAlertAction) in
        self.notTypes = GlobalStruct.notTypes.filter {$0 != NotificationType.direct}
        self.filterNots()
            UserDefaults.standard.set(4, forKey: "filterNotifications")
        })
        if UserDefaults.standard.value(forKey: "filterNotifications") as? Int == 4 {
            op5.setValue(UIImage(systemName: "checkmark.circle.fill")!, forKey: "image")
        } else {
            op5.setValue(UIImage(systemName: "circle")!, forKey: "image")
        }
        op5.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        alert.addAction(op5)
        let op6 = UIAlertAction(title: "Follows".localized, style: .default , handler:{ (UIAlertAction) in
            self.notTypes = GlobalStruct.notTypes.filter {$0 != NotificationType.follow}
            self.filterNots()
            UserDefaults.standard.set(5, forKey: "filterNotifications")
        })
        if UserDefaults.standard.value(forKey: "filterNotifications") as? Int == 5 {
            op6.setValue(UIImage(systemName: "checkmark.circle.fill")!, forKey: "image")
        } else {
            op6.setValue(UIImage(systemName: "circle")!, forKey: "image")
        }
        op6.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        alert.addAction(op6)
        let op7 = UIAlertAction(title: "Polls".localized, style: .default , handler:{ (UIAlertAction) in
            self.notTypes = GlobalStruct.notTypes.filter {$0 != NotificationType.poll}
            self.filterNots()
            UserDefaults.standard.set(6, forKey: "filterNotifications")
        })
        if UserDefaults.standard.value(forKey: "filterNotifications") as? Int == 6 {
            op7.setValue(UIImage(systemName: "checkmark.circle.fill")!, forKey: "image")
        } else {
            op7.setValue(UIImage(systemName: "circle")!, forKey: "image")
        }
        op7.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
        alert.addAction(op7)
        alert.addAction(UIAlertAction(title: "Dismiss".localized, style: .cancel , handler:{ (UIAlertAction) in
            
        }))
        if let presenter = alert.popoverPresentationController {
            presenter.sourceView = self.btn2
            presenter.sourceRect = self.btn2.bounds
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func addTapped() {
        if UserDefaults.standard.value(forKey: "sync-haptics") as? Int == 0 {
            let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
            impactFeedbackgenerator.prepare()
            impactFeedbackgenerator.impactOccurred()
        }
        NotificationCenter.default.post(name: Notification.Name(rawValue: "addTapped"), object: self)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == self.tableView {
            return 1
        } else {
            return 2
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.tableView {
            return self.notifications.count
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == self.tableView {
            if self.notifications.isEmpty {
                self.fetchNotifications()
                let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsCell", for: indexPath) as! NotificationsCell
                cell.backgroundColor = GlobalStruct.baseDarkTint
                let bgColorView = UIView()
                bgColorView.backgroundColor = UIColor.clear
                cell.selectedBackgroundView = bgColorView
                return cell
            } else {
                if self.notifications[indexPath.row].id == "loadmorehere" {
                    
                    let cell = tableView.dequeueReusableCell(withIdentifier: "LoadMoreCell", for: indexPath) as! LoadMoreCell
                    cell.backgroundColor = UIColor(named: "lighterBaseWhite")!
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = UIColor.clear
                    cell.selectedBackgroundView = bgColorView
                    return cell
                    
                } else if self.notifications[indexPath.row].status?.mediaAttachments.isEmpty ?? true {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsCell", for: indexPath) as! NotificationsCell
                    cell.configure(self.notifications[indexPath.row])
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewProfile(_:)))
                    cell.profile.tag = indexPath.row
                    cell.profile.addGestureRecognizer(tap)
                    let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.viewProfile2(_:)))
                    cell.profile2.tag = indexPath.row
                    cell.profile2.addGestureRecognizer(tap2)
                    if indexPath.row == self.notifications.count - 10 {
                        self.fetchMoreNotifications()
                    }

                    cell.content.handleMentionTap { (string) in
                    if UserDefaults.standard.value(forKey: "sync-haptics") as? Int == 0 {
                        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
                        impactFeedbackgenerator.prepare()
                        impactFeedbackgenerator.impactOccurred()
                    }
                        let vc = FifthViewController()
                        vc.isYou = false
                        vc.isTapped = true
                        vc.userID = string
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    cell.content.handleHashtagTap { (string) in
                    if UserDefaults.standard.value(forKey: "sync-haptics") as? Int == 0 {
                        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
                        impactFeedbackgenerator.prepare()
                        impactFeedbackgenerator.impactOccurred()
                    }
                        let vc = HashtagViewController()
                        vc.theHashtag = string
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    cell.content.handleURLTap { (string) in
                    if UserDefaults.standard.value(forKey: "sync-haptics") as? Int == 0 {
                        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
                        impactFeedbackgenerator.prepare()
                        impactFeedbackgenerator.impactOccurred()
                    }
                        GlobalStruct.tappedURL = string
                        ViewController().openLink()
                    }
                    
                    cell.backgroundColor = GlobalStruct.baseDarkTint
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = UIColor.clear
                    cell.selectedBackgroundView = bgColorView
                    return cell
                } else {
                    let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationsImageCell", for: indexPath) as! NotificationsImageCell
                    cell.configure(self.notifications[indexPath.row])
                    let tap = UITapGestureRecognizer(target: self, action: #selector(self.viewProfile(_:)))
                    cell.profile.tag = indexPath.row
                    cell.profile.addGestureRecognizer(tap)
                    let tap2 = UITapGestureRecognizer(target: self, action: #selector(self.viewProfile2(_:)))
                    cell.profile2.tag = indexPath.row
                    cell.profile2.addGestureRecognizer(tap2)
                    if indexPath.row == self.notifications.count - 10 {
                        self.fetchMoreNotifications()
                    }

                    cell.content.handleMentionTap { (string) in
                    if UserDefaults.standard.value(forKey: "sync-haptics") as? Int == 0 {
                        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
                        impactFeedbackgenerator.prepare()
                        impactFeedbackgenerator.impactOccurred()
                    }
                        let vc = FifthViewController()
                        vc.isYou = false
                        vc.isTapped = true
                        vc.userID = string
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    cell.content.handleHashtagTap { (string) in
                    if UserDefaults.standard.value(forKey: "sync-haptics") as? Int == 0 {
                        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
                        impactFeedbackgenerator.prepare()
                        impactFeedbackgenerator.impactOccurred()
                    }
                        let vc = HashtagViewController()
                        vc.theHashtag = string
                        self.navigationController?.pushViewController(vc, animated: true)
                    }
                    cell.content.handleURLTap { (string) in
                    if UserDefaults.standard.value(forKey: "sync-haptics") as? Int == 0 {
                        let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
                        impactFeedbackgenerator.prepare()
                        impactFeedbackgenerator.impactOccurred()
                    }
                        GlobalStruct.tappedURL = string
                        ViewController().openLink()
                    }
                    
                    cell.backgroundColor = GlobalStruct.baseDarkTint
                    let bgColorView = UIView()
                    bgColorView.backgroundColor = UIColor.clear
                    cell.selectedBackgroundView = bgColorView
                    return cell
                }
            }
        } else {
            if indexPath.section == 0 {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell", for: indexPath) as! GraphCell
                if self.notifications.isEmpty {} else {
                    cell.configure(self.notifications)
                }
                cell.backgroundColor = GlobalStruct.baseDarkTint
                let bgColorView = UIView()
                bgColorView.backgroundColor = .clear
                cell.selectedBackgroundView = bgColorView
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: "GraphCell2", for: indexPath) as! GraphCell2
                if self.notifications.isEmpty {} else {
                    cell.configure(self.notifications)
                }
                cell.backgroundColor = GlobalStruct.baseDarkTint
                let bgColorView = UIView()
                bgColorView.backgroundColor = .clear
                cell.selectedBackgroundView = bgColorView
                return cell
            }
        }
    }
    
    func fetchNotifications() {
        let request = Notifications.all(range: .default)
        GlobalStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                DispatchQueue.main.async {
                    self.notifications = stat
                    self.tableView.reloadData()
                }
            }
        }
    }
    
    func fetchMoreNotifications() {
        let request = Notifications.all(range: .max(id: self.notifications.last?.id ?? "", limit: nil), typesToExclude: self.notTypes)
        GlobalStruct.client.run(request) { (statuses) in
            if let stat = (statuses.value) {
                if stat.isEmpty {} else {
                    DispatchQueue.main.async {
                        let indexPaths = ((self.notifications.count)..<(self.notifications.count + stat.count)).map {
                            IndexPath(row: $0, section: 0)
                        }
                        self.notifications.append(contentsOf: stat)
                        self.tableView.beginUpdates()
                        self.tableView.insertRows(at: indexPaths, with: UITableView.RowAnimation.none)
                        self.tableView.endUpdates()
                    }
                }
            }
        }
    }
    
    @objc func viewProfile(_ gesture: UIGestureRecognizer) {
        let vc = FifthViewController()
        if self.tableView.alpha == 1 {
            if let stat = self.notifications[gesture.view!.tag].status {
                if GlobalStruct.currentUser.id == (stat.account.id) {
                    vc.isYou = true
                } else {
                    vc.isYou = false
                }
                vc.pickedCurrentUser = stat.account
                self.navigationController?.pushViewController(vc, animated: true)
            } else {
                if GlobalStruct.currentUser.id == (self.notifications[gesture.view!.tag].account.id) {
                    vc.isYou = true
                } else {
                    vc.isYou = false
                }
                vc.pickedCurrentUser = self.notifications[gesture.view!.tag].account
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    @objc func viewProfile2(_ gesture: UIGestureRecognizer) {
        let vc = FifthViewController()
        if GlobalStruct.currentUser.id == (self.notifications[gesture.view!.tag].account.id) {
            vc.isYou = true
        } else {
            vc.isYou = false
        }
        vc.pickedCurrentUser = self.notifications[gesture.view!.tag].account
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        if tableView == self.tableView {
            if self.notifications[indexPath.row].id == "loadmorehere" {
                if UserDefaults.standard.value(forKey: "sync-haptics") as? Int == 0 {
                    let impactFeedbackgenerator = UIImpactFeedbackGenerator(style: .light)
                    impactFeedbackgenerator.prepare()
                    impactFeedbackgenerator.impactOccurred()
                }
                if let cell = self.tableView.cellForRow(at: indexPath) as? LoadMoreCell {
                    cell.configure()
                }
                self.fetchGap()
            } else {
                if self.notifications[indexPath.row].type == .direct {
                    
                } else if self.notifications[indexPath.row].type == .follow {
                    let vc = FifthViewController()
                    vc.isYou = false
                    vc.pickedCurrentUser = self.notifications[indexPath.row].account
                    self.navigationController?.pushViewController(vc, animated: true)
                } else {
                    let vc = DetailViewController()
                    vc.pickedStatusesHome = [self.notifications[indexPath.row].status!]
                    self.navigationController?.pushViewController(vc, animated: true)
                }
            }
        } else {
            
        }
    }
    
//    func tableView(_ tableView: UITableView,
//                   contextMenuConfigurationForRowAt indexPath: IndexPath,
//                   point: CGPoint) -> UIContextMenuConfiguration? {
//        return UIContextMenuConfiguration(identifier: indexPath as NSIndexPath, previewProvider: { return nil }, actionProvider: { suggestedActions in
//            if tableView == self.tableView {
//                if self.notifications[indexPath.row].id == "loadmorehere" {
//                    return nil
//                } else {
//                    return self.makeContextMenu([self.notifications[indexPath.row]], indexPath: indexPath)
//                }
//            } else {
//                return nil
//            }
//        })
//    }
//
//    func makeContextMenu(_ notifications: [Notificationt], indexPath: IndexPath) -> UIMenu {
//        let remove = UIAction(title: "Remove".localized, image: UIImage(systemName: "xmark"), identifier: nil) { action in
//            let request = Notifications.dismiss(id: notifications[0].id)
//            GlobalStruct.client.run(request) { (statuses) in
//                DispatchQueue.main.async {
//                    self.tableView.deleteRows(at: [indexPath], with: .none)
//                    self.notifications.remove(at: indexPath.row)
//                }
//            }
//        }
//        remove.attributes = .destructive
//        return UIMenu(__title: "", image: nil, identifier: nil, children: [remove])
//    }
    
    func removeTabbarItemsText() {
        if let items = self.tabBarController?.tabBar.items {
            for item in items {
                item.title = ""
            }
        }
    }
}
