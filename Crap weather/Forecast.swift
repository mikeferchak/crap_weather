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
    let base_url = "https://api.forecast.io/forecast/",
        api_key = "73e9a7486d789bacc8fcc69f7944d997",
        nice_time_interval = NSTimeInterval(2*3600)
    
    var full = NSDictionary(),
        current = NSDictionary(),
        hourly:[NSDictionary] = [],
        daily = NSDictionary()
    
    func initialize() {
        let forecast = self.get()
        
        full = forecast
        
        if let data_currently = forecast["currently"],
           let data_hourly = forecast["hourly"],
           let data_daily = forecast["daily"]{
            current = data_currently as! NSDictionary
            hourly = data_hourly.valueForKey("data")! as! [NSDictionary]
            daily = data_daily as! NSDictionary
            add_pleasant_attr_to_hourly()
        }
    }
    
    func url() -> String {
        let latitude = "40.4521543",
            longitude = "-79.9336577"
        
        return "\(base_url)\(api_key)/\(latitude),\(longitude)"
    }
    
    func get() -> NSDictionary {
        return Request().get(self.url())
    }
    
    func cloud_cover() -> Double {
        let cover = (self.current.valueForKey("cloudCover") as? Double)
        if (cover != nil) {
            return 0.0
        } else {
            return 0.0
        }
    }
    
    func add_pleasant_attr_to_hourly() {
        for index in 0...(self.hourly.count - 1) {
            if Forecast().is_pleasant_at(self.hourly[index]) {
                self.hourly[index].setValue(true, forKey: "pleasant")
            } else {
                self.hourly[index].setValue(false, forKey: "pleasant")
            }
        }
    }
    
    func find_pleasant_blocks_in(forecast:NSArray) -> [NSDictionary]{
        var nice_times:[NSDictionary] = []
        for hour in forecast {
            let this_hour = hour as! NSDictionary
            if Forecast().is_pleasant_at(this_hour) {
                nice_times.append(this_hour)
            }
        }
        
        return nice_times
    }
    
    func is_pleasant_at(forecast:NSDictionary) -> Bool {
        return (is_raining(forecast) || is_too_cold(forecast) || is_too_hot(forecast)) != true
    }
    
    func is_raining(forecast:NSDictionary) -> Bool {
        return (forecast.valueForKey("precipIntensity") as? Double) > 0
    }
    
    func is_too_cold(forecast:NSDictionary) -> Bool {
        return (forecast.valueForKey("temperature") as? Double) < 55
    }
    
    func is_too_hot(forecast:NSDictionary) -> Bool {
        return (forecast.valueForKey("temperature") as? Double) > 85
    }
}