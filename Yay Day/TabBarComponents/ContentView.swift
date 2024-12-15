//
//  ContentView.swift
//  Yay Day // EventIt // 
//
//  Created by Anders Staal on 10/09/2024.
//



import Foundation
import SwiftUI
import Combine
import CoreLocation



struct Address: Codable {
    let type: String
    let coordinates: [Double]
}
struct EventDescription: Codable {
    let dk: String?
    let en: String?
    let original: String?
}


struct Event: Codable, Identifiable {
    var _id: String
    var description: [String: String]
    var title: String
    var startDate: String
    var endDate: String
    var price: Double
    var place: String
    var imageUrl: String
    var webUrl: String
    var ageLimit: String
    var categoryID: Int
    var categoryName: String
    var address: Address
    var eventPlace: String?
     
    var id: String { _id }
    
    var distanceFromUser: Double?
    
    var translatedDescription: String {
            let selectedLanguage = TranslationManager.shared.selectedLanguage
            return description[selectedLanguage] ?? description["dk"] ?? "No description available"
        }
    }


 



struct APIResponse: Codable {
    let status: String
    let length: Int
    let data: EventData
}

struct EventData: Codable {
    let events: [Event]
}

 

 
struct MainView: View {
    
    @State private var isSearchViewPresented = false
    
    @State private var showSplash = true // State to toggle splash screen
    
    var body: some View {
        ZStack {
            if showSplash {
                SplashScreenView(showSplash: $showSplash)
                    .transition(.opacity)
                    .ignoresSafeArea() // Covers entire screen including TabBar
            } else {
                TabBarView() // Render TabBarView only after splash is dismissed
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                withAnimation {
                    showSplash = false
                }
            }
        }
        
    }
}
               
               
               
    struct MainView_Previews: PreviewProvider {
        
        static var previews: some View {
            
            MainView()
            
        }
    } 
    
     
struct ContentView: View {
    
    @State private var showSplash = true
    @State private var userLocation: CLLocationCoordinate2D? = nil
    @ObservedObject var translationManager = TranslationManager.shared
    @State private var isSearchViewPresented = false
    
    @StateObject private var viewModel6 = EventViewModelCity()
    @ObservedObject var viewModel = EventViewModel()
    @ObservedObject var viewModel1 = EventViewModelDays()
    @ObservedObject var viewModel2 = EventViewModelByCategory2()
    @ObservedObject var viewModel3 = EventViewModelByCategory()
    @ObservedObject var viewModel4 = EventViewModelWeek()
    @ObservedObject var viewModel8 = FreeEventsViewModel()
    
    
  
     
   

