//
//  EventsNearYouComp.swift
//  Yay Day
//
//  Created by Anders Staal on 08/10/2024.
//

import Foundation
import SwiftUI
import Combine
import CoreLocation



class EventsNearYouComp: ObservableObject {
    @Published var filteredEvents: [Event] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private var cancellables = Set<AnyCancellable>()
    
    func fetchEventsNearYou(userLocation: CLLocationCoordinate2D) {
        isLoading = true
        errorMessage = nil
        print("Fetching events for user location: \(userLocation.latitude), \(userLocation.longitude)")
        
        let urlString = "https://api.yayx.dk/api/eventFilter?longitude=\(userLocation.longitude)&latitude=\(userLocation.latitude)"
        guard let url = URL(string: urlString) else {
            print("Invalid URL: \(urlString)")
            isLoading = false
            return
        }
        
        print("Valid URL: \(url)")
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: APIResponse.self, decoder: JSONDecoder())
            .replaceError(with: APIResponse(status: "error", length: 0, data: EventData(events: [])))
            .receive(on: DispatchQueue.main)
            .sink { [weak self] response in
                if response.status == "error" {
                    self?.errorMessage = "Failed to fetch events."
                    print("Error fetching events: \(self?.errorMessage ?? "Unknown error")")
                } else {
                    self?.filteredEvents = response.data.events.map { event in
                        var mutableEvent = event
                        mutableEvent.distanceFromUser = self?.calculateDistance(from: userLocation, to: event.address.coordinates)
                        return mutableEvent
                    }
                    print("Successfully fetched \(response.data.events.count) events.")
                }
                self?.isLoading = false
            }
            .store(in: &cancellables)
    }
    
    private func calculateDistance(from userLocation: CLLocationCoordinate2D, to eventLocation: [Double]) -> Double {
        let userCLLocation = CLLocation(latitude: userLocation.latitude, longitude: userLocation.longitude)
        let eventCLLocation = CLLocation(latitude: eventLocation[1], longitude: eventLocation[0])

        let distanceInMeters = userCLLocation.distance(from: eventCLLocation)
        return distanceInMeters / 1000000
    }
}
