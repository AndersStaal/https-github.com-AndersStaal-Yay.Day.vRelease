//
//  AppDelegate.swift
//  Yay Day
//
//  Created by Anders Staal on 25/10/2024.
//

import Foundation
import UIKit
import UserNotifications

class AppDelegate: NSObject, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
            // Request Notification Permission
            requestNotificationPermission()
            return true
        }
        
        private func requestNotificationPermission() {
            let center = UNUserNotificationCenter.current()
            center.delegate = self // Set the delegate for handling notifications
            
            // Request permission
            center.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                if let error = error {
                    print("Error requesting notification permission: \(error)")
                    return
                }
                
                if granted {
                    print("Notification permission granted")
                    DispatchQueue.main.async {
                        UIApplication.shared.registerForRemoteNotifications()
                    }
                } else {
                    print("Notification permission denied")
                }
            }
        }
        
        func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
            // Convert device token to a string
            let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
            let tokenString = tokenParts.joined()
            print("Device Token: \(tokenString)")
        }
        
        func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
            print("Failed to register for remote notifications: \(error.localizedDescription)")
        }
        
        // Handle notifications when the app is in the foreground
        func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
            // Show the notification in the foreground
            completionHandler([.alert, .sound, .badge])
        }
        
        // Handle user's interaction with the notification
        func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
            let userInfo = response.notification.request.content.userInfo
            print("Notification received: \(userInfo)")
            
            // Process the notification's user info here
            if let eventID = userInfo["eventID"] as? String {
                print("Event ID from Notification: \(eventID)")
            }
            
            completionHandler()
        }
    }
