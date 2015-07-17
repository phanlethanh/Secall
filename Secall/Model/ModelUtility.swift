//
//  ModelUtility.swift
//  SeCall
//
//  Created by BrainBi on 5/23/15.
//  Copyright (c) 2015 ThuatCao. All rights reserved.
//

import Foundation
import CoreData

class ModelUtility {
    
    static let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!

    // Profile
    class func GenerateProfile(profile:ProfileEntity) -> Bool{
        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("could not save  \(error)")
            return false
        }
        return true
    }
    
    class func ChangeProfile(value:String, key:String) -> Bool{
        let fetchRequest = NSFetchRequest(entityName: "ProfileEntity")
        var error: NSError?
        let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]?
        if let profiles = fetchedResults{
            let currentProfile = profiles[profiles.count - 1]
            currentProfile.setValue(value, forKey: key)
            managedObjectContext.save(nil)
        }
        return true
    }
    
    class func ChangeProfilePassword(value:String) -> Bool{
        return ChangeProfile(value, key: "password")
    }
    class func GetProfile() -> ProfileEntity{
        let fetchRequest = NSFetchRequest(entityName: "ProfileEntity")
        var error: NSError?
        let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]?
        var result: ProfileEntity!
        if let results = fetchedResults{
            print(results.count)
            result = results[results.count - 1] as! ProfileEntity
        } else {
            println("Could not fetch \(error)")
        }
        return result
    }
    
    class func deleteProfile() -> Bool{
        let managedObjectContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
        let request = NSFetchRequest(entityName: "ProfileEntity")
        let fetchedResults = managedObjectContext.executeFetchRequest(request, error: nil) as! [ProfileEntity]
        
        for profile:ProfileEntity in fetchedResults{
            managedObjectContext.deleteObject(profile as NSManagedObject!)
        }
        var error: NSError?
        managedObjectContext.save(&error)
        if error != nil {
            print("Error when detete")
            return false
        }
        return true
    }
    
    class func deleteAllProfile() -> Bool{
            let fetchRequest = NSFetchRequest(entityName: "ProfileEntity")
            var error: NSError?
            let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as! [ProfileEntity]
            
            if error != nil {
                print("Error when execute")
                return false
                
            }
            for contact:ProfileEntity in fetchedResults{
                managedObjectContext.deleteObject(contact as NSManagedObject!)
            }
            
            managedObjectContext.save(&error)
            if error != nil {
                print("Error when detete")
                return false
            }
            return true
    }
    
    // contact
    class func GetContacts() -> [ContactEntity]{
        let fetchRequest = NSFetchRequest(entityName: "ContactEntity")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        var error: NSError?
        let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as! [ContactEntity]
        
        if fetchedResults.count > 0 {
            print(fetchedResults.count)
        }
        return fetchedResults
    }
    
    class func CheckExistContact(phone:String)->Bool{
        var listContacts = GetContacts()
        for (var i:Int = 0; i < listContacts.count; i++ ) {
            if listContacts[i].phoneNumber == phone {
                return true
            }
        }
        return false
    }
    class func AddContact(contact:ContactEntity) -> Bool{
        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("could not save  \(error)")
            return false
        }
        return true
    }
    
    class func EditContact(index:Int, newName:String, newPhone:String) -> Bool{
        //
        let fetchRequest = NSFetchRequest(entityName: "ContactEntity")
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]
        var error: NSError?
        let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as! [NSManagedObject]
        
        let currentContact = fetchedResults[index]
        currentContact.setValue(newName, forKey: "name")
        currentContact.setValue(newPhone, forKey: "phoneNumber")
        managedObjectContext.save(&error)
        if error != nil{
            return false
        }
        return true
    }
    
    class func DeleteContact(index:Int)->Bool{
        let fetchRequest = NSFetchRequest(entityName: "ContactEntity")
        var error: NSError?
        let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as! [ContactEntity]
        
        if error != nil {
            print("Error when execute")
            return false
        }
        
        var deleteContact = fetchedResults[index]
        managedObjectContext.deleteObject(deleteContact)
        
        self.managedObjectContext.save(&error)
        if error != nil {
            print("Error when detete")
            return false
        }
        return true
    }
    
    class func DeleteAllContact() -> Bool{
        let fetchRequest = NSFetchRequest(entityName: "ContactEntity")
        var error: NSError?
        let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as! [ContactEntity]

        if error != nil {
            print("Error when execute")
            return false
            
        }
        for contact:ContactEntity in fetchedResults{
            managedObjectContext.deleteObject(contact as NSManagedObject!)
        }
        
        managedObjectContext.save(&error)
        if error != nil {
            print("Error when detete")
            return false
        }
        return true
    }
    
    //call log
    class  func GetCallLogs() -> [CallLogEntity]{
        let fetchRequest = NSFetchRequest(entityName: "CallLogEntity")
        var error: NSError?
        let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as! [CallLogEntity]
        return fetchedResults
    }
    
    class func AddCallLog(log:CallLogEntity) -> Bool{
        var error: NSError?
        if !managedObjectContext.save(&error) {
            println("could not save  \(error)")
            return false
        }
        return true
    }
    
    class func DeleteCallLog(index:Int)->Bool{
        let fetchRequest = NSFetchRequest(entityName: "CallLogEntity")
        var error: NSError?
        let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as! [CallLogEntity]
        
        if error != nil {
            print("Error when execute")
            return false
        }
        
        var deleteContact = fetchedResults[index]
        managedObjectContext.deleteObject(deleteContact)
        
        self.managedObjectContext.save(&error)
        if error != nil {
            print("Error when detete")
            return false
        }
        return true
    }
    
    class func DeleteAllCallLog() -> Bool{
        let fetchRequest = NSFetchRequest(entityName: "CallLogEntity")
        var error: NSError?
        let fetchedResults = managedObjectContext.executeFetchRequest(fetchRequest, error: &error) as! [CallLogEntity]
        if error != nil {
            print("Error when execute")
            return false
        }
        for contact:CallLogEntity in fetchedResults{
            managedObjectContext.deleteObject(contact as NSManagedObject!)
        }
        managedObjectContext.save(&error)
        if error != nil {
            print("Error when detete")
            return false
        }
        return true
    }
    
    class func CheckContactName(phoneNumber:String) ->String{
        var lsContacts = GetContacts()
        for var i:Int = 0; i < lsContacts.count; i++ {
            if phoneNumber == lsContacts[i].phoneNumber {
                return lsContacts[i].name
            }
        }
        return phoneNumber
    }
}