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
        ZStack(alignment: .center) {
            ZStack(alignment: .bottom) {
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
                        if (vm.isCenterLocked) {
                            Image(systemName: "location.slash.fill")
                                .resizable()
                                .frame(width: 30, height: 30)
                                .frame(width: 50, height: 50)
                                .padding()
                        } else {
                            Image(systemName: "location.circle")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding()
                        }
                    })
                }
                
                Button(action: {
                    withAnimation {
                        self.vm.tapTrackButton()
                    }
                }, label: {
                    if (vm.isTracking) {
                        Text("トラッキング終了")
                    } else {
                        Text("トラッキング開始")
                    }
                })
                    .foregroundColor(.blue)
                    .padding()
                    .background(Color.white)
                    .cornerRadius(100)
                    .padding(.bottom)
                
            }
            
            if (vm.isRootNameEdit) {
                RootNameEditView(vm: vm)
            }
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
        if (!vm.coordinates.isEmpty) {
            map.setVisibleMapRect(self.vm.root.boundingMapRect,
                                  edgePadding: UIEdgeInsets(top: 100, left: 100, bottom: 100, right: 100),
                                  animated: true)
        }
        return map
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        // 経路線
        uiView.removeOverlays(uiView.overlays)
        if (vm.isTracking) {
            uiView.addOverlay(self.vm.root)
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

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        let locationManager = CLLocationManager()
        MapView(locationManager: locationManager, vm: MapViewModel(manager: locationManager, isPreview: true))
    }
}
