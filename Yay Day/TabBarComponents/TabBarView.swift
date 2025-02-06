//
//  TabBarView.swift
//  Yay Day
//
//  Created by Anders Staal on 10/09/2024.
//



import Foundation
import SwiftUI
import UIKit
import Combine


struct TabBarView: View {
    
    @StateObject private var viewModel1 = EventViewModelDays()
    @StateObject private var viewModel2 = EventViewModelByCategory2()
    @StateObject private var viewModel3 = EventViewModelByCategory()
    @StateObject private var viewModel4 = EventViewModelWeek()
    @StateObject private var viewModel = EventViewModel()
    @StateObject private var viewModel8 = FreeEventsViewModel()
    @ObservedObject var translationManager = TranslationManager.shared
    @State private var isModalPresented = false

     
    
    
    
    
    var body: some View {
        VStack(spacing: 0) {
            TabView {
                NavigationStack {
                    ContentView(viewModel1: viewModel1,
                                viewModel2: viewModel2,
                                viewModel3: viewModel3,
                                viewModel4: viewModel4,
                                viewModel8: viewModel8)
                }
                
                .tabItem {
                    Image(systemName: "house.fill")
                    Text(translationManager.translate("Home"))
                    
                }
                
                
                NavigationStack {
                       RandomEventModalView() // This is now a full page
                   }
                   .tabItem {
                       Image(systemName: "questionmark.circle.fill")
                       Text("Prøv lykken")
                   }
                
                NavigationStack {
                    FilterView2()
                }
                
                .tabItem {
                    Image(systemName: "slider.horizontal.3")
                    Text(translationManager.translate("Filtrering"))
                    
                }
                
                NavigationStack {
                    SettingsPage()
                }
                
                .tabItem {
                    Image(systemName: "wrench.and.screwdriver")
                    Text(translationManager.translate("Settings"))
                    
                }
                
                NavigationStack {
                    FavouritesPage(events: viewModel.events)
                }
                
                .tabItem {
                    Image(systemName: "heart.fill")
                    Text(translationManager.translate("Favoritter"))
                    
                }
                
                
                
                
            }
            .ignoresSafeArea(edges: .top)
            .sheet(isPresented: $isModalPresented) {
                RandomEventModalView()
                
            }

                Divider()
                    .frame(height: 1)
                    .background(Color.gray.opacity(0.7))
                    .offset(y: -82)
            }
            
            
            .onAppear {
                Task {
                    await viewModel.fetchEvents(from: "https://api.yayx.dk/event/eventFilterMain")
                }
                setupTabBarAppearance()
            }
            .edgesIgnoringSafeArea(.bottom)
            
            }
    
    
    private func setupTabBarAppearance() {
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        
        // Customize background color
        appearance.backgroundColor = UIColor(
            red: 0.99,
            green: 0.97,
            blue: 0.88,
            alpha: 0.9
        )
        
        // Customize unselected tab item color
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.gray.withAlphaComponent(0.8)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.gray.withAlphaComponent(0.8)
            
        ]
        
        // Customize selected tab item color with orange opacity
        appearance.stackedLayoutAppearance.selected.iconColor = UIColor.orange.withAlphaComponent(0.7)
        appearance.stackedLayoutAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor.orange.withAlphaComponent(0.7)
        ]
        
        // Apply appearance to the TabBar
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    

}
