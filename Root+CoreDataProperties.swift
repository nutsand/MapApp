//
//  Root+CoreDataProperties.swift
//  MapApp
//
//  Created by 内藤光博 on 2021/08/11.
//
//

import Foundation
import CoreData


extension Root {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Root> {
        return NSFetchRequest<Root>(entityName: "Root")
    }

    @NSManaged public var date: Date
    @NSManaged public var rootnm: String
    @NSManaged public var points: NSOrderedSet?

}

// MARK: Generated accessors for points
extension Root {

    @objc(insertObject:inPointsAtIndex:)
    @NSManaged public func insertIntoPoints(_ value: Point, at idx: Int)

    @objc(removeObjectFromPointsAtIndex:)
    @NSManaged public func removeFromPoints(at idx: Int)

    @objc(insertPoints:atIndexes:)
    @NSManaged public func insertIntoPoints(_ values: [Point], at indexes: NSIndexSet)

    @objc(removePointsAtIndexes:)
    @NSManaged public func removeFromPoints(at indexes: NSIndexSet)

    @objc(replaceObjectInPointsAtIndex:withObject:)
    @NSManaged public func replacePoints(at idx: Int, with value: Point)

    @objc(replacePointsAtIndexes:withPoints:)
    @NSManaged public func replacePoints(at indexes: NSIndexSet, with values: [Point])

    @objc(addPointsObject:)
    @NSManaged public func addToPoints(_ value: Point)

    @objc(removePointsObject:)
    @NSManaged public func removeFromPoints(_ value: Point)

    @objc(addPoints:)
    @NSManaged public func addToPoints(_ values: NSOrderedSet)

    @objc(removePoints:)
    @NSManaged public func removeFromPoints(_ values: NSOrderedSet)

}

extension Root : Identifiable {

}
