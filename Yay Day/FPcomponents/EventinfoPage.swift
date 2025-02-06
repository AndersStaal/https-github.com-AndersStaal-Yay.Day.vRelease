//
//  EventinfoPage.swift
//  Yay Day
//
//  Created by Anders Staal on 10/09/2024.
//

import Foundation
import SwiftUI
import CoreLocation
import UIKit




struct EventInfoPage: View {
    var event: Event
    var userLocation: CLLocationCoordinate2D?
    var distance: Double?

    @State private var isFavorite: Bool = false

    
    let pastelDarkGreen = Color(red: 0.2, green: 0.5, blue: 0.3)
    @State private var showBookingMessage = false
    @ObservedObject var translationManager = TranslationManager.shared
    @State private var showShareSheet = false // State to control share sheet presentation
    
    
    
    var body: some View {
        
        
        
        
        ScrollView {
            VStack(alignment: .center) {
                
                
                
                if let imageUrl = URL(string: event.imageUrl)  {
                    AsyncImage(url: imageUrl) { image in
                        image
                            .resizable()
                            .scaledToFill()
                            .frame(width: 360, height: 200)
                            .clipped()
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray) // This is a fallback placeholder color. You can replace it with an image.
                            .frame(width: 350, height: 190)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                    }
                    .shadow(color: Color.black.opacity(0.3), radius: 5, x: 0, y: -5)
                } else {
                    EmptyView()
                }
                
                
                
                Text(event.title)
                    .font(.custom("Helvetica Neue", size: 20))
                    .fontWeight(.bold)
                    .foregroundColor(Color.black)
                    .multilineTextAlignment(.center)
                    .padding(.top, 3)
                    .padding(.bottom, 1)
                
                Text(event.translatedDescription)
                
                    .font(.custom("Helvetica Neue", size: 18))
                    .padding(.bottom, 5)
                    .foregroundColor(Color.black)
                    .padding([.leading, .trailing])
                    .lineSpacing(5)
                
                
                
                
                
                HStack {
                    Button(action: {
                        if let userLocation = userLocation {
                            print("Opening map with user location: \(userLocation)")
                            openMapLocation(userLatitude: userLocation.latitude, userLongitude: userLocation.longitude)
                        } else {
                            print("User location is unavailable")
                        }
                    }) {
                        VStack {
                            Image(systemName: "map.fill")
                                .foregroundColor(pastelDarkGreen.opacity(0.8))
                                .font(.system(size: 28))
                                .padding(5)
                            Text(translationManager.translate("See_route"))
                                .font(.caption)
                                .foregroundColor(.gray)
                        }
                        .padding(.horizontal, 30)
                    }
                    Spacer()
                    
                    VStack {
                        Text(translationManager.translate("Send event til en ven?"))
                            .font(.caption)
                            .foregroundColor(.gray)
                        
                        Button(action: {
                            shareEvent() // Trigger the share action
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text(translationManager.translate("Share"))
                                    .fontWeight(.bold)
                                    .font(.system(size: 12))
                                    .offset(x: -6)
                            }
                            .padding(5)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                        }
                        .sheet(isPresented: $showShareSheet) {
                            ActivityViewController(activityItems: createEventShareText())
                        }
                    }
                    
                    Spacer()
                    Button(action: {
                        withAnimation {
                            isFavorite.toggle()
                            toggleFavorite(event: event)
                        }
                    }) {
                        VStack {
                            Image(systemName: isFavorited(event: event) ? "heart.fill" : "heart")
                                .foregroundColor(.red)
                                .padding(5)
                                .font(.system(size: 28))
                                .cornerRadius(15)
                            Text(isFavorited(event: event) ? translationManager.translate("Gemt") : translationManager.translate("Gem"))
                            
                                .font(.caption)
                                .foregroundColor(.gray)
                                .animation(.easeInOut, value: isFavorite)
                        }
                        .padding(.top, -5)
                        .padding(.horizontal, 30)
                    }
                }
                
                
                Text(translationManager.translate("Praktisk_info"))
                    .font(.headline)
                    .padding(.bottom, 10)
                    .foregroundColor(Color.black)
                
                VStack(alignment: .leading, spacing: 15) {
                    HStack(alignment: .top) {
                        
                        VStack(alignment: .leading, spacing: 15) {
                            HStack(spacing: 5) {
                                Image(systemName: "calendar")
                                    .foregroundColor(.blue.opacity(0.6))
                                    .font(.system(size: 18, weight: .bold))
                                
                                Text(formatDate(from: event.startDate) ?? "Invalid Date")
                                    .font(.subheadline)
                                    .foregroundColor(Color.black)
                                    .foregroundColor(formatDate(from: event.startDate) != nil ? .primary : .red)
                                    .padding(.leading, 5)
                                
                                Spacer()
                                
                                
                            }
                            
                            HStack(spacing: 5) {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.red.opacity(0.55))
                                    .font(.system(size: 16, weight: .bold))
                                
                                Text(event.place)
                                    .padding(.leading, 5)
                                    .foregroundColor(Color.black)
                                
                            }
                            
                            HStack(spacing: 5) {
                                Image(systemName: "creditcard")
                                    .foregroundColor(pastelDarkGreen)
                                
                                Text("\(Int(event.price)) kr")
                                    .padding(.leading, 5)
                                    .foregroundColor(Color.black)
                            }
                        }
                        .padding(.trailing, 10)
                        
                        
                        VStack(alignment: .trailing, spacing: 12) {
                            HStack {
                                
                                
                                
                                Text({
                                    if let userLocation = userLocation {
                                        let eventLocation = CLLocation(latitude: event.address.coordinates[1], longitude: event.address.coordinates[0])
                                        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
                                        let distanceInMeters = userCLLocation.distance(from: eventLocation)
                                        return String(format: "%.2f km", distanceInMeters / 1000.0)
                                    } else {
                                        return "Calculating distance..."
                                    }
                                }())
                                .font(.subheadline)
                                .foregroundColor(.black)
                                
                                
                                Image(systemName: "figure.walk")
                                    .foregroundColor(.gray)
                                    .font(.system(size: 18, weight: .bold))
                                
                                
                                
                            }
                            
                            
                            
                            HStack {
                                
                                
                                Text(event.eventPlace!)
                                
                                    .foregroundColor(Color.black)
                                
                                Image(systemName: "globe")
                                    .foregroundColor(.blue)
                                
                                
                            }
                            
                            HStack {
                                
                                Text(translationManager.translate(event.categoryName))
                                
                                    .foregroundColor(Color.black)
                                
                                
                                Image(systemName: "tag.fill")
                                    .foregroundColor(.orange)
                                
                                
                                
                            }
                        }
                        .padding(.bottom, 10)
                    }
                    .padding(.horizontal, 15)
                }
                HStack(spacing: 10) {
                   
                    
                    // Read More Button 
                    Button(action: {
                        if let url = URL(string: event.webUrl) {
                            UIApplication.shared.open(url)
                            print("URL to open: \(event.webUrl)")
                        } else {
                            print("Invalid URL: \(event.webUrl)")
                        }
                    }) {
                        Text(translationManager.translate("Book_Now"))

                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.orange.opacity(0.7))
                            .cornerRadius(15)
                    }
                    

                }
            }
                .padding(.horizontal, 15)
                .offset(y: -8)
            
        
                // Background Color for the Page
            }
            .background(Color(red: 0.99, green: 0.97, blue: 0.88))
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
    
    
    
    
    
    // Helper methods
    func createEventShareText() -> [Any] {
        let eventLink = URL(string: "yayday://event/\(event.id)")!
        let message = "Check out this event on YayDay! \(eventLink.absoluteString)"
        return [message, eventLink]
    }
    
    func shareEvent() {
        showShareSheet = true
    }
    
    
   
    
    // UIKit integration for Activity View Controller
    struct ActivityViewController: UIViewControllerRepresentable {
        let activityItems: [Any]
        let applicationActivities: [UIActivity]?
        
        init(activityItems: [Any], applicationActivities: [UIActivity]? = nil) {
            self.activityItems = activityItems
            self.applicationActivities = applicationActivities
        }
        
        func makeUIViewController(context: Context) -> UIActivityViewController {
            UIActivityViewController(activityItems: activityItems, applicationActivities: applicationActivities)
        }
        
        func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
    }
    
    
    
    func isFavorited(event: Event) -> Bool {
        let savedEventIDs = UserDefaults.standard.array(forKey: "favourites") as? [String] ?? []
        return savedEventIDs.contains(event.id)
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
    
    func openMapLocation(userLatitude: Double, userLongitude: Double) {
        let eventLatitude = event.address.coordinates[1]
        let eventLongitude = event.address.coordinates[0]
        let mapUrlString = "https://maps.apple.com/?saddr=\(userLatitude),\(userLongitude)&daddr=\(eventLatitude),\(eventLongitude)"
        
        
        // Debug print statements
        print("User Location: \(userLatitude), \(userLongitude)")
        print("Event Location: \(eventLatitude), \(eventLongitude)")
        print("Map URL: \(mapUrlString)")
        
        if let url = URL(string: mapUrlString) {
            UIApplication.shared.open(url, options: [:]) { success in
                if success {
                    print("Successfully opened the map URL.")
                } else {
                    print("Failed to open the map URL.")
                }
            }
        }
    }
}
