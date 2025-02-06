//
//  RandomEventViewModel.swift
//  Yay Day
//
//  Created by Anders Staal on 28/01/2025.
//


import Foundation
import Combine

class RandomEventViewModel: ObservableObject {
    @Published var randomEvent: Event?

    func fetchRandomEvent() async {
        let urlString = "https://api.yayx.dk/event/eventFilterMain"

        do {
            let fetchedEvents = try await performAPICall(from: urlString)
            if let randomEvent = fetchedEvents.randomElement() {
                DispatchQueue.main.async {
                    self.randomEvent = randomEvent
                }
            }
        } catch {
            print("Error fetching random event: \(error)")
            DispatchQueue.main.async {
                self.randomEvent = nil
            }
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
