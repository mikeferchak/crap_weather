//
//  Request.swift
//  Crap weather
//
//  Created by Michael Ferchak on 6/25/15.
//  Copyright © 2015 Michael Ferchak. All rights reserved.
//

import Foundation

class Request : NSObject, NSURLConnectionDataDelegate {
    func get(path:String) -> NSDictionary {
        let url: NSURL = NSURL(string: path)!
        let request1: NSURLRequest = NSURLRequest(URL: url)
        let response: AutoreleasingUnsafeMutablePointer<NSURLResponse?>=nil
        var result = NSDictionary()
        do {
            let dataVal: NSData =  try NSURLConnection.sendSynchronousRequest(request1, returningResponse: response)
            let jsonResult: NSDictionary = try (NSJSONSerialization.JSONObjectWithData(dataVal, options: NSJSONReadingOptions.MutableContainers) as? NSDictionary)!
            result = jsonResult
//            print("Synchronous\(jsonResult)")
        } catch {
            print(error)
        }
        
        return result
    }
}