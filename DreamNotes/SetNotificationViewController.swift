//
//  SetNotificationViewController.swift
//  DreamNotes
//
//  Created by Vinícius Bazanelli on 12/10/14.
//  Copyright (c) 2014 Baza Inc. All rights reserved.
//

import UIKit
import iAd

class SetNotificationViewController: UIViewController, ADBannerViewDelegate {
    
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var mySwitch: UISwitch!
    var ios8 = false
    var daily = false
    var s = ""
    var iMinSessions = 2
    var iTryAgainSessions = 3
    var bannerView: ADBannerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if LITE
            self.canDisplayBannerAds = true
            self.bannerView?.delegate = self
            self.bannerView?.hidden = true
        #endif
        
        // -----iOS Version-----
        func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: NSString) -> Bool {
            return UIDevice.currentDevice().systemVersion.compare(version as String,
                options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedAscending
        }
        if SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO("8"){
            ios8 = true
        }else{
            ios8 = false
        }
        
        #if LITE
            if ios8{
                dreamNotesProAd()
            }
        #endif
        
        mySwitch.addTarget(self, action: Selector("stateChanged:"), forControlEvents: UIControlEvents.ValueChanged)
        
    }
    
    @IBAction func scheduleButton(sender: UIButton) {
        
        //Set Notification
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        let dateTime = datePicker.date
        var notification:UILocalNotification = UILocalNotification()
        if ios8 {
            notification.category = "CATEGORY"
        }
        notification.alertBody = NSLocalizedString("Notification", comment: "Did you dreamed today?")
        if daily {
            //println("Diariamente")
            notification.repeatInterval = NSCalendarUnit.Day
            var dateFormatter: NSDateFormatter {
                let formatter = NSDateFormatter()
                formatter.timeStyle = .ShortStyle
                return formatter
            }
            s = dateFormatter.stringFromDate(dateTime)
        } else {
            var dateFormatter: NSDateFormatter {
                let formatter = NSDateFormatter()
                formatter.dateStyle = .MediumStyle
                formatter.timeStyle = .ShortStyle
                return formatter
            }
            s = dateFormatter.stringFromDate(dateTime)
        }
        notification.fireDate = dateTime
        notification.soundName = UILocalNotificationDefaultSoundName
        UIApplication.sharedApplication().scheduleLocalNotification(notification)
        
        if ios8 {
            //Show a Message iOS 8
            if daily {
                let alert = UIAlertController(title: NSLocalizedString("Ntf_title", comment: "Notification Reminder"), message: NSLocalizedString("Ntf_msg", comment: "Notification reminder set for ")+s+NSLocalizedString("Ntf_msg_daily", comment: " daily."), preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            } else {
                let alert = UIAlertController(title: NSLocalizedString("Ntf_title", comment: "Notification Reminder"), message: NSLocalizedString("Ntf_msg", comment: "Notification reminder set for ")+s, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        } else {
            let alert = UIAlertView()
            alert.title = NSLocalizedString("Ntf_title", comment: "Notification Reminder")
            alert.message = NSLocalizedString("Ntf_msg", comment: "Notification reminder set for ")+s
            alert.addButtonWithTitle("OK")
            alert.show()
            //println("Notification reminder set for "+s)
        }
        
    }
    
    #if !LITE
    func stateChanged(switchState: UISwitch) {
        if switchState.on {
            daily = true
            datePicker.datePickerMode = UIDatePickerMode.Time
        } else {
            daily = false
            datePicker.datePickerMode = UIDatePickerMode.DateAndTime
            UIApplication.sharedApplication().cancelAllLocalNotifications()
        }
    }
    #else
    func stateChanged(switchState: UISwitch) {
    if switchState.on {
    if ios8 {
    //Show a Message iOS 8
    var alert = UIAlertController(title: NSLocalizedString("Pro_title", comment: "Pro Version Needed!"), message: NSLocalizedString("Pro_msg", comment: "You are not using the Dream Notes Pro version, this feature is unavailable"), preferredStyle: UIAlertControllerStyle.Alert)
    alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
    self.presentViewController(alert, animated: true, completion: nil)
    } else {
    let alert = UIAlertView()
    alert.title = NSLocalizedString("Pro_title", comment: "Pro Version Needed!")
    alert.message = NSLocalizedString("Pro_msg", comment: "You are not using the Dream Notes Pro version, this feature is unavailable")
    alert.addButtonWithTitle("OK")
    alert.show()
    
    }
    mySwitch.setOn(false, animated: true);
    }
    }
    #endif
    
    #if LITE
    
    // Banner iAd
    
    //var bannerView: ADBannerView?
    func bannerViewDidLoadAd(banner: ADBannerView!) {
    self.bannerView?.hidden = false
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
    return willLeave
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
    self.bannerView?.hidden = true
    }
    
    // Dream Notes Pro Ad
    
    func dreamNotesProAd() {
    var neverRate = NSUserDefaults.standardUserDefaults().boolForKey("neverRate")
    var numLaunches = NSUserDefaults.standardUserDefaults().integerForKey("numLaunches") + 1
    
    if (!neverRate && (numLaunches == iMinSessions || numLaunches >= (iMinSessions + iTryAgainSessions + 1))){
    showBuyMe()
    numLaunches = iMinSessions + 1
    }
    NSUserDefaults.standardUserDefaults().setInteger(numLaunches, forKey: "numLaunches")
    }
    
    func showBuyMe() {
    
    var alert = UIAlertController(title: NSLocalizedString("Buy_pro_title", comment: "Dream Notes Pro"), message: NSLocalizedString("Buy_pro_msg", comment: "Unlock daily notification and get rid of the ads with Dream Notes Pro Version"), preferredStyle: UIAlertControllerStyle.Alert)
    
    alert.addAction(UIAlertAction(title: NSLocalizedString("No-thx", comment: "No Thanks"), style: UIAlertActionStyle.Default, handler: {
    alertAction in
    NSUserDefaults.standardUserDefaults().setBool(true, forKey: "neverRate")
    alert.dismissViewControllerAnimated(true, completion: nil)
    }))
    alert.addAction(UIAlertAction(title: NSLocalizedString("Maybe", comment: "Maybe Later"), style: UIAlertActionStyle.Default, handler: { alertAction in
    alert.dismissViewControllerAnimated(true, completion: nil)
    }))
    alert.addAction(UIAlertAction(title: NSLocalizedString("Buy", comment: "Buy it!"), style: UIAlertActionStyle.Default, handler: { alertAction in
    UIApplication.sharedApplication().openURL(NSURL(string : "https://itunes.apple.com/us/app/dream-notes-pro/id963530051?l=pt&ls=1&mt=8")!)
    alert.dismissViewControllerAnimated(true, completion: nil)
    }))
    self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    #endif
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
