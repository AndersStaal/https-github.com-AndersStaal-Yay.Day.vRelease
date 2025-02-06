//
//  EventsNearYouView.swift
//  Yay Day
//
//  Created by Anders Staal on 08/10/2024.
//

import Foundation
import SwiftUI
import CoreLocation
import Combine

struct EventsNearYouView: View {
    @StateObject var viewModel = EventsNearYouComp()
    @Binding var userLocation: CLLocationCoordinate2D? 
    @ObservedObject var translationManager = TranslationManager.shared
    
    var body: some View {
        VStack {
                    Text(translationManager.translate("EventsNearYou_message"))
                        .font(.custom("Helvetica Neue", size: 22))
                        .fontWeight(.bold)
                        .foregroundStyle(Color.black)
                      
                        .background(Color(red: 0.99, green: 0.97, blue: 0.88))
                    
                    if viewModel.isLoading {
                        ProgressView("Loading...")
                            .padding()
                    } else if let errorMessage = viewModel.errorMessage {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .padding()
                    } else if viewModel.filteredEvents.isEmpty {
                        VStack { 
                                            Spacer()
                                            Text("Ingen oplevelser tæt på dig :(")
                                                .font(.system(size: 20))
                                                .fontWeight(.medium)
                                                .foregroundColor(.gray)
                                                .padding()
                                                .offset(y: -200)
                                            Spacer()
                                        }
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                        .background(Color(red: 0.99, green: 0.97, blue: 0.88) .ignoresSafeArea())
                    } else {
                        ScrollView {
                            VStack(spacing: 8) {
                                ForEach(viewModel.filteredEvents) { event in
                                    EventRowViewStyled(event: event)
                                }
                            }
                            .padding(.top, 5)
                            .offset(y: 5)
                        }
                        .overlay(
                            Rectangle()
                                .frame(height: 3)
                                .foregroundColor(Color.black.opacity(0.3)),
                            alignment: .top
                        )
                    }
                }
                .onAppear {
                    if let location = userLocation {
                        viewModel.fetchEventsNearYou(userLocation: location)
                    }
                }
                .background(Color(red: 0.99, green: 0.97, blue: 0.88))
        
            }
        }

struct EventRowViewStyled: View {
    var event: Event
    @State private var userLocation: CLLocationCoordinate2D? = nil
    @ObservedObject var translationManager = TranslationManager.shared
    let pastelDarkGreen = Color(red: 0.2, green: 0.5, blue: 0.3)
    @State private var isFavorite: Bool = false

    
    var body: some View {
        
       
            NavigationLink(destination: EventInfoPage(event: event, userLocation: userLocation)) {
                VStack(alignment: .center, spacing: 5) {
                    
                    if let url = URL(string: event.imageUrl) {
                        AsyncImage(url: url) { image in
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 380, height: 170)
                                .clipped()
                                .shadow(color: Color.black.opacity(0.5), radius: 1, x: 1, y: 1)
                            
                                .clipShape(RoundedCorners5(radius: 10, corners: [.topLeft, .topRight]))
                            
                                .overlay(
                                    ZStack {
                                        Color.gray.opacity(0.2)                            .frame(width: 380, height: 40)
                                            .clipShape(RoundedCorners5(radius: 10, corners: [.topLeft, .topRight]))
                                           
                                        
                                        
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
                                        .padding(.top, 13)
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

                    
                    HStack {
                        HStack(spacing: 5) {
                            Image(systemName: "wallet.pass")
                                .foregroundColor(Color(red: 0.2, green: 0.5, blue: 0.3))
                                .offset(x: -4)
                            Text("\(Int(event.price)) kr")
                                .font(.subheadline)
                                .foregroundColor(.black.opacity(0.5))
                                .fontWeight(.semibold)
                                
                            
                        }
                        
                        Spacer()
                        
                        
                        if let distance = event.distanceFromUser {
                            HStack(spacing: 5) {
                                
                                
                                Text(String(format: "%.2f km", distance))
                                    .font(.subheadline)
                                    .foregroundColor(.black.opacity(0.5))
                                    .fontWeight(.semibold)
                                
                                Image(systemName: "location")
                                    .foregroundColor(.blue)
                                    .offset(x: 2)
                            }
                        }
                    }
                    .padding(.horizontal, 14)
                    .offset(y: -16)
                    
                    HStack(spacing: 5) {
                        
                        
                        
                        
                        HStack {
                            Image(systemName: "tag.fill")
                                .foregroundColor(.orange)
                                .offset(x: -2)

                            
                            Text(translationManager.translate(event.categoryName))
                                .font(.custom("Helvetica Neue", size: 16))
                                .foregroundColor(.black.opacity(0.5))
                                .fontWeight(.semibold)
                            
                            
                            Spacer()
                            
                            HStack {
                                
                                Text(event.place)
                                    .font(.subheadline)
                                    .foregroundColor(.black.opacity(0.5))
                                    .fontWeight(.semibold)
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.red)
                                    .offset(y: -3)
                                
                            }
                        }
                        .offset(y: -16)
                    }
                    .padding(.horizontal, 10)
                    .padding(.bottom, 5)
                    
                    
                    
                    
                    
                    
                    
                    
                }
                
                .padding(.vertical, 5)
                .frame(width: 380, height: 260)
                //.padding()
                .background(Color(red: 0.99, green: 0.97, blue: 0.88))
                .cornerRadius(10)
                .padding(.bottom, 5)
                
               
                
                
                
            
        }
            .shadow(radius: 1)
            .buttonStyle(PlainButtonStyle())
            .background(Color(red: 0.99, green: 0.97, blue: 0.88)) 
            //.edgesIgnoringSafeArea(.all)
            
            LocationManagerWrapper(userLocation: $userLocation)
                .frame(height: 0)
            
            
        
    
}

}

struct RoundedCorners5: Shape {
    var radius: CGFloat = 20
    var corners: UIRectCorner = [.topLeft, .topRight]
    
    func path(in rect: CGRect) -> Path {
        // Debug output
        
        let adjustedRadius = min(radius, min(rect.width, rect.height) / 2)
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: adjustedRadius, height: adjustedRadius)
        )
        return Path(path.cgPath)
    }
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

