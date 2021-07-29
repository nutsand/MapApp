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
    @ObservedObject var vm: MapViewModel
    
    var body: some View {
        VStack {
            ZStack(alignment: .bottomTrailing) {
                Map(vm: vm, locationManager: locationManager)
                    .onAppear {
                        self.locationManager.requestAlwaysAuthorization()
                    }
                    .gesture(
                        DragGesture()
                            .onChanged { _ in
                                self.vm.isCenterLocked = false
                            }
                    )
                
                Button(action: {
                    self.vm.tapCenterButton()
                }, label: {
                    Image(systemName: "location.circle")
                        .resizable()
                        .frame(width: 50, height: 50)
                        .padding()
                })
            }
            
            Button(action: {
                self.vm.tapTrackButton()
            }, label: {
                Text("Track location")
            })
            
        }
    }
}


struct Map: UIViewRepresentable {
    typealias UIViewType = MKMapView
    
    @ObservedObject var vm: MapViewModel
    var locationManager: CLLocationManager
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate = context.coordinator
        map.setRegion(MKCoordinateRegion(
            center:CLLocationCoordinate2D(latitude: 0,longitude: 0),
            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        ),animated: false)
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeOverlays(uiView.overlays)
        uiView.addOverlay(MKPolyline(coordinates: vm.points, count: vm.points.count))
        
        guard let latitude = self.vm.points.last?.latitude,
              let longitude = self.vm.points.last?.longitude else {
            return
        }
        
        if (vm.isCenterLocked) {
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
