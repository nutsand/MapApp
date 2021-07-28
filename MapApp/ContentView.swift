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
    var locationManager = CLLocationManager()

    var body: some View {
        VStack {
            MapView(locationManager: locationManager,
                    locationDelegate: LocationDelegate())
            
            Button(action: {
                print("save location tapped")
            }, label: {
                Text("Save location")
            })
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
