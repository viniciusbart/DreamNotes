//
//  InterfaceController.swift
//  Sleep Tracker Extension
//
//  Created by Vinícius Bazanelli on 03/01/18.
//  Copyright © 2018 Baza Inc. All rights reserved.
//

import WatchKit
import Foundation
import Dispatch


class InterfaceController: WKInterfaceController, TrackerManagerDelegate {
    
    // MARK: Properties
    
    let trackerManager = TrackerManager()
    var active = false
    var movementsCount = 0

    @IBOutlet var lblTitle: WKInterfaceLabel!
    @IBOutlet var lblCount: WKInterfaceLabel!
    
    override init() {
        super.init()
        trackerManager.delegate = self
    }
    

//    override func awake(withContext context: Any?) {
//        super.awake(withContext: context)
//
//        // Configure interface objects here.
//    }
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        active = true
        
        // On re-activation, update with the cached values.
        updateLabels()
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
        active = false
    }
    
    // MARK: Interface Bindings
    
    @IBAction func start() {
        lblTitle.setText("Activated.")
        trackerManager.startWorkout()
    }
    
    @IBAction func stop() {
        lblTitle.setText("Stoped.")
        trackerManager.stopWorkout()
    }
    
    // MARK: TrackerManagerDelegate
    
    func didUpdateMovementsCount(_ manager: TrackerManager, value: Int) {
        /// Serialize the property access and UI updates on the main queue.
        DispatchQueue.main.async {
            self.movementsCount = value
            self.updateLabels()
        }
    }
    
    // MARK: Convenience
    
    func updateLabels() {
        if active {
            lblCount.setText("\(movementsCount)")
        }
    }

}
