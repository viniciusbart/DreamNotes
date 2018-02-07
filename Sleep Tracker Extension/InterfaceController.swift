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
    
    let motionManager = MotionManager()
    let trackerManager = TrackerManager()
    var active = false
    var movementsCount = 0
    
    @IBOutlet var lblTitle: WKInterfaceLabel!
    @IBOutlet var lblCount: WKInterfaceLabel!
    @IBOutlet var lblStatus: WKInterfaceLabel!
    
    override init() {
        super.init()
        trackerManager.delegate = self
        motionManager.delegate = trackerManager
        
        /*
         This is currently needed to allow the Motion Activity Access dialog
         to appear in front of the app, instead of behind it.
         */
        DispatchQueue.main.async {
            self.motionManager.startMonitoring()
        }
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
            lblCount.setText("Moves: \(movementsCount)")
        }
    }
    
    func updateStatus(_ str: String) {
        DispatchQueue.main.async {
            if str == "low" {
                self.lblStatus.setText("Now you're standing")
            }else if str == "med" {
                self.lblStatus.setText("Now you're walking")
            }
        }
    }
    
    func didEncounterAuthorizationError(_ manager: TrackerManager) {
        //        let title = NSLocalizedString("Motion Activity Not Authorized", comment: "")
        //
        //        let message = NSLocalizedString("To enable Motion features, please allow access to Motion & Fitness in Settings under Privacy.", comment: "")
        //
        //        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        //
        //        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        //        alert.addAction(cancelAction)
        //
        //        let openSettingsAction = UIAlertAction(title: "Open Settings", style: .default) { _ in
        //            // Open the Settings app.
        //            let url = URL(string: UIApplicationOpenSettingsURLString)!
        //
        //            UIApplication.shared.openURL(url)
        //        }
        //
        //        alert.addAction(openSettingsAction)
        //
        //        DispatchQueue.main.async {
        //            self.present(alert, animated: true, completion:nil)
        //        }
    }
    
}

