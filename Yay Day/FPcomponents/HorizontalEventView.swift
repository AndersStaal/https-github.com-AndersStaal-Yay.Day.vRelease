//
//  HorizontalEventView.swift
//  Yay Day
//
//  Created by Anders Staal on 19/09/2024.
//

import Foundation

import SwiftUI
import CoreLocation
import Combine

struct HorizontalEventView: View {
    var events: [Event] 
    @State private var isFavorite: Bool = false
    @ObservedObject var translationManager = TranslationManager.shared

    private var duplicatedEvents: [Event] { Array(repeating: events, count: 3).flatMap { $0 } }
    
    @State private var userLocation: CLLocationCoordinate2D? = nil
     
    
    let pastelDarkGreen = Color(red: 0.2, green: 0.5, blue: 0.3)
    
    
    
         
    var body: some View {
        VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 10) {
                        ForEach(0..<events.count, id: \.self) { index in
                            let event = events[index]
                            eventCard(event: event)
                        }
                    }
                    .padding(.horizontal, 10)
                }
                .frame(height: 290)
            }
        
        }

        private func eventCard(event: Event) -> some View {
            NavigationLink(destination: EventInfoPage(event: event, userLocation: userLocation)) {
              
                    VStack(alignment: .center, spacing: 5) {
                        
                        if let url = URL(string: event.imageUrl) {
                            AsyncImage(url: url) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 270, height: 172)
                                    .clipped()
                                    .shadow(color: Color.black.opacity(0.5), radius: 1, x: 1, y: 1)
                                
                                    .clipShape(RoundedCorners(radius: 10, corners: [.topLeft, .topRight]))
                                
                                    .overlay(
                                        ZStack {
                                            Color.gray.opacity(0.1)
                                                .frame(width: 270, height: 30)
                                                .clipShape(RoundedCorners(radius: 10, corners: [.topLeft, .topRight]))
                                                .offset(y: -5)
                                            
                                            
                                            HStack {
                                                Image(systemName: "calendar")
                                                    .foregroundColor(.white)
                                                    .offset(x: -20)
                                                    .offset(y: -2)
                                                
                                                if let formattedDate = formatDate(from: event.startDate) {
                                                    Text(formattedDate)
                                                        .font(.custom("Helvetica Neue", size: 16))
                                                        .tracking(1)
                                                        .fontWeight(.bold)
                                                        .foregroundColor(.white)
                                                        .multilineTextAlignment(.center)
                                                    
                                                        .offset(y: -2)
                                                } else {
                                                    Text("Invalid Date")
                                                        .font(.subheadline)
                                                        .foregroundColor(.red)
                                                }
                                                
                                                
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
                                                        .offset(x: 18)
                                                        .offset(y: -1)
                                                }
                                            }
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                        },
                                        
                                        alignment: .top
                                    )
                                
                            } placeholder: {
                                ProgressView()
                            }
                        }
                        Text(event.title)
                            .font(.custom("Helvetica Neue", size: 16))
                            .fontWeight(.semibold)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundColor(.black.opacity(0.9))
                           // .offset(x: 2)
                            .padding(.horizontal, 4)
                        
                          
                        
                        Text(event.translatedDescription.prefix(43))

                            .font(.custom("Helvetica Neue", size: 14))
                            .padding(.vertical, 2)
                            .foregroundColor(.black.opacity(0.9))
                           // .offset(x: -2)
                            .padding(.horizontal, 2)
                        
                        HStack(spacing: 20) {
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.red.opacity(0.9))
                                    .offset(y: -4)
                                    .offset(x: 3)
                                Text(event.place)
                                    .font(.custom("Helvetica Neue", size: 15))
                                    .foregroundColor(.black.opacity(0.55))
                                    .fontWeight(.semibold)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                            }
                            
                            HStack {
                                Image(systemName: "wallet.pass")
                                    .foregroundColor(pastelDarkGreen)
                                    .offset(x: -5)
                                    .fontWeight(.semibold)
                                Text("\(Int(event.price)) kr")
                                    .font(.custom("Helvetica Neue", size: 15))
                                    .foregroundColor(.black.opacity(0.55))
                                    .fontWeight(.semibold)
                                    .offset(x: -10)
                            }
                        }
                        
                    
                    
                }
                
                .frame(width: 270, height: 250)
            
                
                .background(Color.orange.opacity(0.1))
                
                .cornerRadius(10)
                LocationManagerWrapper(userLocation: $userLocation)
                    .frame(height: 0)
                
            }
            
        }
    
    
    }


struct RoundedCorners: Shape {
    var radius: CGFloat = 20
    var corners: UIRectCorner = [.topLeft, .topRight]

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
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
 
func toggleFavorite(event: Event) {
    var savedEventIDs = UserDefaults.standard.array(forKey: "favourites") as? [String] ?? []
    if isFavorited(event: event) {
        savedEventIDs.removeAll { $0 == event.id }
    } else {
        savedEventIDs.append(event.id)
    }
    UserDefaults.standard.set(savedEventIDs, forKey: "favourites")
}

func isFavorited(event: Event) -> Bool {
    let savedEventIDs = UserDefaults.standard.array(forKey: "favourites") as? [String] ?? []
    return savedEventIDs.contains(event.id)
}

