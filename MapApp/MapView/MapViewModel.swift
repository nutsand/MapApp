//
//  MapViewModel.swift
//  MapApp
//
//  Created by 内藤光博 on 2021/07/29.
//

import Foundation
import CoreLocation
import SwiftUI

class MapViewModel: ObservableObject {
    @Published var points: [CLLocationCoordinate2D] = []
    var locationManager: CLLocationManager
    var locationDelegate = LocationDelegate()
    
    var isCenterLocked = false
    var isTracking = false
    
    init(manager: CLLocationManager) {
        manager.delegate = locationDelegate
        self.locationManager = manager
        self.locationDelegate.vm = self
    }
    
    func tapTrackButton() {
        if (self.isTracking) {
            self.isTracking = false
            self.points = []
            self.locationManager.stopUpdatingLocation()
        } else {
            self.isTracking = true
            self.isCenterLocked = true
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func tapCenterButton() {
        self.isCenterLocked.toggle()
    }
}

class LocationDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    var vm: MapViewModel?
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways {
            print("location is authorized")
            manager.allowsBackgroundLocationUpdates = true
            manager.distanceFilter = 10
        } else {
            print("location is not authorized")
            manager.requestAlwaysAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        guard let latitude = location?.coordinate.latitude,
              let longitude = location?.coordinate.longitude else {
            return
        }

        print("latitude: \(latitude)\nlongitude: \(longitude)")
        self.vm!.points += [CLLocationCoordinate2D(latitude: latitude, longitude: longitude)]
    }
}
