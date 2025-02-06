//
//  CategoryViewModelFP6.swift
//  Yay Day
//
//  Created by Anders Staal on 07/11/2024.
//

import Foundation

import SwiftUI
import Combine


class EventViewModelByCategory3: ObservableObject {
    @Published var allEvents: [Event] = []
    @Published var filteredEvents: [Event] = []
    
    
    func fetchAllEvents() async {
        let urlString = "https://api.yayx.dk/event/eventFilterMain"

        do {
            let fetchedEvents = try await performAPICall(from: urlString)
            DispatchQueue.main.async {
                self.allEvents = fetchedEvents
            }
        } catch {
            print("Error fetching all events: \(error)")
        }
    }

    func fetchAndFilterEventsByCategory(categoryID: Int) async {
        await fetchAllEvents()
        DispatchQueue.main.async {
            self.filteredEvents = self.allEvents.filter { $0.categoryID == categoryID }
        }
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
 
