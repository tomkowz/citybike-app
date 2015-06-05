//
//  CBService.swift
//  CityBike
//
//  Created by Tomasz Szulc on 04/06/15.
//  Copyright (c) 2015 Tomasz Szulc. All rights reserved.
//

import Foundation

class CBService {
    
    static private let CBServiceBaseURL = "http://api.citybik.es/v2/networks/"
    
    /// Get shared instance
    class var sharedInstance: CBService {
        struct Static {
            static var onceToken: dispatch_once_t = 0
            static var instance: CBService? = nil
        }
        
        dispatch_once(&Static.onceToken, { () -> Void in
            Static.instance = CBService()
        })
        
        return Static.instance!
    }
    
    func fetchNetworks(completion: (networks: [CBNetwork]) -> Void) {
        let baseURL = NSURL(string: CBService.CBServiceBaseURL)
        let request = NSURLRequest(URL: baseURL!)
                
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var parseError: NSError? = nil
            let jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &parseError)
            
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                var networks = [CBNetwork]()
                for jsonNetwork in jsonResult["networks"] as! [CBJSONParser.JSON] {
                    networks.append(CBJSONParser.parseNetwork(jsonNetwork))
                }
                
                completion(networks: networks)
            
            } else {
                println(parseError)
                completion(networks: [])
            }
        }
    }
    
    /// Get stations for passed network types
    func fetchStationsForNetworkTypes(types: [CBNetworkType], completion: (result: Dictionary<CBNetworkType, [CBStation]>) -> Void) {
        
        var result = Dictionary<CBNetworkType, [CBStation]>()
    
        var semaphore = dispatch_semaphore_create(0)
        
        var queue = NSOperationQueue()
        queue.maxConcurrentOperationCount = 1
        queue.suspended = true
        
        for idx in 0..<types.count {
            let networkType = types[idx]
            
            var operation = NSBlockOperation()
            var x = idx
            operation.addExecutionBlock({ () -> Void in
                self.fetchNetworkForType(networkType, completion: { (network: CBNetwork?) -> Void in
                    if let network = network {
                        result[network.networkType] = network.stations
                    }
                    
                    if x == types.count - 1 {
                        dispatch_semaphore_signal(semaphore)
                    }
                })
            })
            
            queue.addOperation(operation)
        }
        
        queue.suspended = false
        
        dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER)
                
        completion(result: result)
    }
    
    /// Get latest info about specified network
    func fetchNetworkForType(type: CBNetworkType, completion: (network: CBNetwork?) -> Void) {
        let baseURL = NSURL(string: CBService.CBServiceBaseURL)
        let url = NSURL(string: type.rawValue, relativeToURL: baseURL)!
        let request = NSURLRequest(URL: url)
        
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue()) { (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            var parseError: NSError? = nil
            let jsonResult: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions.MutableContainers, error: &parseError)
            
            if let jsonResult = jsonResult as? Dictionary<String, AnyObject> {
                let network = CBJSONParser.parseNetwork(jsonResult["network"] as! CBJSONParser.JSON)
                completion(network: network)
                
            } else {
                println(parseError)
                completion(network: nil)
            }
        }
    }
}