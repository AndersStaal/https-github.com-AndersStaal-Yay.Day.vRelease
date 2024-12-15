//
//  EventViewmodel.swift
//  Yay Day
//
//  Created by Anders Staal on 10/09/2024.
//

import Foundation
import Combine

class EventViewModel: ObservableObject {
    @Published var events: [Event] = []
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    func fetchEvents(from url: String) async {
        print("Starting fetchEvents with URL: \(url)")
        
        do {
            let fetchedEvents = try await performAPICall(from: url)
            print("Successfully fetched \(fetchedEvents.count) events")
            
            DispatchQueue.main.async {
                self.events = fetchedEvents
                print("Updated events in ViewModel")
            }
        } catch {
            print("Error fetching events: \(error)")
            DispatchQueue.main.async {
                self.events = []
                print("Set events to empty due to error")
            }
        }
    }
    
    private func performAPICall(from urlString: String) async throws -> [Event] {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        if let jsonString = String(data: data, encoding: .utf8) {
            print("API Response: \(jsonString)")
        }
        
        let decoder = JSONDecoder()
        
        let apiResponse = try decoder.decode(APIResponse.self, from: data)
        
        return apiResponse.data.events
    }
}
