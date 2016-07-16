//
//  Dreams.swift
//  DreamNotes
//
//  Created by Vinícius Bazanelli on 01/10/14.
//  Copyright (c) 2014 Baza Inc. All rights reserved.
//

import Foundation
import CoreData
@objc(Dreams)

class Dreams: NSManagedObject {

    @NSManaged var texto: String
    @NSManaged var data: String
    @NSManaged var timestamp: NSDate
    
    // An automatically generated note title, based on the first line of the note
    var title: String {
        // split into lines
        let lines = texto.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [String]
        if lines[0].characters.count<19{
            return lines[0]
        }else{
            let line = texto.componentsSeparatedByCharactersInSet(NSCharacterSet.newlineCharacterSet()) as [NSString]
            let titulo = line[0].substringToIndex(19)
            return titulo
        }
    
    }

}
