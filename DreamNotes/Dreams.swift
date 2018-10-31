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
    @NSManaged var timestamp: Date

}
