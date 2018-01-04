/*
 Copyright (C) 2016 Apple Inc. All Rights Reserved.
 See LICENSE.txt for this sample’s licensing information
 
 Abstract:
 This class manages the HealthKit interactions and provides a delegate 
         to indicate changes in data.
 */

import Foundation
import HealthKit

/**
 `TrackerManagerDelegate` exists to inform delegates of swing data changes.
 These updates can be used to populate the user interface.
 */
protocol TrackerManagerDelegate: class {
    func didUpdateMovementsCount(_ manager: TrackerManager, value: Int)
}

class TrackerManager: MotionManagerDelegate {
    // MARK: Properties
    let motionManager = MotionManager()
    let healthStore = HKHealthStore()

    weak var delegate: TrackerManagerDelegate?
    var session: HKWorkoutSession?

    // MARK: Initialization
    
    init() {
        motionManager.delegate = self
    }

    // MARK: TrackerManager
    
    func startWorkout() {
        // If we have already started the workout, then do nothing.
        if (session != nil) {
            return
        }

        // Configure the workout session.
        let workoutConfiguration = HKWorkoutConfiguration()
        workoutConfiguration.activityType = .mindAndBody
        workoutConfiguration.locationType = .indoor

        do {
            session = try HKWorkoutSession(configuration: workoutConfiguration)
        } catch {
            fatalError("Unable to create the workout session!")
        }

        // Start the workout session and device motion updates.
        healthStore.start(session!)
        motionManager.startUpdates()
    }

    func stopWorkout() {
        // If we have already stopped the workout, then do nothing.
        if (session == nil) {
            return
        }

        // Stop the device motion updates and workout session.
        motionManager.stopUpdates()
        healthStore.end(session!)

        // Clear the workout session.
        session = nil
    }

    // MARK: MotionManagerDelegate
    
    func didUpdateMovementsCount(_ manager: MotionManager, count: Int) {
        delegate?.didUpdateMovementsCount(self, value: count)
    }
}
