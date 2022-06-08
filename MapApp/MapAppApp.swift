//
//  MapAppApp.swift
//  MapApp
//
//  Created by 内藤光博 on 2021/07/27.
//

import SwiftUI
import CoreLocation

@main
struct MapAppApp: App {
    let locationManager = CLLocationManager()
    
    init() {
        locationManager.distanceFilter = 10
        locationManager.allowsBackgroundLocationUpdates = true
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView(manager: locationManager)
        }
    }
}
