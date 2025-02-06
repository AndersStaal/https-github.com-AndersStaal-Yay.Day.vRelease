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
        viewController.onLocationUpdate = { location in
            DispatchQueue.main.async {
                // Compare latitude & longitude explicitly
                if self.userLocation == nil || self.userLocation?.latitude != location.latitude || self.userLocation?.longitude != location.longitude {
                    self.userLocation = location
                }
            }
        }
        return viewController
    }

    func updateUIViewController(_ uiViewController: ViewController, context: Context) {
        if CLLocationManager.locationServicesEnabled() {
            uiViewController.locationManager.startUpdatingLocation()
        }
    }
}
