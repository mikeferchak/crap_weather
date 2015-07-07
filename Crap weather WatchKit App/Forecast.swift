//
//  Forecast.swift
//  Crap weather
//
//  Created by Michael Ferchak on 6/24/15.
//  Copyright © 2015 Michael Ferchak. All rights reserved.
//

import Foundation
import CoreLocation


class Forecast : NSObject, NSURLConnectionDataDelegate {
    let base_url = "https://api.forecast.io/forecast/"
    let api_key = "73e9a7486d789bacc8fcc69f7944d997"
    var full = NSDictionary()
    var current = NSDictionary()
    var hourly = NSDictionary()
    var daily = NSDictionary()
    
    func initialize() {
        let forecast = self.get()
        
        full = forecast
        
        if let data_currently = forecast["currently"],
           let data_hourly = forecast["hourly"],
           let data_daily = forecast["daily"]{
            current = data_currently as! NSDictionary
            hourly = data_hourly as! NSDictionary
            daily = data_daily as! NSDictionary
        }
    }
    
    func url() -> String {
        let latitude = "40.4521543"
        let longitude = "-79.9336577"
        
        return "\(base_url)\(api_key)/\(latitude),\(longitude)"
    }
    
    func get() -> NSDictionary {
        return Request().get(self.url())
    }
    
    func is_pleasant() -> Bool {
        return (is_raining() || is_too_cold() || is_too_hot()) != true
    }
    
    func is_raining() -> Bool {
        return (self.current.valueForKey("precipIntensity") as? Double) > 0
    }
    
    func is_too_cold() -> Bool {
        return (self.current.valueForKey("temperature") as? Double) < 55
    }
    
    func is_too_hot() -> Bool {
        return (self.current.valueForKey("temperature") as? Double) > 85
    }
}