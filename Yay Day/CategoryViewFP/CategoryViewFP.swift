//
//  CategoryViewFP.swift
//  Yay Day
//
//  Created by Anders Staal on 07/11/2024.
//

import Foundation
import CoreLocation
import SwiftUI

struct Category: Identifiable {
    let id: Int
    let name: String
    let imageName: String
    
    func translatedName(using translationManager: TranslationManager) -> String {
            return translationManager.translate(name)
        }
}


struct CategoryView: View {
    @StateObject var viewModel = EventViewModelByCategory3() 
    @State private var selectedCategoryID: Int? = nil
    @State private var isNavigating = false
    @ObservedObject var translationManager = TranslationManager.shared
       
       
       
    let categories: [Category] = [
        Category(id: 6, name: "Date", imageName: "DatePic"),
        Category(id: 1, name: "Kultur", imageName: "CulturePic"),
        Category(id: 9, name: "Fest", imageName: "PartyPic"),
        
        Category(id: 4, name: "Musik", imageName: "MusicPic"),
        Category(id: 2, name: "Sport", imageName: "SportPic"),
        Category(id: 15, name: "Comedy", imageName: "ComedyPic"),
        Category(id: 3, name: "Mad & Drikke", imageName: "FoodDrinkPic"),
        Category(id: 10, name: "Hygge", imageName: "HyggePic"),
        Category(id: 5, name: "Kommune", imageName: "KommunePic"),
        Category(id: 12, name: "Natur", imageName: "NaturPic"),
        Category(id: 7, name: "Solo", imageName: "SoloPic"),
        Category(id: 11, name: "Børn & Unge", imageName: "UngePic"),
        Category(id: 8, name: "Outdoor", imageName: "OutdoorsPic"),
        Category(id: 14, name: "Teater", imageName: "TeaterPic"),
        Category(id: 13, name: "Foredrag", imageName: "ForedragPic")
    ]

 
    var body: some View {
           NavigationView {
               VStack {
                   ScrollView(.horizontal, showsIndicators: false) {
                       HStack(spacing: 15) {
                           ForEach(categories) { category in
                               CategoryCardView(category: category)
                                   .onTapGesture {
                                       selectedCategoryID = category.id
                                       Task {
                                           await viewModel.fetchAndFilterEventsByCategory(categoryID: category.id)
                                           isNavigating = true
                                       }
                                   }
                           }
                       }
                       .padding()
                   }
                   .background(Color(red: 0.99, green: 0.97, blue: 0.88))
                   
                   NavigationLink(
                       destination: EventsListView(
                           viewModel: viewModel,
                           categoryID: selectedCategoryID ?? 0,
                           categoryName: categories.first { $0.id == selectedCategoryID }?.name ?? ""
                       ),
                       isActive: $isNavigating,
                       label: { EmptyView() }
                   )
               }
               
           }
       }
   }
   
struct EventsListView: View {
    @ObservedObject var viewModel: EventViewModelByCategory3
    let categoryID: Int
    let categoryName: String
    @ObservedObject var translationManager = TranslationManager.shared

    var body: some View {
        VStack {
            if viewModel.filteredEvents.isEmpty {
                Text("Ingen events desværre")
                    .font(.headline)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 105)
                    .padding(.vertical, 330)
                    .background(Color(red: 0.99, green: 0.97, blue: 0.88))
            } else {
                ScrollView(.vertical) {
                    ForEach(viewModel.filteredEvents) { event in
                        EventCardView(event: event)
                    }
                }
                .padding()
            }
        }
        .background(Color(red: 0.99, green: 0.97, blue: 0.88)) 
        .overlay(
            Rectangle()
                .frame(height: 3)
                .foregroundColor(Color.black.opacity(0.3)),
            alignment: .top
        )
        .toolbar {
                    ToolbarItem(placement: .principal) {
                        Text(translationManager.translate(categoryName))
                            .font(.custom("Helvetica Neue", size: 22))
                            .fontWeight(.semibold)
                            .foregroundColor(Color.black)
                            .lineLimit(1)
                    }
                }
            }
        }

   
   struct CategoryCardView: View {
       let category: Category
       @ObservedObject var translationManager = TranslationManager.shared

       var body: some View {
          
               VStack(spacing: 4) {
                   Image(category.imageName)
                       .resizable()
                       .scaledToFit()
                       .frame(width: 60, height: 50)
                      // .clipped()
                       //.cornerRadius(10)
                       .foregroundColor(Color.orange.opacity(0.7))
                   
                   Text(category.translatedName(using: translationManager))
                       .font(.custom("Helvetica Neue", size: 12))
                       .offset(y: -3)
                       .fontWeight(.semibold)
                       .foregroundColor(.black)
                   
                   
               }
               .frame(width: 70)
               .frame(height: 70)
               
               .background(Color.orange.opacity(0.1))
               .cornerRadius(10)
               
           }
          
       
      }

   
