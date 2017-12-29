//
//  WakeUpViewController.swift
//  DreamNotes
//
//  Created by Vinícius Bazanelli on 25/06/15.
//  Copyright (c) 2015 Baza Inc. All rights reserved.
//

import UIKit

class WakeUpViewController: UIViewController, UITabBarDelegate {
    
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
    
    override func viewDidLoad() {
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "arches.png")!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.setStatusBarStyle(UIStatusBarStyle.default, animated: true)
        ModoInicial()
    }
    
    @IBAction func calculate(_ sender: UIButton) {
        let dtNow = Date()
        CalcularHoras(dtNow)
    }

    func ModoInicial() {
        scrollView.contentOffset.x = 0
        scrollView.contentOffset.y = 0
        lblHead.isHidden = false
        lblSubHead.isHidden = false
        btNow.isHidden = false
        lblTime3.isHidden = true
        lblTime4.isHidden = true
        lblTime5.isHidden = true
        lblTime6.isHidden = true
        lblTitle.isHidden = true
        lblInfo.isHidden = true
        lblHead.font = UIFont(name: "Chalkduster", size: 19.0)
    }
    
    func ModoExibicao() {
        lblTime3.isHidden = false
        lblTime4.isHidden = false
        lblTime5.isHidden = false
        lblTime6.isHidden = false
        lblTitle.isHidden = false
        lblInfo.isHidden = false
    }
    
    
    func CalcularHoras(_ tempo: Date) {
        let calendar = Calendar.autoupdatingCurrent
        let dateFormatter = DateFormatter()
        let timeFormat = DateFormatter.Style.short
        dateFormatter.timeStyle = timeFormat
        
        let newdate3 = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: 40+270, to: tempo, options: NSCalendar.Options.matchStrictly)!
        let tempo3 = dateFormatter.string(from: newdate3)
        lblTime3.text = tempo3
        lblTime3.backgroundColor = UIColor(red: 0xFF/255, green: 0xE1/255, blue: 0x1A/255, alpha: 1.0)
        
        let newdate4 = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: 400, to: tempo, options: NSCalendar.Options.matchStrictly)!
        let tempo4 = dateFormatter.string(from: newdate4)
        lblTime4.text = tempo4
        lblTime4.backgroundColor = UIColor(red: 0xbd/255, green: 0xd4/255, blue: 0x13/255, alpha: 1.0)
        
        let newdate5 = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: 490, to: tempo, options: NSCalendar.Options.matchStrictly)!
        let tempo5 = dateFormatter.string(from: newdate5)
        lblTime5.text = tempo5
        lblTime5.backgroundColor = UIColor(red: 0x4f/255, green: 0xd4/255, blue: 0x4c/255, alpha: 1.0)
        
        let newdate6 = (calendar as NSCalendar).date(byAdding: NSCalendar.Unit.minute, value: 580, to: tempo, options: NSCalendar.Options.matchStrictly)!
        let tempo6 = dateFormatter.string(from: newdate6)
        lblTime6.text = tempo6
        lblTime6.backgroundColor = UIColor(red: 0x4c/255, green: 0x8c/255, blue: 0x0d/255, alpha: 1.0)
        
        ModoExibicao()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
