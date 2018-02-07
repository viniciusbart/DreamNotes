/*
Copyright (C) 2016 Apple Inc. All Rights Reserved.
See LICENSE.txt for this sample’s licensing information

Abstract:
This class represents a significant activity the user performed.
*/

import Foundation
import CoreMotion

/**
    This struct is responsible for storing the activity data and providing relevant
    pedometer properties such as pace and distance.
*/
struct Activity: CustomDebugStringConvertible {
    // MARK: Properties

    static let milesPerMeter = 0.000621371192

    var activity: CMMotionActivity
    var startDate: Date
    var endDate: Date

    var timeInterval = 0.0

    var numberOfSteps: Int?
    var distance: Int?
    var floorsAscended: Int?
    var floorsDescended: Int?

    // MARK: Initializers

    init(activity: CMMotionActivity, startDate: Date, endDate: Date, pedometerData: CMPedometerData? = nil) {
        self.activity = activity

        self.startDate = startDate

        self.endDate = endDate

        self.timeInterval = endDate.timeIntervalSince(startDate)

        guard let pedometerData = pedometerData , activity.walking || activity.running else {
            return
        }

        numberOfSteps = pedometerData.numberOfSteps.intValue

        if let distance = pedometerData.distance?.intValue , distance > 0 {
            self.distance = distance
        }

        if let floorsAscended = pedometerData.floorsAscended?.intValue {
            self.floorsAscended = floorsAscended
        }

        if let floorsDescended = pedometerData.floorsDescended?.intValue {
            self.floorsDescended = floorsDescended
        }
    }

    // MARK: Computed Properties

    var activityType: String {
        if activity.walking {
            return "Walking"
        }
        else if activity.running {
            return "Running"
        }
        else if activity.automotive {
            return "Automotive"
        }
        else if activity.cycling {
            return "Cycling"
        }
        else if activity.stationary {
            return "Stationary"
        }
        else {
            return "Unknown"
        }
    }

    var startDateDescription: String {
        return createLocalTimeDateStringFromDate(startDate)
    }

    var endDateDescription: String {
        return createLocalTimeDateStringFromDate(endDate)
    }

    var activityDuration: String {
        return createTimeStringFromSeconds(timeInterval)
    }

    var distanceInMiles: String {
        guard let distance = distance else { return "N/A" }

        return String(format: "%.7f", Double(distance) * Activity.milesPerMeter)
    }

    var calculatedPace: String {
        guard let distance = distance else { return "N/A" }

        let miles = Double(distance) * Activity.milesPerMeter
        let paceInSecondsPerMile = timeInterval / miles

        return createTimeStringFromSeconds(paceInSecondsPerMile)
    }

    // MARK: Helper Functions

    fileprivate func createTimeStringFromSeconds(_ seconds: TimeInterval) -> String {
        let calendar = NSCalendar.current

        let startDate = Date()
        let endDate = Date(timeInterval: seconds, since: startDate)

        let unitFlags: NSCalendar.Unit = [.hour, .minute, .second]

        let conversionInfo = (calendar as NSCalendar).components(unitFlags, from: startDate, to: endDate, options: [])

        return String(format: "%dh %dm %ds", conversionInfo.hour!, conversionInfo.minute!, conversionInfo.second!)
    }

    fileprivate func createLocalTimeDateStringFromDate(_ date: Date) -> String {
        return DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .medium)
    }

    // MARK: CustomDebugStringConvertible

    var debugDescription: String {
        return "ActivityType: \(activityType), StartDate: \(startDate), EndDate: \(endDate), TimeInterval: \(timeInterval), Steps: \(numberOfSteps), Distance: \(distance), FloorsAscended: \(floorsAscended), FloorsDescended: \(floorsDescended) "
    }
}
