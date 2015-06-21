//
//  CBStationTableRowController.swift
//  CityBike
//
//  Created by Tomasz Szulc on 21/06/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation
import WatchKit
import CBModel

class CBStationTableRowController: NSObject {
    @IBOutlet weak var freeBikesCircleImage: WKInterfaceImage!
    @IBOutlet weak var freeBikesLabel: WKInterfaceLabel!
    
    @IBOutlet weak var freeSlotsCircleImage: WKInterfaceImage!
    @IBOutlet weak var freeSlotsLabel: WKInterfaceLabel!
    
    @IBOutlet weak var distanceLabel: WKInterfaceLabel!
    
    @IBOutlet weak var stationNameLabel: WKInterfaceLabel!
    
    func update(station: CDStation) {
        freeBikesLabel.setText(station.freeBikes.stringValue)
        freeBikesCircleImage.setTintColor(colorForValue(station.freeBikes.integerValue, min: 0, max: 5))
        
        freeSlotsLabel.setText(station.emptySlots.stringValue)
        freeSlotsCircleImage.setTintColor(colorForValue(station.emptySlots.integerValue, min: 0, max: 5))
        stationNameLabel.setText(station.name)
        
        distanceLabel.setText("-.-km")
    }
    
    private func colorForValue(value: Int, min: Int, max: Int) -> UIColor {
        if value > max { return UIColor.plentyColor() }
        else if value == 0 { return UIColor.noneColor() }
        else { return UIColor.fewColor() }
    }
}