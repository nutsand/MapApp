//
//  Root+CoreDataProperties.swift
//  MapApp
//
//  Created by 内藤光博 on 2021/07/31.
//
//

import Foundation
import CoreData


extension Root {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Root> {
        return NSFetchRequest<Root>(entityName: "Root")
    }

    @NSManaged public var rootnm: String?
    @NSManaged public var points: NSSet?

}

// MARK: Generated accessors for points
extension Root {

    @objc(addPointsObject:)
    @NSManaged public func addToPoints(_ value: Point)

    @objc(removePointsObject:)
    @NSManaged public func removeFromPoints(_ value: Point)

    @objc(addPoints:)
    @NSManaged public func addToPoints(_ values: NSSet)

    @objc(removePoints:)
    @NSManaged public func removeFromPoints(_ values: NSSet)

}

extension Root : Identifiable {

}
