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
    @State var selection = 0
    
    var body: some View {
        TabView(selection: $selection) {
            MapView(locationManager: locationManager,
                    vm: MapViewModel(manager: locationManager, isPreview: false))
                .tabItem { VStack {
                    Image(systemName: "map")
                    Text("Map")
                } }
                .tag(1)
            RootView(vm: RootViewModel(isPreview: false))
                .tabItem { VStack {
                    Image(systemName: "list.bullet")
                    Text("Root")
                } }
                .tag(2)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = CLLocationManager()
        ContentView(locationManager: manager)
    }
}
