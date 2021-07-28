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
    @StateObject var locationDelegate: LocationDelegate
    @State var isCenterLocked = true
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                Map(locationDelegate: locationDelegate, isCenterLocked: isCenterLocked)
                    .onAppear {
                        self.locationManager.delegate = locationDelegate
                        self.locationDelegate.locationManagerDidChangeAuthorization(locationManager)
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { _ in
                                self.isCenterLocked = false
                            }
                    )
                
                Button(action: {
                    self.isCenterLocked = true
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
    var isCenterLocked: Bool
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
        
        if (isCenterLocked) {
        let centar = CLLocationCoordinate2D(latitude: locationDelegate.latitude,
                                            longitude: locationDelegate.longitude)
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

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(locationManager: CLLocationManager(), locationDelegate: LocationDelegate())
    }
}
