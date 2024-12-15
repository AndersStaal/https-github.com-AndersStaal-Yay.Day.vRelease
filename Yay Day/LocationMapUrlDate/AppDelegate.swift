//
//  AppDelegate.swift
//  Yay Day
//
//  Created by Anders Staal on 25/10/2024.
//

import Foundation

import UIKit

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        print("Received URL:", url)
        
        if url.scheme == "yayday", url.host == "event" {
            if let eventId = url.pathComponents.last {
                print("Event ID:", eventId)
            }
            return true
        }
        return false
    }
}
