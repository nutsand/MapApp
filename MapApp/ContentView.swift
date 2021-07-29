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
    @StateObject var locationDelegate: LocationDelegate
    

    var body: some View {
        VStack {
            MapView(locationManager: locationManager,
                    locationDelegate: locationDelegate)
            
            Button(action: {
                locationDelegate.tapTrackButton()
            }, label: {
                Text("Track location")
            })
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = CLLocationManager()
        ContentView(locationManager: manager,
                    locationDelegate: LocationDelegate(manager: manager))
    }
}
