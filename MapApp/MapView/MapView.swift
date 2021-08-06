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
                Map(vm: vm)
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
    
    @ObservedObject var vm: MapModel
    
    func makeCoordinator() -> MapViewCoordinator {
        return MapViewCoordinator()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate = context.coordinator
        map.showsUserLocation = true
//        map.userTrackingMode = .follow
//        map.setRegion(MKCoordinateRegion(
//            center:map.userLocation.coordinate,
//            span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
//        ),animated: false)
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // 経路線
        uiView.removeOverlays(uiView.overlays)
        if (vm.isTracking) {
        uiView.addOverlay(MKPolyline(coordinates: vm.points, count: vm.points.count))
        }
        
        // センタリング
        if (vm.isCenterLocked) {
            uiView.userTrackingMode = .follow
        } else {
            uiView.userTrackingMode = .none
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
