//
//  SeeMoreDesign.swift
//  Yay Day
//
//  Created by Anders Staal on 26/09/2024.
//

import Foundation

import SwiftUI
import CoreLocation

struct EventListView: View {
    var events: [Event]
    
   
    var body: some View {

        
        NavigationView {
            ScrollView {
                VStack(spacing: 0) {
                    if events.isEmpty {
                           Text("No events available")
                               .foregroundColor(.gray)
                               .padding()
                       } else {
                           ForEach(events) { event in
                               EventRowView(event: event)
                           }
                       }
                   }
                                   .padding(.vertical, 1)
                                   .navigationTitle("Events")
                               }
                           }
                           .background(Color(red: 0.99, green: 0.97, blue: 0.88))
                       }
                   }

struct EventRowView: View {
    var event: Event
    @State private var userLocation: CLLocationCoordinate2D? = nil
    @ObservedObject var translationManager = TranslationManager.shared
    
    let pastelDarkGreen = Color(red: 0.2, green: 0.5, blue: 0.3)
    @State private var isFavorite: Bool = false
    
    var body: some View {
        
        
            NavigationLink(destination: EventInfoPage(event: event, userLocation: userLocation)) {
                VStack(alignment: .center, spacing: 4) {
                    if let url = URL(string: event.imageUrl), !event.imageUrl.isEmpty {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView() // Loading spinner
                                    .scaledToFill()
                                    .frame(width: 380, height: 170)
                                    .clipShape(RoundedCorners6(radius: 10, corners: [.topLeft, .topRight]))
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 380, height: 170)
                                    .clipped()
                                
                                
                                    .overlay(
                                        ZStack {
                                            Color.gray.opacity(0.2)
                                                .frame(width: 380, height: 40)
                                                .clipShape(RoundedCorners6(radius: 10, corners: [.topLeft, .topRight]))
                                                .offset(y: -1)
                                            
                                            
                                            
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
                                        }
                                        ,
                                        
                                        alignment: .top
                                    )
                                    .accessibilityLabel("Image for \(event.title)")
                            case .failure:
                                
                                
                                EmptyView()
                            }
                        }
                    }
                                        
                    
                    Text(event.title.isEmpty ? "No Title Available" : event.title)
                        .font(.custom("Helvetica Neue", size: 18))
                        .fontWeight(.semibold)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundColor(.black.opacity(0.9))
                        .padding(.horizontal, 8)
                        .accessibilityLabel("Event title: \(event.title.isEmpty ? "No Title Available" : event.title)")
                    
                    Text(
                        event.translatedDescription.isEmpty ?
                            (event.description["dk"] ?? "Event description not available") :
                            event.translatedDescription
                    )
                    .font(.custom("Helvetica Neue", size: 14))
            
                    .font(.system(size: 15))
                    .foregroundColor(.black)
                    .padding(.horizontal, 8)
                    .offset(y: -2)
                    .padding(.bottom, 15)
                    .accessibilityLabel("Description: \(event.translatedDescription.isEmpty ? (event.description["dk"] ?? "Event description not available") : event.translatedDescription)")

                        
                        
                    
                    
                    
                    
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
                    .offset(y: -15)
                    .padding(.horizontal, 10)
                    
                    HStack(spacing: 3) {
                        Image(systemName: "tag.fill")
                            .foregroundColor(.orange)
                            .offset(x: -2)

                        Text(translationManager.translate(event.categoryName))
                            .font(.custom("Helvetica Neue", size: 16))
                            .foregroundColor(.black.opacity(0.5))
                            .fontWeight(.semibold)
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
                    .offset(y: -15)
                    .padding(.horizontal, 10)
                }
                .padding(.vertical, 1)
                .frame(width: 380, height: 260)
                .background(Color(red: 0.99, green: 0.97, blue: 0.88))
                .cornerRadius(10)
                .offset(x: 13)
               // .shadow(radius: 1)
                LocationManagerWrapper(userLocation: $userLocation)
                    .frame(height: 0)
            }
            .buttonStyle(PlainButtonStyle())
            
            .shadow(radius: 1)
        
        
    }
    
}

struct RoundedCorners6: Shape {
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

