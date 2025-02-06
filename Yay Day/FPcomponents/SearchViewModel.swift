//
//  SearchViewModel.swift
//  Yay Day
//
//  Created by Anders Staal on 14/11/2024.
//

import Foundation
import Combine

class SearchEventViewModel: ObservableObject {
    @Published var events: [Event] = []
    @Published var allEvents: [Event] = [] 
    @Published var searchResults: [String] = []
    private var allPlaces: [String] = []
    private var allCategories: [String] = []
    private var cancellables: Set<AnyCancellable> = []
    
    
    struct Category {
        let id: Int
        let name: String
        
        func translatedName(using translationManager: TranslationManager) -> String {
                return translationManager.translate(name)
            }
    }

    // Predefined categories
    let categories = [
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


    init() {
        Task {
            await fetchAllData()
        }
    }

    private func fetchAllData() async {
        let urlString = "https://api.yayx.dk/event/eventFilterMain"
        do {
            let fetchedEvents = try await performAPICall(from: urlString)
            DispatchQueue.main.async {
                self.allPlaces = Array(Set(fetchedEvents.map { $0.place }))
                self.allCategories = self.categories.map { $0.name }
            }
        } catch {
            print("Error fetching places: \(error)")
        }
    }

    func fetchEventsForSelectedPlaceOrCategory(_ selected: String) async {
        if let category = categories.first(where: { $0.name == selected }) {
            await fetchEventsForCategoryID(category.id)
        } else {
            await fetchEventsForPlace(selected)
        }
    }

    private func fetchEventsForCategoryID(_ categoryID: Int) async {
        let urlString = "https://api.yayx.dk/event/eventFilterMain?categoryID=\(categoryID)"
        do {
            let fetchedEvents = try await performAPICall(from: urlString)
            DispatchQueue.main.async {
                self.events = fetchedEvents
            }
        } catch {
            print("Error fetching events for category \(categoryID): \(error)")
            DispatchQueue.main.async {
                self.events = []
            }
        }
    }

    private func fetchEventsForPlace(_ place: String) async {
        guard let encodedPlace = place.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            print("Error encoding place name.")
            return
        }

        let urlString = "https://api.yayx.dk/event/eventFilterMain?place=\(encodedPlace)"
        do {
            let fetchedEvents = try await performAPICall(from: urlString)
            DispatchQueue.main.async {
                self.events = fetchedEvents
            }
        } catch {
            print("Error fetching events for place \(place): \(error)")
            DispatchQueue.main.async {
                self.events = []
            }
        }
    }

    func fetchEvents5(byPlaceOrCategory searchTerm: String) async {
        DispatchQueue.main.async {
            self.searchResults = []

            let filteredPlaces = self.allPlaces.filter { $0.localizedCaseInsensitiveContains(searchTerm) }
            self.searchResults.append(contentsOf: filteredPlaces)

            let filteredCategories = self.categories.filter { category in
                category.name.localizedCaseInsensitiveContains(searchTerm)
            }
            self.searchResults.append(contentsOf: filteredCategories.map { $0.name })

            self.searchResults = Array(Set(self.searchResults))
        }
    }

    private func performAPICall(from urlString: String) async throws -> [Event] {
        guard let url = URL(string: urlString) else {
            throw URLError(.badURL)
        }

        let (data, _) = try await URLSession.shared.data(from: url)
        let apiResponse = try JSONDecoder().decode(APIResponse.self, from: data)
        return apiResponse.data.events
    }
}

