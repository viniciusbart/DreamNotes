//
//  WakeUpViewController.swift
//  DreamNotes
//
//  Created by Vinícius Bazanelli on 25/06/15.
//  Copyright (c) 2015 Baza Inc. All rights reserved.
//

import UIKit
import iAd

class WakeUpViewController: UIViewController, UITabBarDelegate, ADBannerViewDelegate  {
    
    @IBOutlet weak var lblHead: UILabel!
    @IBOutlet weak var lblSubHead: UILabel!
    @IBOutlet weak var btNow: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblTime3: UILabel!
    @IBOutlet weak var lblTime4: UILabel!
    @IBOutlet weak var lblTime5: UILabel!
    @IBOutlet weak var lblTime6: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    
    var bannerView: ADBannerView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        #if LITE
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "nuvens-tristes.png")!)
            self.canDisplayBannerAds = true
            self.bannerView?.delegate = self
            self.bannerView?.hidden = true
        #else
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "arches.png")!)
        #endif
    }
    
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.Default, animated: true)
        #if LITE
            ModoFree()
        #else
            ModoInicial()
        #endif
    }
    
    // Banner iAd
    func bannerViewDidLoadAd(banner: ADBannerView!) {
        self.bannerView?.hidden = false
    }
    
    func bannerViewActionShouldBegin(banner: ADBannerView!, willLeaveApplication willLeave: Bool) -> Bool {
        return willLeave
    }
    
    func bannerView(banner: ADBannerView!, didFailToReceiveAdWithError error: NSError!) {
        self.bannerView?.hidden = true
    }
    // **********
    
    
    @IBAction func calculate(sender: UIButton) {
        let dtNow = NSDate()
        CalcularHoras(dtNow)
    }
    
    func ModoFree() {
        lblHead.hidden = true
        lblSubHead.hidden = true
        btNow.hidden = true
        lblTime3.hidden = true
        lblTime4.hidden = true
        lblTime5.hidden = true
        lblTime6.hidden = true
        
        lblInfo.text = NSLocalizedString("Not_using2", comment: "⚠️ Oops, this is a paid feature sorry ! ⚠️")
        lblInfo.font = UIFont(name: "Chalkduster", size: 11.5)
        
        lblTitle.text = NSLocalizedString("I_think", comment: "I think you should make clouds happy and take a look at us in App Store ❍ᴥ❍")
        //lblTitle.font = UIFont(name: "Chalkduster", size: 10.0)
        
        
    }
    
    func ModoInicial() {
        scrollView.contentOffset.x = 0
        scrollView.contentOffset.y = 0
        lblHead.hidden = false
        lblSubHead.hidden = false
        btNow.hidden = false
        lblTime3.hidden = true
        lblTime4.hidden = true
        lblTime5.hidden = true
        lblTime6.hidden = true
        lblTitle.hidden = true
        lblInfo.hidden = true
        lblHead.font = UIFont(name: "Chalkduster", size: 19.0)
    }
    
    func ModoExibicao() {
        lblTime3.hidden = false
        lblTime4.hidden = false
        lblTime5.hidden = false
        lblTime6.hidden = false
        lblTitle.hidden = false
        lblInfo.hidden = false
    }
    
    
    func CalcularHoras(tempo: NSDate) {
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        let dateFormatter = NSDateFormatter()
        let timeFormat = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = timeFormat
        
        let newdate3 = calendar.dateByAddingUnit(NSCalendarUnit.Minute, value: 40+270, toDate: tempo, options: NSCalendarOptions.MatchStrictly)!
        let tempo3 = dateFormatter.stringFromDate(newdate3)
        lblTime3.text = tempo3
        lblTime3.backgroundColor = UIColor(red: 0xFF/255, green: 0xE1/255, blue: 0x1A/255, alpha: 1.0)
        
        let newdate4 = calendar.dateByAddingUnit(NSCalendarUnit.Minute, value: 400, toDate: tempo, options: NSCalendarOptions.MatchStrictly)!
        let tempo4 = dateFormatter.stringFromDate(newdate4)
        lblTime4.text = tempo4
        lblTime4.backgroundColor = UIColor(red: 0xbd/255, green: 0xd4/255, blue: 0x13/255, alpha: 1.0)
        
        let newdate5 = calendar.dateByAddingUnit(NSCalendarUnit.Minute, value: 490, toDate: tempo, options: NSCalendarOptions.MatchStrictly)!
        let tempo5 = dateFormatter.stringFromDate(newdate5)
        lblTime5.text = tempo5
        lblTime5.backgroundColor = UIColor(red: 0x4f/255, green: 0xd4/255, blue: 0x4c/255, alpha: 1.0)
        
        let newdate6 = calendar.dateByAddingUnit(NSCalendarUnit.Minute, value: 580, toDate: tempo, options: NSCalendarOptions.MatchStrictly)!
        let tempo6 = dateFormatter.stringFromDate(newdate6)
        lblTime6.text = tempo6
        lblTime6.backgroundColor = UIColor(red: 0x4c/255, green: 0x8c/255, blue: 0x0d/255, alpha: 1.0)
        
        ModoExibicao()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    // Get the new view controller using segue.destinationViewController.
    // Pass the selected object to the new view controller.
    }
    */
    
}
