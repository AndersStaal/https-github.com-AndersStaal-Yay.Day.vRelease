//
//  FilterView.swift
//  Yay Day
//
//  Created by Anders Staal on 26/09/2024.
//

import Foundation
import SwiftUI
import CoreLocation

struct Filter {
    var startDate: Date
    var endDate: Date
    var startTime: Date?
    
    var categories: [Int] = []
    var minPrice: Double
    var maxPrice: Double
}

struct FilterView2: View {
    
    @State private var filter = Filter(
        startDate: Date(),
        endDate: Date(),
        startTime: nil,
        
        categories: [],
        minPrice: 0,
        maxPrice: 500
    )
    
    struct Category {
        let id: Int
        let name: String
        
        func translatedName(using translationManager: TranslationManager) -> String {
                return translationManager.translate(name)
            }
    }

    let allCategories = [
        Category(id: 1, name: "Kultur"),
        Category(id: 2, name: "Sport"),
        Category(id: 3, name: "Mad & Drikke"),
        Category(id: 4, name: "Musik"),
        Category(id: 5, name: "Kommune"),
        Category(id: 6, name: "Date"),
        Category(id: 7, name: "Solo"),
        Category(id: 8, name: "Outdoor"),
        Category(id: 9, name: "Fest"),
        Category(id: 10, name: "Hygge"),
        Category(id: 11, name: "Børn & unge"), 
        Category(id: 12, name: "Natur"),
        Category(id: 13, name: "Foredrag"),
        Category(id: 14, name: "Teater"),
        Category(id: 15, name: "Comedy"),
        
    ]

    @State private var selectedCategories = Set<Int>()
    @State private var filteredEvents: [Event] = []
    @State private var isFilterApplied = false
    @State private var userLocation: CLLocationCoordinate2D?
    @State private var maxDistance: Double = 10000
    @State private var isStartTimeEnabled = false
    @ObservedObject var translationManager = TranslationManager.shared
    @State private var showNoMatchMessage: Bool = false


    var body: some View {
        
        
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                DatePicker(translationManager.translate("Start_date"), selection: $filter.startDate, displayedComponents: [.date])
                    .foregroundColor(Color.black)
                                
                                DatePicker(translationManager.translate("End_date"), selection: $filter.endDate, displayedComponents: [.date])
                                    .foregroundColor(Color.black)

                                HStack {
                                    Text(translationManager.translate("Start_time"))
                                        .foregroundColor(isStartTimeEnabled ? .black : .black)
                                
                                Spacer()
                                
                                Button(action: {
                                    isStartTimeEnabled.toggle()
                                }) {
                                    Image(systemName: "clock.fill")
                                        .foregroundColor(isStartTimeEnabled ? .orange : .gray)
                                }
                                .padding(15)
                                .background(isStartTimeEnabled ? Color.orange.opacity(0.2) : Color.gray.opacity(0.1))
                                .cornerRadius(8)
                            }
                            

                                if isStartTimeEnabled {
                                    DatePicker("", selection: Binding(
                                        get: { filter.startTime ?? Date() },
                                        set: { newValue in filter.startTime = newValue }
                                    ), displayedComponents: [.hourAndMinute])
                                    .datePickerStyle(CompactDatePickerStyle())
                                                        .labelsHidden()
                                    
                                }
                
                
                

                VStack(alignment: .leading, spacing: 10) {
                    Text(translationManager.translate("Kategorier"))
                        .font(.headline)
                        .foregroundColor(Color.black)
                    
                    ScrollView {
                        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 10) {
                            ForEach(allCategories, id: \.id) { category in
                                CategoryButton(category: category.translatedName(using: translationManager),
                                               isSelected: selectedCategories.contains(category.id)) {
                                    if selectedCategories.contains(category.id) {
                                        selectedCategories.remove(category.id)
                                    } else {
                                        selectedCategories.insert(category.id)
                                    }
                                }
                            }
                        }
                        .padding(.vertical, 10)
                        .frame(maxHeight: 250) 
                    }
                    .padding(.bottom, 10)
                }
                .frame(minHeight: 180)
                
                

