//
//  Helper.swift
//  Sleep Tracker Extension
//
//  Created by Vinícius Bazanelli on 04/01/18.
//  Copyright © 2018 Baza Inc. All rights reserved.
//

import UIKit

public class Helper: NSObject {

    static func printALog(_ str: String, saveLog: Bool = false){
        print("\(str)")
        if saveLog{ NSLog("\(str)")}
    }
}
