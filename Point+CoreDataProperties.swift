//
//  Point+CoreDataProperties.swift
//  MapApp
//
//  Created by 内藤光博 on 2021/07/31.
//
//

import Foundation
import CoreData


extension Point {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Point> {
        return NSFetchRequest<Point>(entityName: "Point")
    }

    @NSManaged public var order: Int64
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var root: Root?

}

extension Point : Identifiable {

}
