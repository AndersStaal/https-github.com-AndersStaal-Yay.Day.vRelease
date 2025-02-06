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
import EventKit


struct HorizontalEventView: View {
    var events: [Event]
    @State private var isFavorite: Bool = false
    @ObservedObject var translationManager = TranslationManager.shared
    
    
    @State private var userLocation: CLLocationCoordinate2D? = nil
    @State private var eventAddedFor: String?

    
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
            .frame(height: 300)
            
        }
    }
    
    private func eventCard(event: Event) -> some View {
        return NavigationLink(destination: EventInfoPage(event: event, userLocation: userLocation)) {
            VStack(alignment: .center, spacing: 5) {
                // Load Image with Overlay
                if let url = URL(string: event.imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView() // Loading spinner
                                .frame(width: 270, height: 175)
                                .clipShape(RoundedCorners(radius: 10, corners: [.topLeft, .topRight]))
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill()
                                .frame(width: 270, height: 174)
                                .clipped()
                                .clipShape(RoundedCorners(radius: 10, corners: [.topLeft, .topRight]))
                                .overlay(
                                    ZStack {
                                        Color.gray.opacity(0.2)
                                            .frame(width: 270, height: 30)
                                            .clipShape(RoundedCorners(radius: 10, corners: [.topLeft, .topRight]))
                                            .offset(y: -2)
                                        
                                        HStack {
                                            Button(action: {
                                                let eventStore = EKEventStore()
                                                switch EKEventStore.authorizationStatus(for: .event) {
                                                case .notDetermined:
                                                    requestCalendarAccess { granted in
                                                        if granted {
                                                            addEventToCalendar(title: event.title, startDate: event.startDateAsDate)
                                                            eventAddedFor = event.id // Set the added event's ID
                                                            
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                                eventAddedFor = nil // Reset after 1 second
                                                            }
                                                        }
                                                    }
                                                case .authorized:
                                                    addEventToCalendar(title: event.title, startDate: event.startDateAsDate)
                                                    eventAddedFor = event.id
                                                    
                                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                        eventAddedFor = nil
                                                    }
                                                case .denied, .restricted:
                                                    print("Access to calendar is denied or restricted")
                                                @unknown default:
                                                    print("Unknown authorization status")
                                                }
                                            }) {
                                                Image(systemName: "calendar")
                                                    .foregroundColor(.white)
                                                    .font(.system(size: 22))
                                                    .offset(x: -14)
                                                    .offset(y: -1)
                                            }
                                            .accessibilityLabel("Add \(event.title) to calendar")
                                            
                                            if eventAddedFor == event.id {
                                                Text("Event added to calendar")
                                                    .font(.footnote)
                                                    .foregroundColor(.white)
                                                    .transition(.opacity)
                                                    .animation(.easeInOut, value: eventAddedFor)
                                                    .frame(maxWidth: .infinity)
                                                    .background(Color.black.opacity(0.7))
                                                    .cornerRadius(8)
                                                    .padding(.top, 10)
                                            }
                                            
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
                                                    .font(.system(size: 22))
                                                    .animation(.easeInOut, value: isFavorite)
                                                    .cornerRadius(15)
                                                    .offset(x: 18, y: -2)
                                            }
                                        }
                                        .padding(.horizontal, 8)
                                        .padding(.vertical, 4)
                                    },
                                    alignment: .top
                                )
                        case .failure:
                            
                            
                            EmptyView()
                        }
                    }
                    
                }
                        
                        
                        
                      
                   
                
                Text(event.title)
                    .font(.custom("Helvetica Neue", size: 16))
                    .fontWeight(.semibold)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundColor(.black.opacity(0.9))
                    .padding(.horizontal, 3)
                
                Text(event.translatedDescription.prefix(60))
                    .font(.custom("Helvetica Neue", size: 14))
                    .foregroundColor(.black.opacity(0.9))
                    .padding(.horizontal, 2)
                
                HStack(spacing: 20) {
                    HStack {
                        Image("LocationPic") // Use your asset name
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15)
                            .offset(x: 3)
                        Text(event.place)
                            .font(.custom("Helvetica Neue", size: 15))
                            .foregroundColor(.black.opacity(0.7))
                            .fontWeight(.semibold)
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image("ReceiptPic") // Use your asset name
                            .resizable()
                            .scaledToFit()
                            .frame(width: 15, height: 15) // Adjust size as needed
                            .padding(.horizontal, 3)
                        Text("\(Int(event.price)) kr")
                            .font(.custom("Helvetica Neue", size: 15))
                            .foregroundColor(.black.opacity(0.7))
                            .fontWeight(.semibold)
                            .offset(x: -3)
                    }
                }
                

                
                
                
            }
            .frame(width: 270, height: 244)
            
            .background(Color(red: 0.99, green: 0.97, blue: 0.88))
            .cornerRadius(10)
            .padding(.bottom, 10)
            LocationManagerWrapper(userLocation: $userLocation)
                .frame(height: 0)
            
        }
        .shadow(radius: 1)
    }
    
    
}

    
    
    struct RoundedCorners: Shape {
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
    
    
    
    private func addEventToCalendar(title: String, startDate: Date?) {
        // Code for adding event to the calendar
        guard let startDate = startDate else { return }
        
        let eventStore = EKEventStore()
        
        let newEvent = EKEvent(eventStore: eventStore)
        newEvent.title = title
        newEvent.startDate = startDate
        newEvent.endDate = startDate.addingTimeInterval(3600) // Example duration of 1 hour
        newEvent.calendar = eventStore.defaultCalendarForNewEvents
        
        do {
            try eventStore.save(newEvent, span: .thisEvent)
            print("Event added to calendar successfully")
        } catch {
            print("Error adding event to calendar: \(error)")
        }
    }
    
    private func requestCalendarAccess(completion: @escaping (Bool) -> Void) {
        let eventStore = EKEventStore()
        eventStore.requestAccess(to: .event) { granted, error in
            completion(granted)
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

    

