//
//  ContentView.swift
//  MapApp
//
//  Created by 内藤光博 on 2021/07/27.
//

import SwiftUI
import MapKit
import CoreLocation

struct ContentView: View {
    var locationManager: CLLocationManager

    var body: some View {
        MapView(locationManager: locationManager,
                vm: MapViewModel(manager: locationManager))
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = CLLocationManager()
        ContentView(locationManager: manager)
    }
}
