//
//  TabBarViewController.swift
//  DreamNotes
//
//  Created by Vinícius Bazanelli on 28/12/17.
//  Copyright © 2017 Baza Inc. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let transperentBlackColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.5)
        
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0.0)
        transperentBlackColor.setFill()
        UIRectFill(rect)
        
        if let image = UIGraphicsGetImageFromCurrentImageContext() {
            tabBar.backgroundImage = image
        }
        
        UIGraphicsEndImageContext()
    }
}

