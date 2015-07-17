//
//  ProfileEntity.swift
//  Secall
//
//  Created by BiBrain on 7/6/15.
//  Copyright (c) 2015 thuattc. All rights reserved.
//

import Foundation
import CoreData

class ProfileEntity: NSManagedObject {

    @NSManaged var avatar: String
    @NSManaged var displayName: String
    @NSManaged var phoneNumber: String
    @NSManaged var password: String
    
    convenience init(phoneNumber: String, password: String, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let entity = NSEntityDescription.entityForName("ProfileEntity", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.displayName = ""
        self.phoneNumber = phoneNumber
        self.password = password
        self.avatar = "default.png"
    }


}
