//
//  ViewModelCity.swift
//  Yay Day
//
//  Created by Anders Staal on 08/11/2024.
//

import Foundation


class EventViewModelCity: ObservableObject {
    @Published var allEvents: [Event] = [] 
    @Published var filteredEvents: [Event] = []
    @Published var selectedCity: String? = nil
    
    let availableCities: [String] = ["Odense", "Nyborg", "Svendborg"]
    
    func fetchAllEvents() async {
           let urlString = "https://api.yayx.dk/api/eventFilter"
           
           do {
               let fetchedEvents = try await performAPICall(from: urlString)
               DispatchQueue.main.async {
                   self.allEvents = fetchedEvents
                   self.filterEventsByCity()
               }
           } catch {
               print("Error fetching all events: \(error)")
           }
       }
       
       func filterEventsByCity() {
           guard let selectedCity = selectedCity else {
               filteredEvents = allEvents
               return
           }
           
           filteredEvents = allEvents.filter { $0.eventPlace!.lowercased() == selectedCity.lowercased() }
       }

       func selectCity(_ city: String) {
           selectedCity = city
           filterEventsByCity() 
       }
       
       private func performAPICall(from urlString: String) async throws -> [Event] {
           guard let url = URL(string: urlString) else {
               throw URLError(.badURL)
           }
           
           let (data, _) = try await URLSession.shared.data(from: url)
           
           let decoder = JSONDecoder()
           let apiResponse = try decoder.decode(APIResponse.self, from: data)
           
           return apiResponse.data.events
       }
   }
