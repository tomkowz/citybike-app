//
//  Network.swift
//  CityBike
//
//  Created by Tomasz Szulc on 14/06/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation

@objc(Network)
public class Network: NSManagedObject {

    @NSManaged public var company: String
    @NSManaged public var id: String
    @NSManaged public var name: String
    @NSManaged public var location: Location
    @NSManaged public var stations: NSSet
    
    public func addStation(station: Station) {
        var mutableStations = NSMutableSet(set: self.stations as Set<NSObject>, copyItems: false)
        mutableStations.addObject(station)
        self.stations = NSSet(set: mutableStations as Set<NSObject>, copyItems: false)
    }
}
