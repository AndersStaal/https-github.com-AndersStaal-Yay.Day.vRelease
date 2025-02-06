//
//  ViewController.swift
//  Yay Day
//
//  Created by Anders Staal on 03/10/2024.
//

import Foundation
import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager: CLLocationManager!  // Remove 'private'
    var lastLocation: CLLocation?
    var onLocationUpdate: ((CLLocationCoordinate2D) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.distanceFilter = 10  // Update only if moved 10m

        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("❌ Location access denied or restricted.")
        case .notDetermined:
            print("⚠️ Location permission not determined yet.")
            locationManager.requestWhenInUseAuthorization()
        @unknown default:
            print("❓ Unknown authorization status.")
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let newLocation = locations.last else { return }

        // Ignore updates if the user has moved less than 10 meters
        if let lastLocation = lastLocation, newLocation.distance(from: lastLocation) < 10 {
            return
        }

        self.lastLocation = newLocation

        print("📍 New location: \(newLocation.coordinate.latitude), \(newLocation.coordinate.longitude)")
        
        // Send updated location to SwiftUI
        onLocationUpdate?(newLocation.coordinate)
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("❌ Failed to get location: \(error.localizedDescription)")
    }
}
