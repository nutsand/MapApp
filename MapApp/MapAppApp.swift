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
    var body: some Scene {
        WindowGroup {
            let locationManager = CLLocationManager()
            ContentView(locationManager: locationManager)
        }
    }
}
