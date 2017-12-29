//
//  ShareVC.swift
//  DreamNotes
//
//  Created by Vinícius Bazanelli on 11/11/14.
//  Copyright (c) 2014 Baza Inc. All rights reserved.
//

import UIKit
import iAd

class ShareVC: UIViewController, ADBannerViewDelegate {
    
    var texto:String = ""
    var data:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(patternImage: UIImage(named: "catcher")!)
        
        let backBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action:#selector(ShareVC.goHome) )
        navigationItem.setLeftBarButton(backBarButtonItem, animated: true)
        
        let firstActivityItem = texto + NSLocalizedString("Write", comment: "\nWritten on ") + data + "\nDream Notes App ✏️📓💭 #DreamNotes"
        let activityViewController: UIActivityViewController = UIActivityViewController(activityItems: [firstActivityItem], applicationActivities: nil)
        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func goHome() {
        navigationController?.popViewController(animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
