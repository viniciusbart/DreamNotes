//
//  SetNotificationViewController.swift
//  DreamNotes
//
//  Created by Vinícius Bazanelli on 12/10/14.
//  Copyright (c) 2014 Baza Inc. All rights reserved.
//

import UIKit

class SetNotificationViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var mySwitch: UISwitch!
    var daily = false
    var s = ""
    var iMinSessions = 2
    var iTryAgainSessions = 3
    
    let delegate = UIApplication.shared.delegate as? AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mySwitch.addTarget(self, action: #selector(SetNotificationViewController.stateChanged(_:)), for: UIControlEvents.valueChanged)
        
    }
    
    @IBAction func scheduleButton(_ sender: UIButton) {
        
        //Set Notification
        let dateTime = datePicker.date
        delegate?.scheduleNotification(at: dateTime, daily: daily)

        if daily {
            var dateFormatter: DateFormatter {
                let formatter = DateFormatter()
                formatter.timeStyle = .short
                return formatter
            }
            s = dateFormatter.string(from: dateTime)
        } else {
            var dateFormatter: DateFormatter {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                return formatter
            }
            s = dateFormatter.string(from: dateTime)
        }
        
        //Show a Message iOS 8
        if daily {
            let alert = UIAlertController(title: NSLocalizedString("Ntf_title", comment: "Notification Reminder"), message: NSLocalizedString("Ntf_msg", comment: "Notification reminder set for ")+s+NSLocalizedString("Ntf_msg_daily", comment: " daily."), preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: NSLocalizedString("Ntf_title", comment: "Notification Reminder"), message: NSLocalizedString("Ntf_msg", comment: "Notification reminder set for ")+s, preferredStyle: UIAlertControllerStyle.alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func stateChanged(_ switchState: UISwitch) {
        if switchState.isOn {
            daily = true
            datePicker.datePickerMode = UIDatePickerMode.time
        } else {
            daily = false
            datePicker.datePickerMode = UIDatePickerMode.dateAndTime
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