struct EventCardView: View {
    let event: Event
    @State private var userLocation: CLLocationCoordinate2D? = nil
    @ObservedObject var translationManager = TranslationManager.shared
    let pastelDarkGreen = Color(red: 0.2, green: 0.5, blue: 0.3)
    @State private var isFavorite: Bool = false

    
    var body: some View {
        
       
            NavigationLink(destination: EventInfoPage(event: event, userLocation: userLocation)) {
                VStack(alignment: .center, spacing: 4) {
                    if let url = URL(string: event.imageUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 380, height: 170)
                                .shadow(color: Color.black.opacity(0.5), radius: 1, x: 1, y: 1)
                                .clipShape(RoundedCorners(radius: 10, corners: [.topLeft, .topRight]))
                                .overlay(
                                    ZStack {
                                        Color.gray.opacity(0.1)
                                            .frame(width: 380, height: 40)
                                            .clipShape(RoundedCorners(radius: 10, corners: [.topLeft, .topRight]))
                                           
                                         
                                        
                                        HStack {
                                            Image(systemName: "calendar")
                                                .foregroundColor(.white)
                                                .padding(.top, 2)
                                                .font(.system(size: 20))
                                               
                                            Spacer()
                                            
                                            if let formattedDate = formatDate(from: event.startDate) {
                                                Text(formattedDate)
                                                    .font(.custom("Helvetica Neue", size: 18))
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.white)
                                                    .multilineTextAlignment(.center)
                                                    .tracking(1)
                                                
                                                  
                                            } else {
                                                Text("Invalid Date")
                                                    .font(.subheadline)
                                                    .foregroundColor(.red)
                                            }
                                            Spacer()
                                            
                                            
                                            Button(action: {
                                                withAnimation {
                                                    isFavorite.toggle()
                                                    toggleFavorite(event: event)
                                                }
                                            }) {
                                                
                                                Image(systemName: isFavorited(event: event) ? "heart.fill" : "heart")
                                                    .foregroundColor(.white)
                                                    .fontWeight(.semibold)
                                                    .animation(.easeInOut, value: isFavorite)
                                                    .font(.system(size: 20))
                                                    .cornerRadius(15)
                                                    .padding(.top, 2)
                                                  
                                            }
                                        }
                                        .padding(.horizontal, 16)
                                        .padding(.vertical, 4)
                                        .padding(.top, 10)
                                    },
                                    
                                    alignment: .top
                                )
                            
                        } placeholder: {
                            ProgressView()
                        }
                    }
                    
                    Text(event.title)
                        .font(.custom("Helvetica Neue", size: 18))
                        .fontWeight(.semibold)
                        .foregroundColor(.black.opacity(0.9))
                    
                    Text(event.translatedDescription.prefix(60))
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                        .padding(.horizontal, 8)
                        .offset(y: -2)
                        .padding(.bottom, 15)
                        
                    
                
                    
                    HStack(spacing: 8) {
                        HStack(spacing: 3) {
                            Image(systemName: "wallet.pass")
                                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.3))
                                .offset(x: -3)
                            Text("\(Int(event.price)) kr")
                                .font(.subheadline)
                                .foregroundColor(.black.opacity(0.5))
                                .fontWeight(.semibold)
                        }
                        .offset(x: 3)
                        Spacer()
                        HStack(spacing: 3) {
                            Text(event.eventPlace!)
                            .font(.custom("Helvetica Neue", size: 16))
                            .fontWeight(.semibold)
                             
                            .foregroundColor(.black.opacity(0.5))
                            
                            Image(systemName: "globe")
                                .foregroundColor(.blue)
                        }
                        
                    }
                    .padding(.horizontal, 10)
                    .offset(y: -16)
                    
                    HStack(spacing: 3) {
                        Image(systemName: "tag.fill")
                            .foregroundColor(.orange)
                            .offset(x: -2)
                        Text(translationManager.translate(event.categoryName))
                            .font(.custom("Helvetica Neue", size: 16))
                            .foregroundColor(.black.opacity(0.5))                    
                            .fontWeight(.semibold)
                            .offset(x: 1)
                        Spacer()
                        Text(event.place)
                            .font(.subheadline)
                            .offset(x: -4)
                            .foregroundColor(.black.opacity(0.5))                           
                            .fontWeight(.semibold)
                        Image(systemName: "mappin.and.ellipse")
                            .foregroundColor(.red)
                            .offset(y: -3)
                    }
                    .padding(.horizontal, 10)
                    .offset(y: -16)
                }
                .padding(.vertical, 1)
                .frame(width: 380, height: 260)
                .background(Color.orange.opacity(0.1))
                .cornerRadius(10)
                .offset(x: 4)
                
                LocationManagerWrapper(userLocation: $userLocation)
                    .frame(height: 0)
            }
            .buttonStyle(PlainButtonStyle())
            
            
        
    }
}



      
       private func dateString(from date: Date) -> String {
           let formatter = DateFormatter()
           formatter.dateStyle = .medium
           formatter.timeStyle = .none
           return formatter.string(from: date)
       }


   private func formatDate(from dateString: String) -> String? {
       let dateFormatter = DateFormatter()
       
       dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
       
       if let date = dateFormatter.date(from: dateString) {
           
           dateFormatter.dateStyle = .medium
           dateFormatter.timeStyle = .short
           dateFormatter.locale = Locale(identifier: "da_DK")
           
           return dateFormatter.string(from: date)
       }
       
       
       return nil
   }

