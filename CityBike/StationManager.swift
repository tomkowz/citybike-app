//
//  StationManager.swift
//  CityBike
//
//  Created by Tomasz Szulc on 21/06/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import Model

class StationManager {
    
    class func allStationsForSelectedNetworks(resetContext: Bool = false) -> [Station] {
        let networkIDs = UserSettings.sharedInstance().getNetworkIDs()
        let context = CoreDataStack.sharedInstance().mainContext
        
        if resetContext { context.reset() }
        
        var stations = [Station]()
        for networkID in networkIDs {
            stations += Station.fetchWithAttribute("network.id", value: networkID, context: context) as! [Station]
        }
        
        return stations
    }
}