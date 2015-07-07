//
//  InterfaceController.swift
//  Crap weather WatchKit Extension
//
//  Created by Michael Ferchak on 6/24/15.
//  Copyright © 2015 Michael Ferchak. All rights reserved.
//

import WatchKit
import Foundation


class InterfaceController: WKInterfaceController {

    override func awakeWithContext(context: AnyObject?) {
        super.awakeWithContext(context)
        print("sup")
        // Configure interface objects here.
    }

    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
                print("sup")
        super.willActivate()
    }

    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
                print("sup")
        super.didDeactivate()
    }

}
