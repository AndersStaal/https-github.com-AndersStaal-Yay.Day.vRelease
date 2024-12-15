//
//  ViewController.swift
//  Yay Day
//
//  Created by Anders Staal on 03/10/2024.
//

import Foundation
import UIKit
import CoreLocation

class ViewController: UIViewController {
    var locationManager: CLLocationManager?
    var onLocationUpdate: ((CLLocationCoordinate2D?) -> Void)?  

    override func viewDidLoad() {
        super.viewDidLoad()

            locationManager = CLLocationManager()
            locationManager?.delegate = self

            let status = CLLocationManager.authorizationStatus()
            
            if status == .notDetermined {
                locationManager?.requestWhenInUseAuthorization()
            } else {
                locationManagerDidChangeAuthorization(locationManager!)
            }
        
    }

    private func startLocationUpdates() {
        locationManager?.startUpdatingLocation()
    }
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            print("User has not yet determined authorization status.")
        case .restricted:
            print("Location access is restricted.")
        case .denied:
            print("User denied location access.")
        case .authorizedWhenInUse:
            print("User authorized location access.")
            startLocationUpdates()
        case .authorizedAlways:
            print("User authorized location access always.")
            startLocationUpdates()
        @unknown default:
            print("Unknown authorization status.")
        } 
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Location: \(location.coordinate.latitude), \(location.coordinate.longitude)")
            onLocationUpdate?(location.coordinate)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get user location: \(error.localizedDescription)")
        onLocationUpdate?(nil)  
    }
}
