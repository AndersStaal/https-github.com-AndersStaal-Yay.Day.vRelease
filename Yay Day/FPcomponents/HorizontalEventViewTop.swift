//
//  HorizontalEventViewTop.swift
//  Yay Day
//
//  Created by Anders Staal on 28/11/2024.
//

import Foundation

import SwiftUI
import CoreLocation
import Combine
import EventKit

struct HorizontalEventViewTop: View {
    var events: [Event]
    @State private var isFavorite: Bool = false
    @ObservedObject var translationManager = TranslationManager.shared
    @State private var eventAddedFor: String?

    @State private var userLocation: CLLocationCoordinate2D? = nil
    @State private var currentPage: Int = 0
    
    
    
    
    
    let pastelDarkGreen = Color(red: 0.2, green: 0.5, blue: 0.3)
    
    
    
    var body: some View {
        
        VStack {
           
            
            TabView(selection: $currentPage) {
                ForEach(0..<events.count, id: \.self) { index in
                    let event = events[index]
                    eventCard(event: event)
                        .tag(index)
                }
            }
            .tabViewStyle(PageTabViewStyle())
            .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
            .frame(height: 243)
           
            
            
            .onAppear {
                UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(Color.white.opacity(0.1))
                UIPageControl.appearance().pageIndicatorTintColor = UIColor(Color.white.opacity(0.1))
            }
            
            
            HStack(spacing: 8) {
                let currentSetIndex = currentPage / 5
                let startIndex = currentSetIndex * 5
                let endIndex = min(startIndex + 5, events.count)
                
                ForEach(startIndex..<endIndex, id: \.self) { index in
                    Circle()
                        .fill(currentPage == index ? Color.orange : Color.black.opacity(0.2))
                        .frame(width: 8, height: 8)
                }
            }
            
        }
        .onChange(of: currentPage) { newValue in
            if newValue >= events.count {
                currentPage = 0
            }
        }
        
    }
    
    
    
    
    private func eventCard(event: Event) -> some View {
        NavigationLink(destination: EventInfoPage(event: event, userLocation: userLocation)) {
            VStack(alignment: .center, spacing: 5) {
                if let url = URL(string: event.imageUrl) {
                    AsyncImage(url: url) { phase in
                        switch phase {
                        case .empty:
                            ProgressView() // Loading spinner
                                .frame(width: 360, height: 170)
                                .background(Color.gray.opacity(0.2))
                                .clipShape(RoundedCorners2(radius: 10, corners: [.topLeft, .topRight]))
                        case .success(let image):
                            image
                                .resizable()
                                .scaledToFill() // Ensures the image fills the frame while keeping its aspect ratio
                                .frame(width: 360, height: 172)
                                .clipped() // Ensures any overflow is clipped
                                .clipShape(RoundedCorners2(radius: 10, corners: [.topLeft, .topRight]))
                                .overlay(
                                    ZStack {
                                        Color.gray.opacity(0.1)
                                            .frame(height: 27)
                                            .clipShape(RoundedCorners2(radius: 10, corners: [.topLeft, .topRight]))
                                            .offset(y: -3)
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
                                            
                                            Spacer()
                                            
                                            if let formattedDate = formatDate(from: event.startDate) {
                                                Text(formattedDate)
                                                    .font(.custom("Helvetica Neue", size: 18))
                                                    .tracking(1)
                                                    .fontWeight(.bold)
                                                    .foregroundColor(.white)
                                                    .multilineTextAlignment(.center)
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
                                                    .font(.system(size: 22))
                                                    .animation(.easeInOut, value: isFavorite)
                                            }
                                        }
                                        .padding(.horizontal, 10)
                                    },
                                    alignment: .top
                                )
                                .accessibilityLabel("Image for \(event.title)")
                        case .failure:
                            
                            
                            EmptyView()
                        }
                    }
                }
                
                // Display the success message when the event is added to the calendar
                
                
                
                
                
                
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
                            .frame(width: 17, height: 17) // Adjust size as needed
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
                            .frame(width: 17, height: 17) // Adjust size as needed
                        Text("\(Int(event.price)) kr")
                            .font(.custom("Helvetica Neue", size: 15))
                            .foregroundColor(.black.opacity(0.7))
                            .fontWeight(.semibold)
                            .offset(x: -3)
                    }
                }
        }
            .frame(width: 360, height: 240)
            .background(Color(red: 0.99, green: 0.97, blue: 0.88))

            .cornerRadius(10)
            .padding(.horizontal, 15)
            LocationManagerWrapper(userLocation: $userLocation)
                .frame(height: 0)

        }
        .shadow(radius: 1)
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
    
    
    
    
    
    
    struct RoundedCorners2: Shape {
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
}

