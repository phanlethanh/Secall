//
//  ContactEntity.swift
//  Secall
//
//  Created by BiBrain on 7/6/15.
//  Copyright (c) 2015 thuattc. All rights reserved.
//

import Foundation
import CoreData

class ContactEntity: NSManagedObject {

    @NSManaged var avatar: String
    @NSManaged var phoneNumber: String
    @NSManaged var name: String

    convenience init(avatar:String,name:String,phoneNumber:String, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let entity = NSEntityDescription.entityForName("ContactEntity", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.avatar = "default_contact"
        self.name = name
        self.phoneNumber = phoneNumber
    }
}
