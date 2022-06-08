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
    
    init(manager: CLLocationManager){
        self.locationManager = manager
        //TabViewの背景色の設定
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    
    var body: some View {
        TabView(selection: $selection) {
            MapView(locationManager: locationManager,
                    vm: MapViewModel(manager: locationManager, isPreview: false))
                .tabItem {
                    VStack {
                        Image(systemName: "map")
                        Text("現在地")
                } }
                .tag(0)
            RootView(vm: RootViewModel(isPreview: false))
                .tabItem {
                    VStack {
                        Image(systemName: "list.bullet")
                        Text("保存経路")
                } }
                .tag(1)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = CLLocationManager()
        ContentView(manager: manager)
    }
}
