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
    @StateObject var locationDelegate = LocationDelegate()
    
    var body: some View {
        VStack {
            MapView(locationDelegate: locationDelegate)
            Button(action: {
                addLocation()
            }, label: {
                Text("Add location")
            })
        }.onAppear {
            self.locationManager.delegate = locationDelegate
            self.locationDelegate.locationManagerDidChangeAuthorization(locationManager)
        }
    }
    
    func addLocation() {
        self.locationDelegate.points += [CLLocationCoordinate2D(
                latitude: locationDelegate.latitude,
                longitude: locationDelegate.longitude
            )
        ]
    }
}

class LocationDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0
    @Published var points: [CLLocationCoordinate2D] = []
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedWhenInUse {
            print("location is authorized")
            manager.distanceFilter = 10
            manager.startUpdatingLocation()
        } else {
            print("location is not authorized")
            manager.requestWhenInUseAuthorization()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.first
        guard let latitude = location?.coordinate.latitude,
              let longitude = location?.coordinate.longitude else {
            return
        }

        print("latitude: \(latitude)\nlongitude: \(longitude)")
        self.latitude = latitude
        self.longitude = longitude
        self.points += [CLLocationCoordinate2D(latitude: latitude, longitude: longitude)]
    }
}

struct MapView: UIViewRepresentable {
    typealias UIViewType = MKMapView
    @ObservedObject var locationDelegate: LocationDelegate
    var locationManager = CLLocationManager()
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate = context.coordinator
        map.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: locationDelegate.latitude,
                                                                        longitude: locationDelegate.longitude),
                                         span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)),
                      animated: false)
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeOverlays(uiView.overlays)
        uiView.addOverlay(MKPolyline(coordinates: locationDelegate.points, count: locationDelegate.points.count))
        
        let centar = CLLocationCoordinate2D(latitude: locationDelegate.latitude,
                                            longitude: locationDelegate.longitude)
        uiView.setCenter(centar, animated: true)
    }
    
    class MapViewCoordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let myPolyLineRendere: MKPolylineRenderer = MKPolylineRenderer(overlay: overlay)
            myPolyLineRendere.lineWidth = 5
            myPolyLineRendere.strokeColor = UIColor.red

            return myPolyLineRendere
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}