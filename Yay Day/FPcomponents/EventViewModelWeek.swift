//
//  EventViewModelWeek.swift
//  Yay Day
//
//  Created by Anders Staal on 15/10/2024.
//

import Foundation
import Combine
import SwiftUI

class EventViewModelWeek: ObservableObject {
    @Published var events: [Event] = []
    
    init() {
            Task {
                await fetchFilteredEvents2()
            }
        }
    
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter
    }()
    
    private let eventRequest2 = EventRequest2()

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

    func fetchFilteredEvents2() async {
        await eventRequest2.fetchFilteredEvents2 { result in
            DispatchQueue.main.async {
                switch result {
                case .success(let fetchedEvents):
                    self.events = fetchedEvents
                    print("Fetched filtered events: \(fetchedEvents.count) events")
                case .failure(let error):
                    print("Error fetching filtered events: \(error)")
                    self.events = []
                }
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

func formatDate2(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter.string(from: date)
}

struct EventRequest2 {
    var baseURL: String = "https://api.yayx.dk/api/eventFilter"
    
    func fetchFilteredEvents2(completion: @escaping (Result<[Event], Error>) -> Void) {
        let today = Date()
        let endDate = Calendar.current.date(byAdding: .day, value: 500, to: today)
        
        let startDateString = formatDate(today)
        let endDateString = formatDate(endDate!)
        
        let urlString = "\(baseURL)?startDate=\(startDateString)&endDate=\(endDateString)"
        
        guard let url = URL(string: urlString) else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            let decoder = JSONDecoder()
            do {
                let apiResponse = try decoder.decode(APIResponse.self, from: data)
                completion(.success(apiResponse.data.events))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
}
