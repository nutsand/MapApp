//
//  Root+CoreDataClass.swift
//  MapApp
//
//  Created by 内藤光博 on 2021/07/31.
//
//

import Foundation
import CoreData
import CoreLocation

@objc(Root)
public class Root: NSManagedObject {

    var coordinates: [CLLocationCoordinate2D] {
            var result: [CLLocationCoordinate2D] = []
            for point in points ?? [] {
                let latitude = (point as! Point).latitude
                let longitude = (point as! Point).longitude
                let coordinate = CLLocationCoordinate2D(latitude: latitude,
                                                        longitude: longitude)
                result.append(coordinate)
            }
            return result
    }
}