    var body: some View {
        
            ScrollView {
                
              
                  

                
                
                VStack(alignment: .leading, spacing: 0) {
                    
                    
                     
                  
                    VStack(alignment: .leading, spacing: 0) {
                        
                        HStack {
                                            Button(action: {
                                                isSearchViewPresented = true
                                            }) {
                                                Image(systemName: "magnifyingglass")
                                                    .foregroundColor(.orange)
                                                    .padding()
                                                    .offset(y: -35)
                                            }
                                            
                                            Spacer()
                                            CityPickerView(viewModel: viewModel6)
                                                .frame(width: 150)
                                                .padding(.top, -15)
                                                .offset(y: -12)
                                                
                                        }
                        
                        
                        NavigationLink(destination: EventsNearYouView(userLocation: $userLocation)) {
                            Text(translationManager.translate("EventsNearYou_message"))
                                .font(.custom("Helvetica Neue", size: 18))
                                .foregroundColor(.white)
                                .padding()
                                .background(Color.orange.opacity(0.7))
                                .cornerRadius(10)
                               
                            
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 20)
                        .offset(y: -40)
                        
                        
                        HStack {
                            Text(translationManager.translate("EventsIdag"))
                                .fontWeight(.semibold)
                                .font(.custom("Helvetica Neue", size: 23))
                                .foregroundStyle(Color.black)
                            
                            
                            
                            
                            
                            Spacer()
                            
                              
                            
                            NavigationLink(destination: AllEventsView1(viewModel: viewModel1)) {
                                Text(translationManager.translate("See_more"))
                                    .font(.custom("Helvetica Neue", size: 15))
                                    .foregroundStyle(Color.black)
                                 
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.orange.opacity(0.1))
                                    .cornerRadius(10)
                            }
                           
                                  
                            
                            
                            
                        }
                        .offset(y: -30)
                        
                       
                        
                        HorizontalEventViewTop(events: viewModel1.events)
                       
                            .offset(y: -25)
                            .offset(x: 3)
                            
                       
                    } 
                    .padding(.horizontal, 2)
                        
                           CategoryView()
                               .frame(height: 85)
                           .padding(.bottom, 10)
                           .offset(y: -20)
                           .offset(x: -10)
                        
                        
                        
                        
                        
                       

                        
                        
                        HStack {
                            Text(translationManager.translate("FreeEvents"))
                                .fontWeight(.semibold)
                                .font(.custom("Helvetica Neue", size: 23))
                                .foregroundStyle(Color.black)
                            
                            
                            
                            
                            Spacer()
                            
                            
                            
                            NavigationLink(destination: AllEventsView5(viewModel: viewModel8)) {
                                Text(translationManager.translate("See_more"))
                                    .font(.custom("Helvetica Neue", size: 15))
                                    .foregroundStyle(Color.black)
                                
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.orange.opacity(0.1))
                                    .cornerRadius(10)
                                    
                                
                            }
                           
                            
                        }
                            
                            .offset(y: -25)
                        
                        
                        HorizontalEventView(events: viewModel8.events)
                       
                            .offset(y: -30)
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(translationManager.translate("Kommunen_tilbyder"))
                                .fontWeight(.semibold)
                                .font(.custom("Helvetica Neue", size: 23))
                                .foregroundStyle(Color.black)
                            
                            
                            Spacer()
                            
                            NavigationLink(destination: AllEventsView3(viewModel: viewModel2)) {
                                Text(translationManager.translate("See_more"))
                                    .font(.custom("Helvetica Neue", size: 15))
                                    .foregroundColor(.black)
                                 
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.orange.opacity(0.1))
                                    .cornerRadius(10)
                            }
                        }
                        .offset(y: -30)
                        
                        
                        
                        HorizontalEventView(events: viewModel2.events)
                      
                            .offset(y: -35)
                    }
                        
                        
                      
                    
                    VStack(alignment: .leading, spacing: 0) {
                        HStack {
                            Text(translationManager.translate("Lidt_af_hvert"))
                                .fontWeight(.semibold)
                                .font(.custom("Helvetica Neue", size: 23))
                                .foregroundStyle(Color.black)
                           
                            
                            Spacer()
                            
                            NavigationLink(destination: AllEventsView2(viewModel: viewModel3)) {
                                Text(translationManager.translate("See_more"))
                                    .font(.custom("Helvetica Neue", size: 15))
                                    .foregroundColor(.black)
                                 
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.orange.opacity(0.1))
                                    .cornerRadius(10)
                            }
                        }
                        .offset(y: -30)
                        
                        
                        
                        
                        HorizontalEventView(events: viewModel3.events)
                       
                            .offset(y: -35)
                    }
                    
                    
                 
                    
                    
                    VStack(alignment: .leading, spacing: 5) {
                        HStack {
                            Text(translationManager.translate("Denne_uge"))
                                .fontWeight(.semibold)
                                .font(.custom("Helvetica Neue", size: 23))
                                .foregroundStyle(Color.black)
                            
                            
                            Spacer()
                            
                            NavigationLink(destination: AllEventsView4(viewModel: viewModel4)) {
                                Text(translationManager.translate("See_more"))
                                    .font(.custom("Helvetica Neue", size: 15))
                                    .foregroundColor(.black)
                                 
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 6)
                                    .background(Color.orange.opacity(0.1))
                                    .cornerRadius(10)
                            }
                            
                        }
                        .offset(y: -30)
                        
                        
                        
                        HorizontalEventView(events: viewModel4.events)
                        
                       
                            .offset(y: -35)
                        
                    }
                    
                    LocationManagerWrapper(userLocation: $userLocation)
                        .frame(height: 0)
                }
                
                
                .padding(.top, 20)
                .padding(.horizontal, 10)
                
                
            }
            .background(Color(red: 0.99, green: 0.97, blue: 0.88))          
            .fullScreenCover(isPresented: $isSearchViewPresented) {
                SearchEventsView()
                
            }
        }
        
    }

    

    
           
       
    


struct SplashScreenView: View {
    @Binding var showSplash: Bool
    @State private var animateFireworks = false
    
    
    
    @StateObject private var viewModel8 = FreeEventsViewModel()
    @StateObject private var viewModel1 = EventViewModelDays()
    @StateObject private var viewModel2 = EventViewModelByCategory2()
    @StateObject private var viewModel3 = EventViewModelByCategory()
    @StateObject private var viewModel4 = EventViewModelWeek()
    
    
    
    
    
    var body: some View {
        ZStack {
            
            
            
            
            Color(red: 0.99, green: 0.97, blue: 0.88)
            
                .ignoresSafeArea()
            
            VStack {
                
                
                
                
                
                Image("YayDayLogo3")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 400, height: 400)
                    .padding(.top, 150)
                
                
                Text("Oplevelser tæt på dig")
                    .font(.custom("Helvetica Neue", size: 25))
                    .foregroundColor(.orange.opacity(0.75))
                    .fontWeight(.medium)
                
                    .offset(y: -120)
                
                
                
                
                
                
                
                FireworksAnimation(animate: animateFireworks)
                    .frame(width: 200, height: 200)
                   
                
            }
            
            .onAppear {
                
                animateFireworks = true
                startLoadingData()
            }
            .ignoresSafeArea()
        }
    }
    


    private func startLoadingData() {
            Task {
                
                await viewModel1.fetchFilteredEvents()
                await viewModel2.fetchEventsForCategories2()
                await viewModel3.fetchEventsForCategories()
                await viewModel4.fetchFilteredEvents2()
                await viewModel8.fetchFreeEvents()
                
                try? await Task.sleep(nanoseconds: 1 * 1_000_000_000)
                
              
            }
        }

   
    }









