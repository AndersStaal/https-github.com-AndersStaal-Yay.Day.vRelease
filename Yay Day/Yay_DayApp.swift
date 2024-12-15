//
//  Yay_DayApp.swift
//  Yay Day
//
//  Created by Anders Staal on 10/09/2024.
//

import SwiftUI
import Combine


@main
struct Yay_DayApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    init() {
            setupNavigationBarAppearance()
            UITraitCollection.current = UITraitCollection(userInterfaceStyle: .light) // or .dark
        
        
        
        }
    
    var body: some Scene {
            WindowGroup {
                TabBarView() 
                    .preferredColorScheme(.light)
                    //.noNavigationBar()
                    
            }
        
        }
    }

private func setupNavigationBarAppearance() {
    let appearance = UINavigationBarAppearance()
    appearance.configureWithTransparentBackground()
    appearance.backgroundColor = .clear // Set background to clear
    appearance.shadowColor = .clear // Remove shadow for a cleaner look
    
    // Apply to all navigation bars
    UINavigationBar.appearance().standardAppearance = appearance
    UINavigationBar.appearance().scrollEdgeAppearance = appearance
    UINavigationBar.appearance().compactAppearance = appearance
    UINavigationBar.appearance().isTranslucent = true
}
