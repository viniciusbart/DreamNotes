//
//  BedtimeCalcViewController.swift
//  DreamNotes
//
//  Created by Vinícius Bazanelli on 20/06/15.
//  Copyright (c) 2015 Baza Inc. All rights reserved.
//

import UIKit
import iAd

class BedtimeCalcViewController: UIViewController, UITabBarDelegate, ADBannerViewDelegate {
    
    @IBOutlet weak var dtPicker: UIDatePicker!
    @IBOutlet weak var btCalculate: UIButton!
    @IBOutlet weak var lblTime1: UILabel!
    @IBOutlet weak var lblTime2: UILabel!
    @IBOutlet weak var lblTime3: UILabel!
    @IBOutlet weak var lblTime4: UILabel!
    @IBOutlet weak var lblInfo: UILabel!
    @IBOutlet weak var lbltitle: UILabel!
    @IBOutlet weak var lblHead: UILabel!
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
            self.view.backgroundColor = UIColor(patternImage: UIImage(named: "swirl_pattern.png")!)
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
    
    
    @IBAction func calculate(sender: AnyObject) {
        let dtTime = dtPicker.date
        CalcularHoras(dtTime)
    }
    
    
    func ModoInicial() {
        scrollView.contentOffset.x = 0
        scrollView.contentOffset.y = 0
        lblHead.hidden = false
        dtPicker.hidden = false
        btCalculate.hidden = false
        lblTime1.hidden = true
        lblTime2.hidden = true
        lblTime3.hidden = true
        lblTime4.hidden = true
        lbltitle.hidden = true
        lblInfo.hidden = true
        lblHead.font = UIFont(name: "Chalkduster", size: 16.0)
    }
    
    func ModoExibicao() {
        lbltitle.hidden = false
        lblTime1.hidden = false
        lblTime2.hidden = false
        lblTime3.hidden = false
        lblTime4.hidden = false
        lblInfo.hidden = false
    }
    
    func ModoFree() {
        dtPicker.hidden = true
        btCalculate.hidden = true
        lblTime1.hidden = true
        lblTime2.hidden = true
        lblTime3.hidden = true
        lblTime4.hidden = true
        lblHead.hidden = true
        lblInfo.hidden = true
        lbltitle.text = NSLocalizedString("Not_using", comment: "⚠️You are not using Dream Notes Pro version⚠️")
        lbltitle.font = UIFont(name: "Chalkduster", size: 11.5)
    }
    
    func CalcularHoras(tempo: NSDate) {
        
        let calendar = NSCalendar.autoupdatingCurrentCalendar()
        let dateFormatter = NSDateFormatter()
        let timeFormat = NSDateFormatterStyle.ShortStyle
        dateFormatter.timeStyle = timeFormat
        
        let newdate4 = calendar.dateByAddingUnit(NSCalendarUnit.Minute, value: -270, toDate: tempo, options: NSCalendarOptions.SearchBackwards)!
        //let newdate4 = calendar.dateByAddingUnit(NSCalendarUnit.Minute, value: -270, toDate: tempo, options: NSCalendarOptions.WrapComponents)!
        let tempo4 = dateFormatter.stringFromDate(newdate4)
        lblTime4.text = tempo4
        lblTime4.backgroundColor = UIColor(red: 0xFF/255, green: 0xE1/255, blue: 0x1A/255, alpha: 1.0)
        
        let newdate3 = calendar.dateByAddingUnit(NSCalendarUnit.Minute, value: -360, toDate: tempo, options: NSCalendarOptions.SearchBackwards)!
        let tempo3 = dateFormatter.stringFromDate(newdate3)
        lblTime3.text = tempo3
        lblTime3.backgroundColor = UIColor(red: 0xbd/255, green: 0xd4/255, blue: 0x13/255, alpha: 1.0)
        
        let newdate2 = calendar.dateByAddingUnit(NSCalendarUnit.Minute, value: -450, toDate: tempo, options: NSCalendarOptions.SearchBackwards)!
        let tempo2 = dateFormatter.stringFromDate(newdate2)
        lblTime2.text = tempo2
        lblTime2.backgroundColor = UIColor(red: 0x4f/255, green: 0xd4/255, blue: 0x4c/255, alpha: 1.0)
        
        let newdate1 = calendar.dateByAddingUnit(NSCalendarUnit.Minute, value: -540, toDate: tempo, options: NSCalendarOptions.SearchBackwards)!
        let tempo1 = dateFormatter.stringFromDate(newdate1)
        lblTime1.text = tempo1
        lblTime1.backgroundColor = UIColor(red: 0x4c/255, green: 0x8c/255, blue: 0x0d/255, alpha: 1.0)
        
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
