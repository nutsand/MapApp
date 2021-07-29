//
//  MapView.swift
//  MapApp
//
//  Created by 内藤光博 on 2021/07/29.
//

import Foundation
import SwiftUI
import MapKit

struct MapView: View {
    var locationManager: CLLocationManager
    @ObservedObject var locationDelegate: LocationDelegate
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                Map(locationDelegate: locationDelegate)
                    .onAppear {
                        self.locationManager.delegate = locationDelegate
                        self.locationManager.requestAlwaysAuthorization()
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { _ in
                                self.locationDelegate.isCenterLocked = false
                            }
                    )
                
                Button(action: {
                    self.locationDelegate.tapCenterButton()
                }, label: {
                    Image(systemName: "location.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding()
                })
            }
        }
    }
}


struct Map: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    @ObservedObject var locationDelegate: LocationDelegate
    var locationManager = CLLocationManager()
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate = context.coordinator
        map.setRegion(MKCoordinateRegion(
                        center:CLLocationCoordinate2D(latitude: locationDelegate.latitude ?? 0,
                                                    longitude: locationDelegate.longitude ?? 0),
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ),animated: false)
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeOverlays(uiView.overlays)
        uiView.addOverlay(MKPolyline(coordinates: locationDelegate.points, count: locationDelegate.points.count))
        
        guard let latitude = locationDelegate.latitude,
              let longitude = locationDelegate.longitude else {
            return
        }
        
        if (locationDelegate.isCenterLocked) {
            let centar = CLLocationCoordinate2D(latitude: latitude,
                                            longitude: longitude)
            uiView.setCenter(centar, animated: true)
        }
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

class LocationDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    @Published var points: [CLLocationCoordinate2D] = []
    var isCenterLocked = false
    var isTracking = false
    var latitude: CLLocationDegrees?
    var longitude: CLLocationDegrees?
    var locationManager: CLLocationManager
    
    init(manager: CLLocationManager) {
        locationManager = manager
        super.init()
    }
    
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
        self.latitude = latitude
        self.longitude = longitude
        self.points += [CLLocationCoordinate2D(latitude: latitude, longitude: longitude)]
    }
    
    func tapTrackButton() {
        if (self.isTracking) {
            self.isTracking = false
            self.points = []
            self.latitude = nil
            self.latitude = nil
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

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let manager = CLLocationManager()
        MapView(locationManager: manager,
                locationDelegate: LocationDelegate(manager: manager))
    }
}
