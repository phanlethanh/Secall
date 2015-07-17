//
//  CallLogEntity.swift
//  Secall
//
//  Created by BiBrain on 7/6/15.
//  Copyright (c) 2015 thuattc. All rights reserved.
//

import Foundation
import CoreData

class CallLogEntity: NSManagedObject {

    @NSManaged var avatar: String
    @NSManaged var name: String
    @NSManaged var phoneNumber: String
    @NSManaged var time: String
    @NSManaged var type: String
    @NSManaged var duration: String
    
    convenience init(name:String,phoneNumber:String, avatar:String,duration:String,time:String,type:String, insertIntoManagedObjectContext context: NSManagedObjectContext!) {
        let entity = NSEntityDescription.entityForName("CallLogEntity", inManagedObjectContext: context)!
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.avatar = avatar
        self.name = name
        self.duration = duration
        self.time = time
        self.type = type
        self.phoneNumber = phoneNumber
    }


}
