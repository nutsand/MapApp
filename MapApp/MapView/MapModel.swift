//
//  MapViewModel.swift
//  MapApp
//
//  Created by 内藤光博 on 2021/07/29.
//

import Foundation
import CoreLocation
import SwiftUI

class MapModel: ObservableObject {
    @Published var coordinates: [CLLocationCoordinate2D]
    @Published var isCenterLocked = false
    @Published var isTracking = false
    
    init(points: [CLLocationCoordinate2D] = [], isTracking: Bool = false, isCenterLocked: Bool = false) {
        self.coordinates = points
        self.isTracking = isTracking
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
        if (self.isTracking) {
            // トラッキング終了時
            self.isTracking = false
            self.locationManager.stopUpdatingLocation()
            self.isRootNameEdit = true
        } else {
            // トラッキング開始時
            self.isTracking = true
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
        self.isRootNameEdit = false
    }
    
    private func saveRootData() {
        var newPoints: NSSet = []
        for i in 0 ..< coordinates.count {
            let point = Point(context: cdmanager.context)
            point.latitude = coordinates[i].latitude
            point.longitude = coordinates[i].longitude
            point.order = Int64(i)
            newPoints = newPoints.adding(point) as NSSet
        }
        print("newPoints:\(newPoints)")
        
        let newRoot = Root(context: cdmanager.context)
        newRoot.rootnm = self.rootName
        newRoot.date = Date()
        newRoot.addToPoints(newPoints)
        
        cdmanager.save()
    }
}

class LocationDelegate: NSObject, ObservableObject, CLLocationManagerDelegate {
    var vm: MapModel?
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        if manager.authorizationStatus == .authorizedAlways {
            print("location is authorized")
            manager.allowsBackgroundLocationUpdates = true
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
        self.vm!.coordinates += [CLLocationCoordinate2D(latitude: latitude, longitude: longitude)]
    }
}
