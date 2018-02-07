//
//  BedtimeCalcViewController.swift
//  DreamNotes
//
//  Created by Vinícius Bazanelli on 20/06/15.
//  Copyright (c) 2015 Baza Inc. All rights reserved.
//

import UIKit

class BedtimeCalcViewController: UIViewController, UITabBarDelegate {
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "swirl_pattern.png")!)
        
        let attrs = [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: UIFont(name: "Chalkduster", size: 24)!
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
        ModoInicial()
    }
    
    @IBAction func calculate(_ sender: AnyObject) {
        let dtTime = dtPicker.date
        CalcularHoras(dtTime)
    }
    
    func ModoInicial() {
        scrollView.contentOffset.x = 0
        scrollView.contentOffset.y = 0
        lblHead.isHidden = false
        dtPicker.isHidden = false
        btCalculate.isHidden = false
        lblTime1.isHidden = true
        lblTime2.isHidden = true
        lblTime3.isHidden = true
        lblTime4.isHidden = true
        lbltitle.isHidden = true
        lblInfo.isHidden = true
        lblHead.font = UIFont(name: "Chalkduster", size: 16.0)
    }
    
    func ModoExibicao() {
        lbltitle.isHidden = false
        lblTime1.isHidden = false
        lblTime2.isHidden = false
        lblTime3.isHidden = false
        lblTime4.isHidden = false
        lblInfo.isHidden = false
    }
    
    func CalcularHoras(_ tempo: Date) {
        
        let calendar = Calendar.autoupdatingCurrent
        let dateFormatter = DateFormatter()
        let timeFormat = DateFormatter.Style.short
        dateFormatter.timeStyle = timeFormat
        
        let newdate4 = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: -270, to: tempo, options: NSCalendar.Options.searchBackwards)!
        let tempo4 = dateFormatter.string(from: newdate4)
        lblTime4.text = tempo4
        lblTime4.backgroundColor = UIColor(red: 0xFF/255, green: 0xE1/255, blue: 0x1A/255, alpha: 1.0)
        
        let newdate3 = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: -360, to: tempo, options: NSCalendar.Options.searchBackwards)!
        let tempo3 = dateFormatter.string(from: newdate3)
        lblTime3.text = tempo3
        lblTime3.backgroundColor = UIColor(red: 0xbd/255, green: 0xd4/255, blue: 0x13/255, alpha: 1.0)
        
        let newdate2 = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: -450, to: tempo, options: NSCalendar.Options.searchBackwards)!
        let tempo2 = dateFormatter.string(from: newdate2)
        lblTime2.text = tempo2
        lblTime2.backgroundColor = UIColor(red: 0x4f/255, green: 0xd4/255, blue: 0x4c/255, alpha: 1.0)
        
        let newdate1 = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: -540, to: tempo, options: NSCalendar.Options.searchBackwards)!
        let tempo1 = dateFormatter.string(from: newdate1)
        lblTime1.text = tempo1
        lblTime1.backgroundColor = UIColor(red: 0x4c/255, green: 0x8c/255, blue: 0x0d/255, alpha: 1.0)
        
        ModoExibicao()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
