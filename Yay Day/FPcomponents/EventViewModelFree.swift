//
//  EventViewModelFree.swift
//  Yay Day
//
//  Created by Anders Staal on 18/11/2024.
//



import Foundation
import SwiftUI
import Combine

class FreeEventsViewModel: ObservableObject {
    @Published var events: [Event] = []

    init() {
        Task {
            await fetchFreeEvents()
        }
    }

    func fetchFreeEvents() async {
        let urlString = "https://api.yayx.dk/api/eventFilter?minPrice=0&maxPrice=1"

        do {
            let fetchedEvents = try await performAPICall(from: urlString)
            print("Fetched Events: \(fetchedEvents.count) events")
            DispatchQueue.main.async {
                self.events = fetchedEvents
            }
        } catch {
            print("Error fetching free events: \(error)")
            DispatchQueue.main.async {
                self.events = []
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