                VStack(alignment: .leading) {
                    Text("\(translationManager.translate("Min_price")): \(Int(filter.minPrice))")
                        .foregroundColor(Color.black)
                                Slider(value: $filter.minPrice, in: 0...500)
                                
                                Text("\(translationManager.translate("Max_price")): \(Int(filter.maxPrice))")
                                    .foregroundColor(Color.black)
                                Slider(value: $filter.maxPrice, in: 0...1000)
                                
                                Text("\(translationManager.translate("Max_distance")): \(Int(maxDistance)) km")
                                    .foregroundColor(Color.black)
                                Slider(value: $maxDistance, in: 0...10000)
                }
                
                LocationManagerWrapper(userLocation: $userLocation)
                                    .frame(height: 0)

                Button(action: {
                    Task {
                        await applyFilters()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            if filteredEvents.isEmpty {
                                withAnimation {
                                    showNoMatchMessage = true
                                }
                                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                    withAnimation {
                                        showNoMatchMessage = false
                                    }
                                }
                            } else {
                                withAnimation {
                                    isFilterApplied = true
                                }
                            }
                        }
                    }
                }) {
                    Text(translationManager.translate("Apply_filter"))
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.orange.opacity(0.7))
                        .cornerRadius(10)
                        .padding(.bottom, 10)
                        .offset(y: -15)
                }
                .navigationDestination(isPresented: $isFilterApplied) {
                    if !filteredEvents.isEmpty {
                        FilteredEventsView(filteredEvents: filteredEvents)
                    }
                }

                if showNoMatchMessage {
                    Text(translationManager.translate("No_match"))
                        .font(.subheadline)
                        .foregroundColor(.black)
                        //.padding(.top, 5)
                        .transition(.opacity)
                        .offset(y: -30)
                        .offset(x: 5)
                }
            }
            .padding()

            .background(Color(red: 0.99, green: 0.97, blue: 0.88)) 
        }

    }
    
    

    func applyFilters() {
        Task {
            await fetchFilteredEvents(filter: filter, location: userLocation)
        }
    }
    
    func eventsNearYou(){
        Task{
            await fetchFilteredEvents(filter:filter, location: userLocation)
        }
    }

    func fetchFilteredEvents(filter: Filter, location: CLLocationCoordinate2D?) async {
        var queryItems = [
            URLQueryItem(name: "startDate", value: isoDateString(from: filter.startDate)),
            URLQueryItem(name: "endDate", value: isoDateString(from: filter.endDate)),
            URLQueryItem(name: "maxDistance", value: "\(maxDistance)"),
            URLQueryItem(name: "minPrice", value: "\(filter.minPrice)"),
            URLQueryItem(name: "maxPrice", value: "\(filter.maxPrice)")
        ]
        
        if let startTime = filter.startTime {
            queryItems.append(URLQueryItem(name: "startTime", value: isoTimeString(from: startTime)))
        }
        
        if let location = userLocation {
            queryItems.append(URLQueryItem(name: "longitude", value: "\(location.longitude)"))
            queryItems.append(URLQueryItem(name: "latitude", value: "\(location.latitude)"))
        }

        let categoryIDs = selectedCategories.map { "\($0)" }.joined(separator: ",")
        if !categoryIDs.isEmpty {
            queryItems.append(URLQueryItem(name: "categoryID", value: categoryIDs))
        }

        var urlComponents = URLComponents(string: "https://api.yayx.dk/api/eventFilter")!
        urlComponents.queryItems = queryItems

        guard let url = urlComponents.url else { return }

        print("Request URL: \(url)")

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        do {
            let (data, response) = try await URLSession.shared.data(for: request)

            if let httpResponse = response as? HTTPURLResponse {
                print("Response Status Code: \(httpResponse.statusCode)")
            }

            if let responseData = String(data: data, encoding: .utf8) {
                print("Response Body: \(responseData)")
            }

            let rootResponse = try JSONDecoder().decode(RootResponse.self, from: data)

            self.filteredEvents = rootResponse.data.events
            self.isFilterApplied = !rootResponse.data.events.isEmpty
        } catch {
            print("Error fetching events: \(error.localizedDescription)")
        }
    }


    struct RootResponse: Codable {
        let status: String
        let length: Int
        let data: EventsData
    }

    struct EventsData: Codable {
        let events: [Event]
    }

    func isoDateString(from date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate]
        return formatter.string(from: date)
    }

    
    func isoTimeString(from date: Date) -> String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withTime, .withColonSeparatorInTime]
        return formatter.string(from: date)
    }
}
