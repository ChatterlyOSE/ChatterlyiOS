//
//  NotificationService.swift
//  Mast Push
//
//  Created by Shihab Mehboob on 25/09/2019.
//  Copyright © 2019 Shihab Mehboob. All rights reserved.
//

import UserNotifications
import Foundation
import UIKit

class NotificationService: UNNotificationServiceExtension {
    
    var contentHandler: ((UNNotificationContent) -> Void)?
    var bestAttemptContent: UNMutableNotificationContent?
    
    override func didReceive(_ request: UNNotificationRequest, withContentHandler contentHandler: @escaping (UNNotificationContent) -> Void) {
        self.contentHandler = contentHandler
        bestAttemptContent = (request.content.mutableCopy() as? UNMutableNotificationContent)
        
        if let bestAttemptContent = bestAttemptContent {
            // Modify the notification content here...
            
            guard let storedState = PushNotificationReceiver.getSate() else {
                contentHandler(bestAttemptContent)
                return
            }
            
            NotificationCenter.default.post(name: Notification.Name(rawValue: "refpush1"), object: nil)
            
            if let content = try? bestAttemptContent.decrypt(state: storedState) {
                if content.notificationType == .follow {} else {
                    if let userDefaults = UserDefaults(suiteName: "group.me.chatterly.mobile.wormhole") {
                        userDefaults.set(content.notificationId, forKey: "notidpush")
                    }
                }
                
                // Mark the message as still encrypted.
                bestAttemptContent.title = content.title
                bestAttemptContent.body = content.body.replacingOccurrences(of: "&#39;", with: "'").replacingOccurrences(of: "&lt;", with: "<").replacingOccurrences(of: "&gt;", with: ">").replacingOccurrences(of: "&amp;", with: "&").replacingOccurrences(of: "&quot;", with: "\"")

                if let userDefaults = UserDefaults(suiteName: "group.me.chatterly.mobile.wormhole") {
                    if let z = userDefaults.value(forKey: "badgec") as? Int {
                        bestAttemptContent.badge = NSNumber(value: (z + 1))
                        userDefaults.set(bestAttemptContent.badge?.intValue ?? 1, forKey: "badgec")
                    } else {
                        bestAttemptContent.badge = NSNumber(value: 1)
                        userDefaults.set(1, forKey: "badgec")
                    }
                }
            }
            contentHandler(bestAttemptContent)
        }
    }
    
    override func serviceExtensionTimeWillExpire() {
        // Called just before the extension will be terminated by the system.
        // Use this as an opportunity to deliver your "best attempt" at modified content, otherwise the original push payload will be used.
        if let contentHandler = contentHandler, let bestAttemptContent = bestAttemptContent {
            contentHandler(bestAttemptContent)
        }
    }
    
}

