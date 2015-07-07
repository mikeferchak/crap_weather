//
//  Location.swift
//  Crap weather
//
//  Created by Michael Ferchak on 6/24/15.
//  Copyright © 2015 Michael Ferchak. All rights reserved.
//

import Foundation
import CoreLocation

class Location : NSObject, CLLocationManagerDelegate {
    var location_manager = CLLocationManager()
    var this_location = CLLocation()
    
    func triggerLocationServices() {
        location_manager.delegate = self
        location_manager.desiredAccuracy = kCLLocationAccuracyBest
        location_manager.requestWhenInUseAuthorization()
        location_manager.requestAlwaysAuthorization()
        location_manager.startUpdatingLocation()
        location_manager.startMonitoringSignificantLocationChanges()

        if (NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationWhenInUseUsageDescription") != nil) {
            location_manager.requestWhenInUseAuthorization()
        } else if (NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationAlwaysUsageDescription") != nil) {
            location_manager.requestAlwaysAuthorization()
        } else {
            fatalError("To use location in iOS8 you need to define either NSLocationWhenInUseUsageDescription or NSLocationAlwaysUsageDescription in the app bundle's Info.plist file")
        }

    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [AnyObject]) {
        let locationArray = locations as NSArray
        let locationObj = locationArray.lastObject
        let coord = locationObj?.coordinate
                    print("did update")

        print(coord?.latitude)
        print(coord?.longitude)
        this_location = locationObj as! CLLocation
    }    
    
    func get() -> CLLocation {
        return this_location
    }
}
