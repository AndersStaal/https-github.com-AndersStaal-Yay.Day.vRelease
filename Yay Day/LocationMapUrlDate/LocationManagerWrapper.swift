//
//  LocationManagerWrapper.swift
//  Yay Day
//
//  Created by Anders Staal on 03/10/2024.
//

import Foundation

import SwiftUI
import CoreLocation


struct LocationManagerWrapper: UIViewControllerRepresentable {
    @Binding var userLocation: CLLocationCoordinate2D?

    func makeUIViewController(context: Context) -> ViewController {
        let viewController = ViewController()

        if let cachedLocation = LocationCache.shared.location {
            DispatchQueue.main.async {
                self.userLocation = cachedLocation
            }
        } else {
            viewController.onLocationUpdate = { location in
                DispatchQueue.main.async { 
                    self.userLocation = location
                    LocationCache.shared.location = location
                }
            }
        }
        return viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
    }
}

class LocationCache {
    static let shared = LocationCache()
    private init() {}
    var location: CLLocationCoordinate2D?
}
