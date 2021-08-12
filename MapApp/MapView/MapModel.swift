//
//  MapViewModel.swift
//  MapApp
//
//  Created by 内藤光博 on 2021/07/29.
//

import Foundation
import CoreLocation
import SwiftUI
import MapKit

class MapModel: ObservableObject {
    @Published var coordinates: [CLLocationCoordinate2D]
    @Published var isCenterLocked = false
    @Published var isShowRoot = false
    var root: MKPolyline {
        MKPolyline(coordinates: coordinates, count: coordinates.count)
    }
    
    init(points: [CLLocationCoordinate2D] = [], isTracking: Bool = false, isCenterLocked: Bool = false) {
        self.coordinates = points
        self.isShowRoot = isTracking
        self.isCenterLocked = isCenterLocked
    }
}

class MapViewModel: MapModel {
    @Published var isRootNameEdit = false
    @Published var rootName = ""
    private var locationManager: CLLocationManager
    private var locationDelegate = LocationDelegate()
    private var cdmanager: CoreDataManager
    
    init(manager: CLLocationManager, isPreview: Bool) {
        manager.delegate = locationDelegate
        self.locationManager = manager
        if (isPreview) {
            cdmanager = CoreDataManager.preview
        } else {
            cdmanager = CoreDataManager.shared
        }
        super.init()
        self.locationDelegate.vm = self
    }
    
    func tapTrackButton() {
        if (self.isShowRoot) {
            // トラッキング終了時
            self.isShowRoot = false
            self.locationManager.stopUpdatingLocation()
            self.isRootNameEdit = true
        } else {
            // トラッキング開始時
            self.isShowRoot = true
            self.isCenterLocked = true
            self.locationManager.startUpdatingLocation()
        }
    }
    
    func tapCenterButton() {
        self.isCenterLocked.toggle()
    }
    
    func tapRootNameOK() {
        saveRootData()
        self.coordinates = []
        self.rootName = ""
        self.isRootNameEdit = false
    }
    
    func saveRootData() {
        var newPoints: [Point] = []
        for i in 0 ..< coordinates.count {
            let point = Point(context: cdmanager.context)
            point.latitude = coordinates[i].latitude
            point.longitude = coordinates[i].longitude
            point.order = Int64(i)
            newPoints.append(point)
        }
        
        let newRoot = Root(context: cdmanager.context)
        newRoot.rootnm = self.rootName
        newRoot.date = Date()
        newRoot.addToPoints(NSOrderedSet(array: newPoints))
        
        cdmanager.save()
        for point in newPoints {
            cdmanager.context.refresh(point, mergeChanges: false)
        }
    }
}

class LocationDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    weak var vm: MapViewModel?
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        print("locationManagerDidChangeAuthorization...")
        if manager.authorizationStatus == .authorizedWhenInUse {
            print("location is authorized")
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
        self.vm!.coordinates += [CLLocationCoordinate2D(latitude: latitude, longitude: longitude)]
    }
}
