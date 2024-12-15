//
//  EventViewModelCat.swift
//  Yay Day
//
//  Created by Anders Staal on 14/10/2024.
//

import Foundation

import SwiftUI
import Combine

class EventViewModelByCategory: ObservableObject {
    @Published var events: [Event] = []
    
    
    init() {
            Task {
                await fetchEventsForCategories()
            }
        }
    
    let categoryIDs: [Int] = [1, 2, 4, 7, 10]
    
    func fetchEventsForCategories() async {
        let categoryIDString = categoryIDs.map { String($0) }.joined(separator: ",")
        let urlString = "https://api.yayx.dk/api/eventFilter?categoryID=\(categoryIDString)"
        
        do {
            let fetchedEvents = try await performAPICall(from: urlString)
            DispatchQueue.main.async {
                self.events = fetchedEvents
            }
        } catch {
            print("Error fetching events for categories: \(error)")
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