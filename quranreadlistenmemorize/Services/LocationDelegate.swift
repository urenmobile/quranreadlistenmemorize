//
//  LocationDelegate.swift
//  compass
//
//  Created by Federico Zanetello on 05/04/2017.
//  Copyright © 2017 Kimchi Media. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let shared = LocationManager()
    
    lazy var locationManager: CLLocationManager = {
        let locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.pausesLocationUpdatesAutomatically = true // Enable automatic pausing
        return locationManager
    }()
    
    var latestLocation: CLLocation?
    
    var locationCallback: ((CLLocation) -> ())?
    var headingCallback: ((CLLocationDirection) -> ())?
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let currentLocation = locations.last else { return }
        locationCallback?(currentLocation)
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        headingCallback?(newHeading.trueHeading)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        debugPrint("⚠️ Error while updating location " + error.localizedDescription)
        if let error = error as? CLError, error.code == .denied {
            // Location updates are not authorized.
            self.locationManager.stopUpdatingLocation()
            return
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        startUpdateLocation()
    }
    
    func requestAuthorization(_ viewController: UIViewController) {
        let status  = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways, .authorizedWhenInUse :
            return
        case .denied, .restricted:
            AlertController.showAccessDeniedAlert(viewController, serviceType: .location)
        case .notDetermined :
            AlertController.showPrePermissionAlert(viewController, serviceType: .location) { (_) in
                self.locationManager.requestWhenInUseAuthorization()
            }
        }
    }
    
    func startUpdateLocation() {
        let status  = CLLocationManager.authorizationStatus()
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.startUpdatingLocation()
                self.locationManager.startUpdatingHeading()
            }
        }
        
        
    }
    
    func stopUpdateLocation() {
        let status  = CLLocationManager.authorizationStatus()
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.stopUpdatingLocation()
                self.locationManager.stopUpdatingHeading()
            }
        }
    }
}
